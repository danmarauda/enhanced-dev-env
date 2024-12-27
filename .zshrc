# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
ZSH_THEME="powerlevel10k/powerlevel10k"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Plugin configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#999999"

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_DEFAULT_OPTS="
  --height 40% --border --preview-window=right:60%
  --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
  --bind='ctrl-space:toggle-preview'
  --bind='ctrl-d:half-page-down'
  --bind='ctrl-u:half-page-up'
  --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
"

# Plugins
plugins=(
  # Core functionality
  git
  git-flow
  git-extras
  gitfast
  github
  
  # Development tools
  docker
  docker-compose
  kubectl
  helm
  terraform
  aws
  
  # Python development
  python
  pip
  virtualenv
  poetry
  pyenv
  
  # Node.js development
  node
  npm
  nvm
  yarn
  
  # Enhanced functionality
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
  alias-tips
  command-not-found
  
  # Directory navigation
  fzf
  ripgrep
  zoxide
  autojump
  z
  
  # Productivity
  thefuck
  extract
  sudo
  web-search
  copypath
  copyfile
  dirhistory
  history
  jsontools
  
  # Completion enhancements
  zsh-completions
  zsh-history-substring-search
  
  # UI improvements
  colored-man-pages
  colorize
  
  # MacOS specific
  macos
  brew
  iterm2
)

# Load additional completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Key bindings configuration

# History navigation
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey '^R' fzf-history-widget

# Cursor movement
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^F' forward-char
bindkey '^B' backward-char
bindkey '^[f' forward-word
bindkey '^[b' backward-word

# Text manipulation
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word
bindkey '^[d' kill-word
bindkey '^H' backward-delete-char
bindkey '^?' backward-delete-char
bindkey '^[[3;5~' kill-word
bindkey '^[[3^' kill-word
bindkey '^Y' yank
bindkey '^[y' yank-pop

# Line editing
bindkey '^L' clear-screen
bindkey '^J' accept-line
bindkey '^M' accept-line
bindkey '^[.' insert-last-word
bindkey '^[_' insert-last-word
bindkey '^[/' redo
bindkey '^_' undo
bindkey '^X^E' edit-command-line

# Directory navigation
bindkey '^[^[[D' dirhistory_zle_dirhistory_back
bindkey '^[^[[C' dirhistory_zle_dirhistory_future
bindkey '^[^[[A' dirhistory_zle_dirhistory_up
bindkey '^[^[[B' dirhistory_zle_dirhistory_down

# Completion
bindkey '^I' complete-word
bindkey '^[[Z' reverse-menu-complete
bindkey '^X^X' _complete_debug
bindkey '^X?' _complete_debug
bindkey '^Xa' _expand_alias
bindkey '^Xc' _correct_word
bindkey '^XC' _correct_line
bindkey '^Xd' _list_expansions
bindkey '^Xe' _expand_word
bindkey '^Xh' _complete_help
bindkey '^Xm' _most_recent_file
bindkey '^Xn' _next_tags
bindkey '^Xt' _complete_tag
bindkey '^X~' _bash_list-choices

# FZF integration
bindkey '^T' fzf-file-widget
bindkey '^[c' fzf-cd-widget
bindkey '\ec' fzf-cd-widget

# Custom function bindings
bindkey -s '^O' 'lfcd\n'  # Directory browser
bindkey -s '^[OP' 'thefuck\n'  # Correction
bindkey -s '^[h' 'history 1\n'  # Show full history

# Vim-style bindings
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward
bindkey -M vicmd '^[' vi-cmd-mode
bindkey -M viins '^[' vi-cmd-mode

# Custom function key mappings
bindkey '^[OS' free-up-space  # F4
bindkey '^[OQ' quick-backup   # F2
bindkey '^[[15~' proj-search  # F5
bindkey '^[[17~' docker-stats # F6
bindkey '^[[18~' git-status   # F7
bindkey '^[[19~' system-stats # F8

# Custom Functions for Function Keys
free-up-space() {
    echo "🧹 Cleaning up system..."
    echo "Docker cleanup..."
    docker system prune -f
    echo "Package cleanup..."
    uv-clean
    echo "Cache cleanup..."
    rm -rf ~/.cache/pip
    echo "✨ Cleanup complete!"
    zle reset-prompt
}
zle -N free-up-space

quick-backup() {
    local date=$(date +%Y%m%d_%H%M%S)
    echo "💾 Creating quick backup..."
    tar -czf "backup_$date.tar.gz" .* * 2>/dev/null
    echo "✅ Backup created: backup_$date.tar.gz"
    zle reset-prompt
}
zle -N quick-backup

proj-search() {
    local selected=$(fd -t d -d 2 . ~/projects | fzf --preview 'tree -L 2 {}')
    if [ -n "$selected" ]; then
        cd "$selected"
    fi
    zle reset-prompt
}
zle -N proj-search

docker-stats() {
    echo "🐳 Docker Status:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    zle reset-prompt
}
zle -N docker-stats

git-status() {
    echo "📊 Git Status:"
    git status -s
    git log --oneline -n 5
    zle reset-prompt
}
zle -N git-status

system-stats() {
    echo "💻 System Stats:"
    echo "Memory:"
    free -h
    echo "\nDisk:"
    df -h /
    echo "\nCPU:"
    top -bn1 | head -n 3
    zle reset-prompt
}
zle -N system-stats

# Mode indicator
function zle-line-init zle-keymap-select {
    case ${KEYMAP} in
        vicmd)      print -n '\e[2 q';; # block cursor for command mode
        viins|main) print -n '\e[6 q';; # line cursor for insert mode
    esac
}
zle -N zle-line-init
zle -N zle-keymap-select

# Plugin-specific settings
# The Fuck configuration
eval $(thefuck --alias)
export THEFUCK_REQUIRE_CONFIRMATION=false
export THEFUCK_PRIORITY="git_hook_bypass=1000"

# Auto-suggestions configuration
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# History configuration
HISTSIZE=1000000
SAVEHIST=1000000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

# Completion configuration
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

source $ZSH/oh-my-zsh.sh

# Environment configuration
export LANG=en_US.UTF-8
export EDITOR='vim'

# UV Configuration
export UV_SYSTEM_PYTHON=1
export UV_VIRTUALENV_AUTO_CREATE=1
export UV_NO_MODIFY_PATH=1
export UV_CACHE_DIR="$HOME/.cache/uv"
export UV_CONFIG_DIR="$HOME/.config/uv"
export UV_VIRTUALENV_DIR="$HOME/.local/share/virtualenvs"
export VIRTUAL_ENV_DISABLE_PROMPT=1

# UV Performance Optimizations
export UV_PARALLEL_JOBS=$(nproc)
export UV_BUILD_JOBS=$(nproc)
export UV_NO_CACHE=0
export UV_HTTP_TIMEOUT=30
export UV_PREFER_BINARY=1

# Modern CLI replacements
alias ls='exa --group-directories-first --icons'
alias ll='exa -l --group-directories-first --icons'
alias la='exa -la --group-directories-first --icons'
alias lt='exa --tree --level=2 --icons'
alias cat='bat --style=plain'
alias du='dust'
alias grep='rg'
alias find='fd'
alias top='htop'
alias diff='delta'
alias cd='z'

# Python and UV aliases
alias python='python3'
alias pip="uv pip"
alias pip3="uv pip"
alias python-install="uv pip install"
alias python-uninstall="uv pip uninstall"
alias python-update="uv pip install --upgrade"
alias python-freeze="uv pip freeze"
alias python-deps="uv pip install -r requirements.txt"
alias venv="uv venv"
alias venv-create="uv venv .venv --python=$(which python3)"
alias venv-activate="source .venv/bin/activate"
alias venv-deactivate="deactivate"
alias venv-remove="rm -rf .venv"

# Development shortcuts
alias dc='docker-compose'
alias g='git'
alias t='tmux'
alias v='vim'

# Harbor shortcuts and functions
alias h='harbor'
alias hp='harbor project'
alias hr='harbor repo'
alias hi='harbor image'

# Harbor template validation and migration
alias hv='python3 ~/.config/harbor/tools/template_validator.py'
alias harbor-validate='hv --validate'
alias harbor-migrate='hv --migrate'

# Harbor template management functions
harbor-template-check() {
    local template=$1
    if [ -z "$template" ]; then
        echo "Usage: harbor-template-check <template-file>"
        return 1
    fi
    
    echo "🔍 Checking template: $template"
    harbor-validate "$template"
}

harbor-template-migrate() {
    local template=$1
    local version=$2
    local output=$3
    
    if [ -z "$template" ] || [ -z "$version" ]; then
        echo "Usage: harbor-template-migrate <template-file> <version> [output-file]"
        return 1
    fi
    
    echo "🔄 Migrating template to version $version"
    if [ -z "$output" ]; then
        harbor-migrate "$template" --migrate "$version"
    else
        harbor-migrate "$template" --migrate "$version" --output "$output"
    fi
}

harbor-template-init() {
    local type=$1
    local name=${2:-$(basename $PWD)}
    local templates_dir="$HOME/.config/harbor/templates"
    
    if [ -z "$type" ]; then
        echo "Available templates:"
        ls -1 $templates_dir | sed 's/\.yml$//'
        return 0
    fi
    
    local template="$templates_dir/$type.yml"
    if [ ! -f "$template" ]; then
        echo "❌ Template not found: $type"
        echo "Available templates:"
        ls -1 $templates_dir | sed 's/\.yml$//'
        return 1
    fi
    
    echo "🚀 Initializing $type template for $name"
    cp "$template" .harbor.yml
    sed -i "" "s/project: .*/project: $name/" .harbor.yml
    
    # Validate the new template
    harbor-template-check .harbor.yml
}

# Harbor utility functions
harbor-init() {
    local project=${1:-$(basename $PWD)}
    echo "🚢 Initializing Harbor project: $project"
    
    # Create harbor config if it doesn't exist
    if [ ! -f ".harbor.yml" ]; then
        echo "project: $project
repositories:
  - name: app
    public: false
    vulnerability_scanning: true
    image_scanning: true" > .harbor.yml
        echo "✅ Created .harbor.yml configuration"
    fi
    
    # Initialize harbor project
    harbor project create $project
    echo "✅ Harbor project initialized"
}

harbor-setup() {
    echo "🔧 Setting up Harbor environment..."
    
    # Check if config exists
    if [ ! -f "$HOME/.harbor/config.yml" ]; then
        mkdir -p $HOME/.harbor
        echo "harbor:
  url: https://harbor.example.com
  username: $USER
  # Add your token in the next line
  token: \"\"" > $HOME/.harbor/config.yml
        echo "⚠️ Please edit $HOME/.harbor/config.yml with your Harbor credentials"
    fi
    
    echo "✅ Harbor setup complete"
}

harbor-scan() {
    local image=$1
    if [ -z "$image" ]; then
        echo "Usage: harbor-scan <image:tag>"
        return 1
    fi
    
    echo "🔍 Scanning image: $image"
    harbor image scan $image --wait
    harbor image scan-report $image
}

harbor-clean() {
    local repo=$1
    local keep=${2:-10}
    
    if [ -z "$repo" ]; then
        echo "Usage: harbor-clean <repository> [keep-count]"
        return 1
    fi
    
    echo "🧹 Cleaning repository: $repo (keeping $keep latest tags)"
    harbor repo gc $repo --retain-count $keep --untagged
}

harbor-sync() {
    local src=$1
    local dest=$2
    
    if [ -z "$src" ] || [ -z "$dest" ]; then
        echo "Usage: harbor-sync <source-image> <destination-image>"
        return 1
    fi
    
    echo "🔄 Syncing $src to $dest"
    harbor image copy $src $dest
}

# AI/ML Development shortcuts
alias oi='interpreter'  # Open Interpreter
alias nb='jupyter notebook'
alias lab='jupyter lab'
alias torch-gpu='python -c "import torch; print(f\"GPU Available: {torch.cuda.is_available()}\nDevice Count: {torch.cuda.device_count()}\nDevice Names: {[torch.cuda.get_device_name(i) for i in range(torch.cuda.device_count())]}\nCurrent Device: {torch.cuda.current_device()}\n\")"'

# Model Server Shortcuts
alias ollama-serve='ollama serve'
alias lmstudio-serve='/opt/lmstudio/lmstudio --api-only'
alias textgen-serve='cd /opt/text-generation-webui && python server.py --api'

# MCP Server Shortcuts - Python
alias mcp-fetch='cd /opt/mcp/src/fetch && python -m mcp_server_fetch'
alias mcp-git='cd /opt/mcp/src/git && python -m mcp_server_git'
alias mcp-sentry='cd /opt/mcp/src/sentry && python -m mcp_server_sentry'
alias mcp-sqlite='cd /opt/mcp/src/sqlite && python -m mcp_server_sqlite'
alias mcp-time='cd /opt/mcp/src/time && python -m mcp_server_time'

# MCP Server Shortcuts - TypeScript
alias mcp-aws='cd /opt/mcp/src/aws-kb-retrieval-server && npm start'
alias mcp-brave='cd /opt/mcp/src/brave-search && npm start'
alias mcp-everart='cd /opt/mcp/src/everart && npm start'
alias mcp-everything='cd /opt/mcp/src/everything && npm start'
alias mcp-fs='cd /opt/mcp/src/filesystem && npm start'
alias mcp-gdrive='cd /opt/mcp/src/gdrive && npm start'
alias mcp-github='cd /opt/mcp/src/github && npm start'
alias mcp-gitlab='cd /opt/mcp/src/gitlab && npm start'
alias mcp-maps='cd /opt/mcp/src/google-maps && npm start'
alias mcp-memory='cd /opt/mcp/src/memory && npm start'
alias mcp-postgres='cd /opt/mcp/src/postgres && npm start'
alias mcp-puppeteer='cd /opt/mcp/src/puppeteer && npm start'
alias mcp-seq='cd /opt/mcp/src/sequentialthinking && npm start'
alias mcp-slack='cd /opt/mcp/src/slack && npm start'

# MCP Server Management Functions
mcp-servers() {
    local command=$1
    shift
    local servers=($@)
    
    # If no servers specified, use all
    if [ ${#servers[@]} -eq 0 ]; then
        servers=(
            # Python servers
            fetch git sentry sqlite time
            # TypeScript servers
            aws brave everart everything fs gdrive github gitlab
            maps memory postgres puppeteer seq slack
        )
    fi
    
    case $command in
        "start")
            echo "🚀 Starting MCP servers: ${servers[@]}"
            for server in ${servers[@]}; do
                mcp-$server &
            done
            ;;
        "stop")
            echo "🛑 Stopping MCP servers: ${servers[@]}"
            for server in ${servers[@]}; do
                pkill -f "mcp-$server"
            done
            ;;
        "status")
            echo "📊 MCP Servers Status:"
            for server in ${servers[@]}; do
                printf "%-15s" "$server:"
                if pgrep -f "mcp-$server" >/dev/null; then
                    echo "✅ Running"
                else
                    echo "❌ Stopped"
                fi
            done
            ;;
        "restart")
            mcp-servers stop ${servers[@]}
            sleep 2
            mcp-servers start ${servers[@]}
            ;;
        *)
            echo "Usage: mcp-servers <start|stop|status|restart> [server...]"
            echo "\nAvailable servers:"
            echo "Python: fetch, git, sentry, sqlite, time"
            echo "TypeScript: aws, brave, everart, everything, fs, gdrive, github,"
            echo "           gitlab, maps, memory, postgres, puppeteer, seq, slack"
            ;;
    esac
}

# MCP Environment Configuration
mcp-config() {
    local server=$1
    
    case $server in
        "github"|"gitlab"|"slack")
            echo "Enter API token for $server: "
            read -s token
            export $(echo $server | tr '[:lower:]' '[:upper:]')_TOKEN=$token
            echo "✅ Token set for $server"
            ;;
        "aws")
            echo "Enter AWS Access Key ID: "
            read -s aws_key
            echo "Enter AWS Secret Access Key: "
            read -s aws_secret
            echo "Enter AWS Region: "
            read aws_region
            export AWS_ACCESS_KEY_ID=$aws_key
            export AWS_SECRET_ACCESS_KEY=$aws_secret
            export AWS_REGION=$aws_region
            echo "✅ AWS credentials configured"
            ;;
        "brave")
            echo "Enter Brave Search API Key: "
            read -s api_key
            export BRAVE_API_KEY=$api_key
            echo "✅ Brave Search API key set"
            ;;
        "google")
            echo "Enter path to Google credentials file: "
            read creds_path
            export GOOGLE_CREDENTIALS=$creds_path
            echo "Enter Google Maps API Key: "
            read -s maps_key
            export GOOGLE_MAPS_API_KEY=$maps_key
            echo "✅ Google credentials configured"
            ;;
        "postgres")
            echo "Enter PostgreSQL connection string: "
            read -s conn_string
            export POSTGRES_CONNECTION_STRING=$conn_string
            echo "✅ PostgreSQL connection configured"
            ;;
        "sentry")
            echo "Enter Sentry DSN: "
            read -s dsn
            export SENTRY_DSN=$dsn
            echo "✅ Sentry DSN configured"
            ;;
        *)
            echo "Usage: mcp-config <server>"
            echo "\nConfigurable servers:"
            echo "  github    - GitHub API token"
            echo "  gitlab    - GitLab API token"
            echo "  slack     - Slack API token"
            echo "  aws       - AWS credentials"
            echo "  brave     - Brave Search API key"
            echo "  google    - Google credentials"
            echo "  postgres  - PostgreSQL connection"
            echo "  sentry    - Sentry DSN"
            ;;
    esac
}

# Model Context Protocol Shortcuts
alias mcp-py='cd /opt/mcp/implementations/python && python -m mcp.server'
alias mcp-rs='cd /opt/mcp/implementations/rust && ./target/release/mcp-server'
alias mcp-test='cd /opt/mcp && pytest tests/'
alias mcp-bench='cd /opt/mcp && python benchmarks/run.py'

# MCP Functions
mcp() {
    local cmd=$1
    local impl=${2:-python}
    local args="${@:3}"
    
    case $cmd in
        "start")
            case $impl in
                "python"|"py")
                    echo "Starting Python MCP server..."
                    mcp-py $args
                    ;;
                "rust"|"rs")
                    echo "Starting Rust MCP server..."
                    mcp-rs $args
                    ;;
                *)
                    echo "Usage: mcp start <python|rust> [args...]"
                    ;;
            esac
            ;;
        "test")
            echo "Running MCP tests..."
            mcp-test $args
            ;;
        "bench")
            echo "Running MCP benchmarks..."
            mcp-bench $args
            ;;
        "build")
            case $impl in
                "python"|"py")
                    echo "Building Python implementation..."
                    cd /opt/mcp/implementations/python && \
                    python -m pip install -e ".[dev]"
                    ;;
                "rust"|"rs")
                    echo "Building Rust implementation..."
                    cd /opt/mcp/implementations/rust && \
                    cargo build --release
                    ;;
                *)
                    echo "Usage: mcp build <python|rust>"
                    ;;
            esac
            ;;
        *)
            echo "Usage: mcp <start|test|bench|build> [implementation] [args...]"
            echo "Examples:"
            echo "  mcp start python"
            echo "  mcp start rust"
            echo "  mcp test"
            echo "  mcp bench"
            echo "  mcp build rust"
            ;;
    esac
}

# MCP Protocol Testing
mcp-proto() {
    local cmd=$1
    local args="${@:2}"
    
    case $cmd in
        "validate")
            echo "Validating MCP protocol..."
            cd /opt/mcp && python -m mcp.validate $args
            ;;
        "generate")
            echo "Generating MCP protocol files..."
            cd /opt/mcp && python -m mcp.generate $args
            ;;
        "check")
            echo "Checking MCP implementation..."
            cd /opt/mcp && python -m mcp.check $args
            ;;
        *)
            echo "Usage: mcp-proto <validate|generate|check> [args...]"
            echo "Examples:"
            echo "  mcp-proto validate"
            echo "  mcp-proto generate --lang python"
            echo "  mcp-proto check implementations/python"
            ;;
    esac
}

# Model Management Functions
model-server() {
    local server=$1
    local model=$2
    local args="${@:3}"
    
    case $server in
        "ollama")
            if [ -z "$model" ]; then
                echo "Available Ollama models:"
                ollama list
                return
            fi
            echo "Starting Ollama with model: $model"
            ollama run $model $args
            ;;
        "lmstudio")
            echo "Starting LM Studio Server..."
            lmstudio-serve $args
            ;;
        "textgen")
            if [ -z "$model" ]; then
                echo "Starting Text Generation WebUI..."
                textgen-serve $args
            else
                echo "Starting Text Generation WebUI with model: $model"
                textgen-serve --model $model $args
            fi
            ;;
        *)
            echo "Usage: model-server <ollama|lmstudio|textgen> [model] [args...]"
            echo "Examples:"
            echo "  model-server ollama llama2"
            echo "  model-server lmstudio"
            echo "  model-server textgen mistral-7b"
            ;;
    esac
}

# Model Download Functions
model-download() {
    local server=$1
    local model=$2
    
    case $server in
        "ollama")
            if [ -z "$model" ]; then
                echo "Usage: model-download ollama <model>"
                return 1
            fi
            echo "Downloading model for Ollama: $model"
            ollama pull $model
            ;;
        "huggingface")
            if [ -z "$model" ]; then
                echo "Usage: model-download huggingface <model>"
                return 1
            fi
            echo "Downloading model from Hugging Face: $model"
            python -c "from huggingface_hub import snapshot_download; snapshot_download('$model')"
            ;;
        *)
            echo "Usage: model-download <ollama|huggingface> <model>"
            echo "Examples:"
            echo "  model-download ollama llama2"
            echo "  model-download huggingface mistralai/Mistral-7B-v0.1"
            ;;
    esac
}

# Model Information Functions
model-info() {
    local server=$1
    local model=$2
    
    case $server in
        "ollama")
            if [ -z "$model" ]; then
                echo "Listing all Ollama models:"
                ollama list
            else
                echo "Model information for $model:"
                ollama show $model
            fi
            ;;
        *)
            echo "Usage: model-info <ollama> [model]"
            echo "Examples:"
            echo "  model-info ollama"
            echo "  model-info ollama llama2"
            ;;
    esac
}

# Model Context Functions
model-ctx() {
    local command=$1
    local server=$2
    local args="${@:3}"
    
    case $command in
        "start")
            case $server in
                "all")
                    echo "Starting all model servers..."
                    ollama-serve &
                    lmstudio-serve &
                    textgen-serve &
                    ;;
                *)
                    model-server $server $args
                    ;;
            esac
            ;;
        "stop")
            case $server in
                "all")
                    echo "Stopping all model servers..."
                    pkill -f ollama
                    pkill -f lmstudio
                    pkill -f "text-generation-webui"
                    ;;
                "ollama")
                    pkill -f ollama
                    ;;
                "lmstudio")
                    pkill -f lmstudio
                    ;;
                "textgen")
                    pkill -f "text-generation-webui"
                    ;;
                *)
                    echo "Usage: model-ctx stop <all|ollama|lmstudio|textgen>"
                    ;;
            esac
            ;;
        "status")
            echo "Checking model server status..."
            echo "\nOllama:"
            pgrep -f ollama >/dev/null && echo "✓ Running" || echo "✗ Stopped"
            echo "\nLM Studio:"
            pgrep -f lmstudio >/dev/null && echo "✓ Running" || echo "✗ Stopped"
            echo "\nText Generation WebUI:"
            pgrep -f "text-generation-webui" >/dev/null && echo "✓ Running" || echo "✗ Stopped"
            ;;
        *)
            echo "Usage: model-ctx <start|stop|status> [server] [args...]"
            echo "Examples:"
            echo "  model-ctx start all"
            echo "  model-ctx start ollama llama2"
            echo "  model-ctx stop all"
            echo "  model-ctx status"
            ;;
    esac
}

# Performance profiling shortcuts
alias profile-mem='memray run'
alias profile-mem-flamegraph='memray flamegraph'
alias profile-cpu='py-spy record -o profile.svg --'
alias profile-viz='viztracer'
alias profile-line='kernprof -l -v'
alias profile-all='scalene'

# Benchmark function
benchmark() {
    if [ -z "$1" ]; then
        echo "Usage: benchmark \"command\" [iterations]"
        return 1
    fi
    iterations=${2:-5}
    pytest-benchmark --benchmark-only "benchmark_test.py::test_benchmark" --benchmark-min-rounds=$iterations
}

# Quick ML environment setup
setup-ml() {
    local proj_name=${1:-$(basename $PWD)}
    echo "🚀 Setting up ML project: $proj_name"
    
    # Create directories
    mkdir -p {data/{raw,processed,interim,external},models,notebooks,src/{data,features,models,visualization},configs,logs}
    
    # Create basic files
    echo "# $proj_name
ML project structure created with setup-ml" > README.md
    
    # Create .gitignore
    echo "data/
models/
*.pyc
.ipynb_checkpoints/
.DS_Store
logs/
*.pt
*.pth
.env" > .gitignore
    
    # Create example notebook
    echo '{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# '$proj_name' Analysis Notebook"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "source": [
    "import pandas as pd\n",
    "import numpy as np\n",
    "import matplotlib.pyplot as plt\n",
    "import seaborn as sns\n",
    "\n",
    "%matplotlib inline\n",
    "plt.style.use('\''seaborn'\'')"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}' > notebooks/exploration.ipynb
    
    # Create DVC configuration if available
    if command -v dvc >/dev/null 2>&1; then
        dvc init
        echo "data/" > .dvcignore
    fi
    
    echo "✅ ML project structure created successfully!"
    echo "📁 Directory structure:"
    tree -L 2
    echo "\n📝 Next steps:"
    echo "1. Add your data to data/raw/"
    echo "2. Create virtual environment: venv-create"
    echo "3. Start Jupyter: lab or nb"
}

# Quick LLM project setup
setup-llm() {
    local proj_name=${1:-$(basename $PWD)}
    echo "🤖 Setting up LLM project: $proj_name"
    
    # Create directories
    mkdir -p {data,prompts,models,src/{agents,chains,embeddings,utils},configs,logs}
    
    # Create basic files
    echo "# $proj_name
LLM project structure created with setup-llm" > README.md
    
    # Create .gitignore
    echo "*.env
__pycache__/
.DS_Store
logs/
data/
.chroma/
vectors/
.env" > .gitignore
    
    # Create example .env template
    echo "OPENAI_API_KEY=
ANTHROPIC_API_KEY=
MODEL_PATH=
CUDA_VISIBLE_DEVICES=" > .env.template
    
    # Create basic prompt template
    mkdir -p prompts/templates
    echo "system: You are a helpful AI assistant.
human: {{user_input}}
assistant: Let me help you with that." > prompts/templates/base.txt
    
    echo "✅ LLM project structure created successfully!"
    echo "📁 Directory structure:"
    tree -L 2
    echo "\n📝 Next steps:"
    echo "1. Copy .env.template to .env and add your API keys"
    echo "2. Create virtual environment: venv-create"
    echo "3. Start development: v src/main.py"
}

# Quick project templates
alias new-fastapi='uv-scaffold fastapi'
alias new-ml='setup-ml'
alias new-llm='setup-llm'

# Source UV utility functions
[[ -f $UV_CONFIG_DIR/functions.sh ]] && source $UV_CONFIG_DIR/functions.sh

# Initialize modern tools
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Function to benchmark commands
bench() {
    hyperfine --warmup 3 "$@"
}

# Initialize Python virtual environment if it exists
[[ -d .venv ]] && source .venv/bin/activate

# Local customizations
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local