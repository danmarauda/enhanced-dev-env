#!/bin/bash

# Setup script for development environment
# Usage: curl -fsSL https://raw.githubusercontent.com/yourusername/dev-environment/main/setup.sh | bash

set -e

echo "🚀 Setting up development environment..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (sudo)"
    exit 1
fi

# Configuration
WORKSPACE_DIR="/opt/dev-environment"
USER_HOME="/home/$SUDO_USER"
GITHUB_RAW="https://raw.githubusercontent.com/yourusername/dev-environment/main"

# Install essential dependencies
echo "📦 Installing essential packages..."
apt-get update
apt-get install -y \
    curl \
    git \
    docker.io \
    docker-compose \
    build-essential \
    python3 \
    python3-pip \
    zsh \
    vim \
    tmux \
    jq

# Install Rust
echo "🦀 Installing Rust..."
su - $SUDO_USER -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'

# Install UV Package Manager
echo "📦 Installing UV package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Harbor
echo "🚢 Installing Harbor..."
curl -fsSL https://raw.githubusercontent.com/avinor/harbor/main/install.sh | sh

# Clone Open Interpreter dev branch
echo "🤖 Installing Open Interpreter (dev branch)..."
git clone -b dev https://github.com/KillianLucas/open-interpreter.git /tmp/open-interpreter
cd /tmp/open-interpreter
/root/.cargo/bin/uv pip install -e .

# Create workspace directory
echo "📁 Creating workspace..."
mkdir -p $WORKSPACE_DIR
chown -R $SUDO_USER:$SUDO_USER $WORKSPACE_DIR

# Download configuration files
echo "⚙️ Downloading configurations..."
mkdir -p $WORKSPACE_DIR/config
cd $WORKSPACE_DIR

# Download and set up configurations
for file in Dockerfile docker-compose.yml .zshrc UV_COMMANDS.md DEVELOPMENT_HISTORY.md; do
    curl -o $file "$GITHUB_RAW/$file"
done

# Create Harbor configurations directory
mkdir -p $USER_HOME/.harbor/templates
chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.harbor

# Download Harbor templates
cat > $USER_HOME/.harbor/templates/basic.yml << 'EOL'
project: default
repositories:
  - name: app
    public: false
    vulnerability_scanning: true
    image_scanning: true
EOL

cat > $USER_HOME/.harbor/templates/advanced.yml << 'EOL'
project: default
repositories:
  - name: backend
    public: false
    vulnerability_scanning: true
    image_scanning: true
    retention:
      days: 30
      count: 10
    webhooks:
      - url: https://notify.example.com
        events: [PUSH, SCAN]
    policies:
      - type: vulnerability
        severity: high
      - type: tag_retention
        count: 10
        pattern: "v*"
  - name: frontend
    public: true
    vulnerability_scanning: true
    retention:
      days: 14
    webhooks:
      - url: https://slack.example.com
        events: [SCAN_COMPLETED, PUSH]
EOL

cat > $USER_HOME/.harbor/templates/microservices.yml << 'EOL'
project: default
global_policies:
  vulnerability_scanning: true
  image_scanning: true
  retention:
    days: 30
    count: 20
repositories:
  - name: api-gateway
    public: false
    policies:
      - type: vulnerability
        severity: critical
  - name: auth-service
    public: false
    policies:
      - type: vulnerability
        severity: high
  - name: user-service
    public: false
  - name: payment-service
    public: false
    policies:
      - type: vulnerability
        severity: critical
webhooks:
  - url: https://monitor.example.com
    events: [SCANNING_FAILED, VULNERABILITY_FOUND]
EOL

# Add advanced Harbor functions to .zshrc
cat >> $USER_HOME/.zshrc << 'EOL'

# Advanced Harbor Functions

# Template management
harbor-template() {
    local action=$1
    local name=$2
    local template_dir="$HOME/.harbor/templates"
    
    case $action in
        list)
            echo "Available templates:"
            ls -1 $template_dir | sed 's/\.yml$//'
            ;;
        use)
            if [ -f "$template_dir/$name.yml" ]; then
                cp "$template_dir/$name.yml" .harbor.yml
                echo "✅ Applied template: $name"
            else
                echo "❌ Template not found: $name"
                return 1
            fi
            ;;
        save)
            if [ -f ".harbor.yml" ]; then
                cp .harbor.yml "$template_dir/$name.yml"
                echo "✅ Saved current config as template: $name"
            else
                echo "❌ No .harbor.yml found in current directory"
                return 1
            fi
            ;;
        *)
            echo "Usage: harbor-template <list|use|save> [template-name]"
            return 1
            ;;
    esac
}

# Vulnerability management
harbor-vuln-report() {
    local repo=$1
    local severity=${2:-"CRITICAL,HIGH"}
    local format=${3:-"text"}  # text or json
    
    if [ -z "$repo" ]; then
        echo "Usage: harbor-vuln-report <repository> [severity] [format]"
        return 1
    fi
    
    echo "🔍 Scanning vulnerabilities in $repo..."
    local result=$(harbor image scan $repo --wait && harbor image scan-report $repo)
    
    case $format in
        json)
            echo $result | jq ".vulnerabilities[] | select(.severity | IN(\"$severity\"))"
            ;;
        text)
            echo $result | jq -r ".vulnerabilities[] | select(.severity | IN(\"$severity\")) | \"\(.severity): \(.package) \(.version) - \(.description)\""
            ;;
    esac
}

# Multi-registry operations
harbor-mirror() {
    local src_registry=$1
    local dest_registry=$2
    local repo=$3
    local tags=${4:-"latest"}
    
    if [ -z "$src_registry" ] || [ -z "$dest_registry" ] || [ -z "$repo" ]; then
        echo "Usage: harbor-mirror <src-registry> <dest-registry> <repository> [tags]"
        return 1
    fi
    
    echo "🔄 Mirroring $repo from $src_registry to $dest_registry..."
    for tag in ${tags//,/ }; do
        harbor-sync "$src_registry/$repo:$tag" "$dest_registry/$repo:$tag"
    done
}

# Batch operations
harbor-batch() {
    local action=$1
    local project=$2
    shift 2
    
    if [ -z "$action" ] || [ -z "$project" ]; then
        echo "Usage: harbor-batch <scan|clean|delete> <project> [options]"
        return 1
    fi
    
    case $action in
        scan)
            echo "🔍 Batch scanning repositories in $project..."
            for repo in $(hr list $project); do
                harbor-scan "$project/$repo:latest"
            done
            ;;
        clean)
            local keep=${1:-10}
            echo "🧹 Batch cleaning repositories in $project (keeping $keep latest)..."
            for repo in $(hr list $project); do
                harbor-clean "$project/$repo" $keep
            done
            ;;
        delete)
            echo "⚠️ This will delete all repositories in $project"
            read -p "Are you sure? [y/N] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                for repo in $(hr list $project); do
                    hr delete "$project/$repo"
                done
            fi
            ;;
        *)
            echo "Unknown action: $action"
            return 1
            ;;
    esac
}

# Project statistics
harbor-stats() {
    local project=$1
    
    if [ -z "$project" ]; then
        echo "Usage: harbor-stats <project>"
        return 1
    fi
    
    echo "📊 Statistics for project: $project"
    echo "\nRepositories:"
    hr list $project | wc -l
    
    echo "\nTotal images:"
    local total_images=0
    for repo in $(hr list $project); do
        total_images=$((total_images + $(hi list "$project/$repo" | wc -l)))
    done
    echo $total_images
    
    echo "\nVulnerabilities by severity:"
    for repo in $(hr list $project); do
        harbor-vuln-report "$project/$repo:latest" "CRITICAL,HIGH,MEDIUM" json | \
        jq -r .severity | sort | uniq -c
    done
}

# Monitoring setup
harbor-monitor() {
    local project=$1
    local webhook_url=$2
    
    if [ -z "$project" ] || [ -z "$webhook_url" ]; then
        echo "Usage: harbor-monitor <project> <webhook-url>"
        return 1
    fi
    
    for repo in $(hr list $project); do
        harbor repo set-webhook "$project/$repo" \
            --url "$webhook_url" \
            --events "SCANNING_COMPLETED,SCANNING_FAILED,VULNERABILITY_FOUND"
    done
    
    echo "✅ Monitoring configured for all repositories in $project"
}

EOL

# Set permissions
chown $SUDO_USER:$SUDO_USER $USER_HOME/.zshrc

# Set up Docker
usermod -aG docker $SUDO_USER
systemctl enable docker
systemctl start docker

# Final setup
echo "🎉 Setup complete! Next steps:"
echo "1. Log out and log back in for group changes to take effect"
echo "2. Configure Harbor credentials: harbor-setup"
echo "3. Start the development environment: cd $WORKSPACE_DIR && docker-compose up -d"
echo "4. Access the environment: docker-compose exec dev zsh"