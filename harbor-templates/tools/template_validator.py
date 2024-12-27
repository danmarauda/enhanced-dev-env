#!/usr/bin/env python3
"""
Harbor Template Validator and Migration Tool
Validates Harbor template configurations and assists with migrations.
"""

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Optional, Union
import yaml
from rich.console import Console
from rich.table import Table
from rich.progress import track

console = Console()

class HarborTemplateValidator:
    def __init__(self, template_path: str):
        self.template_path = Path(template_path)
        self.errors: List[str] = []
        self.warnings: List[str] = []
        
    def load_template(self) -> Optional[Dict]:
        """Load and parse YAML template."""
        try:
            with open(self.template_path) as f:
                return yaml.safe_load(f)
        except Exception as e:
            self.errors.append(f"Failed to load template: {e}")
            return None

    def validate_structure(self, config: Dict) -> bool:
        """Validate basic template structure."""
        required_fields = ['project', 'repositories']
        for field in required_fields:
            if field not in config:
                self.errors.append(f"Missing required field: {field}")
                return False
        return True

    def validate_repositories(self, config: Dict) -> bool:
        """Validate repository configurations."""
        valid = True
        if 'repositories' not in config:
            return valid

        for repo in config['repositories']:
            if 'name' not in repo:
                self.errors.append("Repository missing name field")
                valid = False
                continue

            # Check policies
            if 'policies' in repo:
                for policy in repo['policies']:
                    if 'type' not in policy:
                        self.errors.append(f"Policy in {repo['name']} missing type")
                        valid = False

            # Check webhooks
            if 'webhooks' in repo:
                for webhook in repo['webhooks']:
                    if 'url' not in webhook or 'events' not in webhook:
                        self.errors.append(f"Invalid webhook in {repo['name']}")
                        valid = False

        return valid

    def validate_monitoring(self, config: Dict) -> bool:
        """Validate monitoring configuration."""
        valid = True
        if 'monitoring' in config:
            monitoring = config['monitoring']
            if 'webhooks' in monitoring:
                for webhook in monitoring['webhooks']:
                    if 'url' not in webhook or 'events' not in webhook:
                        self.errors.append("Invalid monitoring webhook configuration")
                        valid = False
        return valid

    def check_best_practices(self, config: Dict) -> None:
        """Check for best practices and add warnings."""
        # Check global policies
        if 'global_policies' not in config:
            self.warnings.append("Consider adding global policies")

        # Check vulnerability scanning
        for repo in config.get('repositories', []):
            if 'vulnerability_scanning' not in repo:
                self.warnings.append(f"Repository {repo.get('name', 'unknown')} missing vulnerability scanning")

        # Check retention policies
        if not any('retention' in repo for repo in config.get('repositories', [])):
            self.warnings.append("Consider adding retention policies")

    def validate(self) -> bool:
        """Perform full template validation."""
        config = self.load_template()
        if not config:
            return False

        valid = True
        valid &= self.validate_structure(config)
        valid &= self.validate_repositories(config)
        valid &= self.validate_monitoring(config)
        self.check_best_practices(config)

        return valid

    def print_report(self) -> None:
        """Print validation report."""
        table = Table(title=f"Validation Report: {self.template_path.name}")
        table.add_column("Type", style="cyan")
        table.add_column("Message", style="white")

        if not self.errors and not self.warnings:
            table.add_row("Success", "Template is valid with no warnings!")
        else:
            for error in self.errors:
                table.add_row("Error", error, style="red")
            for warning in self.warnings:
                table.add_row("Warning", warning, style="yellow")

        console.print(table)

class TemplateMigrator:
    def __init__(self, source_path: str, target_version: str):
        self.source_path = Path(source_path)
        self.target_version = target_version
        self.migrations_path = Path(__file__).parent / "migrations"

    def load_migrations(self) -> List[Dict]:
        """Load migration scripts for target version."""
        try:
            with open(self.migrations_path / f"v{self.target_version}.json") as f:
                return json.load(f)
        except FileNotFoundError:
            console.print(f"No migrations found for version {self.target_version}", style="yellow")
            return []

    def apply_migrations(self, config: Dict) -> Dict:
        """Apply migrations to configuration."""
        migrations = self.load_migrations()
        
        for migration in track(migrations, description="Applying migrations..."):
            operation = migration.get('operation')
            if operation == 'add_field':
                self._add_field(config, migration)
            elif operation == 'rename_field':
                self._rename_field(config, migration)
            elif operation == 'remove_field':
                self._remove_field(config, migration)
            elif operation == 'modify_field':
                self._modify_field(config, migration)

        return config

    def _add_field(self, config: Dict, migration: Dict) -> None:
        """Add new field to config."""
        path = migration['path'].split('.')
        value = migration['value']
        current = config
        for part in path[:-1]:
            current = current.setdefault(part, {})
        current[path[-1]] = value

    def _rename_field(self, config: Dict, migration: Dict) -> None:
        """Rename field in config."""
        old_path = migration['old_path'].split('.')
        new_path = migration['new_path'].split('.')
        self._move_field(config, old_path, new_path)

    def _remove_field(self, config: Dict, migration: Dict) -> None:
        """Remove field from config."""
        path = migration['path'].split('.')
        current = config
        for part in path[:-1]:
            if part not in current:
                return
            current = current[part]
        if path[-1] in current:
            del current[path[-1]]

    def _modify_field(self, config: Dict, migration: Dict) -> None:
        """Modify field value based on rules."""
        path = migration['path'].split('.')
        transform = migration['transform']
        current = config
        for part in path[:-1]:
            if part not in current:
                return
            current = current[part]
        if path[-1] in current:
            value = current[path[-1]]
            if transform.get('type') == 'map':
                current[path[-1]] = transform['mapping'].get(value, value)
            elif transform.get('type') == 'format':
                current[path[-1]] = transform['format'].format(value=value)

    def _move_field(self, obj: Dict, old_path: List[str], new_path: List[str]) -> None:
        """Move field from old path to new path."""
        # Get value from old path
        current = obj
        for part in old_path[:-1]:
            if part not in current:
                return
            current = current[part]
        if old_path[-1] not in current:
            return
        value = current[old_path[-1]]
        
        # Set value at new path
        current = obj
        for part in new_path[:-1]:
            current = current.setdefault(part, {})
        current[new_path[-1]] = value
        
        # Remove old field
        current = obj
        for part in old_path[:-1]:
            current = current[part]
        del current[old_path[-1]]

def main():
    parser = argparse.ArgumentParser(description="Harbor Template Validator and Migrator")
    parser.add_argument("template", help="Path to template file")
    parser.add_argument("--validate", action="store_true", help="Validate template")
    parser.add_argument("--migrate", help="Migrate to specified version")
    parser.add_argument("--output", help="Output path for migrated template")
    args = parser.parse_args()

    if args.validate:
        validator = HarborTemplateValidator(args.template)
        is_valid = validator.validate()
        validator.print_report()
        sys.exit(0 if is_valid else 1)

    if args.migrate:
        migrator = TemplateMigrator(args.template, args.migrate)
        with open(args.template) as f:
            config = yaml.safe_load(f)
        
        migrated_config = migrator.apply_migrations(config)
        
        # Validate migrated config
        validator = HarborTemplateValidator(args.template)
        validator.validate()
        
        output_path = args.output or args.template
        with open(output_path, 'w') as f:
            yaml.dump(migrated_config, f, default_flow_style=False)
        
        console.print(f"✓ Template migrated successfully to {output_path}", style="green")

if __name__ == "__main__":
    main()