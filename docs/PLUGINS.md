# Zsh Plugins Guide

A comprehensive guide to all installed plugins and their functionality in our enhanced Zsh configuration.

## 🔌 Plugin Categories

### Core Functionality
| Plugin | Description | Key Features |
|--------|-------------|--------------|
| `git` | Git integration | Aliases, completions, workflows |
| `git-flow` | Git flow integration | Branch management, feature workflow |
| `git-extras` | Additional git tools | Repository management, statistics |
| `gitfast` | Fast git completions | Optimized completion cache |
| `github` | GitHub CLI integration | PR management, issue tracking |

### Development Tools
| Plugin | Description | Key Features |
|--------|-------------|--------------|
| `docker` | Docker integration | Aliases, completions |
| `docker-compose` | Compose integration | Service management |
| `kubectl` | Kubernetes CLI | Cluster management |
| `helm` | Helm package manager | Chart management |
| `terraform` | Infrastructure as Code | State management |
| `aws` | AWS CLI integration | Service management |

### Python Development
| Plugin | Description | Key Features |
|--------|-------------|--------------|
| `python` | Python integration | Interpreter management |
| `pip` | Package management | Installation helpers |
| `virtualenv` | Environment management | Creation, activation |
| `poetry` | Modern dependency management | Project management |
| `pyenv` | Python version management | Version switching |

### Node.js Development
| Plugin | Description | Key Features |
|--------|-------------|--------------|
| `node` | Node.js integration | Version management |
| `npm` | Package management | Installation helpers |
| `nvm` | Node version management | Version switching |
| `yarn` | Alternative package manager | Project management |

### Enhanced Functionality
| Plugin | Description | Key Features |
|--------|-------------|--------------|
| `zsh-autosuggestions` | Command suggestions | History-based completion |
| `zsh-syntax-highlighting` | Syntax highlighting | Command validation |
| `fast-syntax-highlighting` | Enhanced highlighting | Parameter highlighting |
| `alias-tips` | Alias reminders | Usage suggestions |
| `command-not-found` | Command lookup | Package suggestions |

### Directory Navigation
| Plugin | Description | Key Features |
|--------|-------------|--------------|
| `fzf` | Fuzzy finder | File/directory search |
| `ripgrep` | Fast search | Content search |
| `zoxide` | Smart directory jumping | Frecency-based |
| `autojump` | Directory jumping | Learning jumps |
| `z` | Directory tracking | Frecency database |

### Productivity Tools
| Plugin | Description | Key Features |
|--------|-------------|--------------|
| `thefuck` | Command correction | Mistake fixing |
| `extract` | Archive extraction | Format detection |
| `sudo` | Sudo integration | Permission handling |
| `web-search` | Quick web search | Multiple engines |
| `copypath` | Path copying | Clipboard integration |
| `copyfile` | File copying | Content copying |
| `dirhistory` | Directory navigation | History tracking |
| `jsontools` | JSON handling | Pretty printing |

### Completion Enhancements
| Plugin | Description | Key Features |
|--------|-------------|--------------|
| `zsh-completions` | Additional completions | Extended commands |
| `zsh-history-substring-search` | History search | Partial matching |

### UI Improvements
| Plugin | Description | Key Features |
|--------|-------------|--------------|
| `colored-man-pages` | Man page colors | Section highlighting |
| `colorize` | File highlighting | Syntax detection |

### MacOS Specific
| Plugin | Description | Key Features |
|--------|-------------|--------------|
| `macos` | MacOS integration | System commands |
| `brew` | Homebrew integration | Package management |
| `iterm2` | iTerm2 integration | Shell integration |

## 🔧 Plugin Configuration

### zsh-autosuggestions
```bash
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#999999"
```

### fzf
```bash
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
```

### thefuck
```bash
eval $(thefuck --alias)
export THEFUCK_REQUIRE_CONFIRMATION=false
export THEFUCK_PRIORITY="git_hook_bypass=1000"
```

## 📚 Plugin Usage Examples

### Git Workflow
```bash
# Git plugin
gst     # git status
gco     # git checkout
gp      # git push

# Git flow
gfl feature start   # Start feature
gfl feature finish  # Finish feature
```

### Docker Management
```bash
# Docker plugin
dps     # docker ps
dex     # docker exec
dl      # docker logs

# Docker compose
dcup    # docker-compose up
dcdown  # docker-compose down
```

### Python Development
```bash
# Python plugin
py      # python
pip     # pip with completion

# Virtualenv
venv    # Create venv
va      # Activate venv
vd      # Deactivate venv
```

### Directory Navigation
```bash
# FZF
ctrl-t  # File search
alt-c   # Directory search

# Z/Autojump
z work  # Jump to work directory
j docs  # Jump to docs directory
```

## 🔄 Plugin Updates

### Manual Updates
```bash
# Update Oh My Zsh
omz update

# Update custom plugins
cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull
cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
```

### Automatic Updates
Oh My Zsh will periodically check for updates and prompt for installation.

## 🎛️ Performance Optimization

### Lazy Loading
Some plugins are lazy-loaded to improve startup time:
- NVM
- PyEnv
- AWS CLI completion

### Async Loading
Autosuggestions and syntax highlighting use async processing to prevent blocking.

## 📚 Additional Resources

### Documentation
- [Oh My Zsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Plugin-specific docs](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)

### Customization
See `KEYBINDINGS.md` for key binding customization and `.zshrc` for plugin configuration.