# Enhanced Development Environment with MCP Servers

A comprehensive development environment featuring UV package manager, Open Interpreter (dev branch), and Model Context Protocol servers.

## 🚀 Features

- UV package manager for fast Python package management
- Modern CLI tools (exa, bat, ripgrep, etc.)
- Zsh with Oh My Zsh and useful plugins
- Development tools (git, vim, tmux, etc.)
- Rust-based performance tools
- Docker and Vagrant configurations
- Optimized for Python development

## 🛠️ Included Tools

### Python Tools
- UV package manager
- IPython
- Black (formatter)
- isort (import sorter)
- mypy (type checker)
- ruff (linter)
- pytest (testing)
- debugpy (debugging)
- pre-commit

### Modern CLI Tools
- exa (modern ls)
- bat (modern cat)
- ripgrep (modern grep)
- fd-find (modern find)
- delta (git diff)
- zoxide (smart cd)
- starship (shell prompt)
- dust (modern du)
- hyperfine (benchmarking)

### Development Tools
- Git
- Vim
- Tmux
- HTTPx
- Docker
- Docker Compose

## 🚀 Quick Start

### Using Docker

```bash
# Build and start the container
docker-compose up -d

# Enter the container
docker-compose exec dev zsh

# Or use the run command
docker-compose run --rm dev
```

### Using Vagrant

```bash
# Start the VM
vagrant up

# SSH into the VM
vagrant ssh

# Destroy the VM
vagrant destroy
```

## 📁 Directory Structure

```
.
├── Dockerfile           # Container definition
├── docker-compose.yml   # Container orchestration
├── Vagrantfile         # VM definition
├── .zshrc              # Shell configuration
├── workspace/          # Your projects directory
└── .config/
    └── uv/            # UV configuration
```

## 🔧 Usage

### Package Management

```bash
# Install packages
python-install pandas numpy

# Create virtual environment
venv-create

# Activate virtual environment
venv-activate

# Install project dependencies
python-deps
```

### Development Workflow

```bash
# Initialize new project
uv-init myproject

# Create project from template
uv-scaffold fastapi myapi

# Set up testing
uv-test-setup

# Check project structure
uv-project-check
```

### Maintenance

```bash
# Clean UV cache
uv-clean

# Rebuild virtual environment
uv-venv-rebuild

# Check system
uv-doctor
```

## ⚙️ Customization

### Adding Local Configuration

Create `~/.zshrc.local` for machine-specific settings:

```bash
# Local environment variables
export MY_VAR="value"

# Local aliases
alias myalias="mycommand"
```

### Modifying UV Configuration

Edit `~/.config/uv/uvconfig.toml`:

```toml
[cache]
maximum_size = "10GB"
shared = true

[network]
concurrent_downloads = 8
```

## 🔍 Troubleshooting

### Common Issues

1. **Package Installation Problems**
   ```bash
   uv-clean
   uv-doctor
   ```

2. **Virtual Environment Issues**
   ```bash
   uv-venv-rebuild
   ```

3. **Performance Issues**
   ```bash
   bench "your-command"  # Uses hyperfine
   ```

## 📦 Maintenance

### Container Updates

```bash
# Rebuild container with updates
docker-compose build --no-cache

# Pull latest base image
docker-compose pull
```

### VM Updates

```bash
# Update VM
vagrant provision

# Update box
vagrant box update
```

## 🔒 Security Notes

- Container runs as non-root user
- SSH keys mounted read-only
- Git config mounted read-only
- Minimal base image
- Regular security updates