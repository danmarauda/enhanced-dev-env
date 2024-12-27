# Zsh Key Bindings and Functions Guide

A comprehensive guide to all keyboard shortcuts and custom functions in our enhanced Zsh configuration.

## 🎯 Quick Reference Card

### Essential Commands
| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + R` | History Search | Fuzzy search command history |
| `Ctrl + T` | File Search | Fuzzy search files |
| `Alt + C` | Directory Jump | Fuzzy search directories |
| `F2` | Quick Backup | Backup current directory |
| `F4` | System Cleanup | Clean Docker, UV, and caches |
| `F5` | Project Search | Search and navigate projects |
| `F6` | Docker Status | Show container status |
| `F7` | Git Status | Show repository status |
| `F8` | System Stats | Show system information |

## 🎹 Detailed Key Bindings

### Navigation

#### Cursor Movement
| Shortcut | Action | Context |
|----------|--------|----------|
| `Ctrl + A` | Beginning of line | Move cursor to start |
| `Ctrl + E` | End of line | Move cursor to end |
| `Ctrl + F` | Forward char | Move one character right |
| `Ctrl + B` | Backward char | Move one character left |
| `Alt + F` | Forward word | Move one word right |
| `Alt + B` | Backward word | Move one word left |

#### History Navigation
| Shortcut | Action | Context |
|----------|--------|----------|
| `Ctrl + P` | Previous command | Navigate history up |
| `Ctrl + N` | Next command | Navigate history down |
| `Up Arrow` | History search up | Search with current prefix |
| `Down Arrow` | History search down | Search with current prefix |
| `Ctrl + R` | Fuzzy history | Interactive history search |

### Text Manipulation

#### Line Editing
| Shortcut | Action | Context |
|----------|--------|----------|
| `Ctrl + K` | Kill line | Delete from cursor to end |
| `Ctrl + U` | Backward kill line | Delete from cursor to start |
| `Ctrl + W` | Kill word backward | Delete previous word |
| `Alt + D` | Kill word forward | Delete next word |
| `Ctrl + Y` | Yank | Paste killed text |
| `Alt + Y` | Yank pop | Cycle through kill ring |

#### Text Operations
| Shortcut | Action | Context |
|----------|--------|----------|
| `Ctrl + L` | Clear screen | Clear terminal |
| `Ctrl + X Ctrl + E` | Edit command | Open in $EDITOR |
| `Alt + .` | Last argument | Insert last command's argument |
| `Ctrl + _` | Undo | Undo last edit |
| `Alt + /` | Redo | Redo last edit |

### Directory Navigation

#### Directory History
| Shortcut | Action | Context |
|----------|--------|----------|
| `Alt + Left` | Previous directory | Go back in directory history |
| `Alt + Right` | Next directory | Go forward in directory history |
| `Alt + Up` | Parent directory | Go up one level |
| `Alt + Down` | Child directory | Go into selected directory |

### Function Keys

#### Quick Actions
| Key | Action | Description |
|-----|--------|-------------|
| `F2` | Quick Backup | Create timestamped backup |
| `F4` | System Cleanup | Clean system resources |
| `F5` | Project Search | Navigate projects with FZF |
| `F6` | Docker Status | Show container information |
| `F7` | Git Status | Show repository status |
| `F8` | System Stats | Show system resources |

### Completion

#### Tab Completion
| Shortcut | Action | Context |
|----------|--------|----------|
| `Tab` | Complete word | Standard completion |
| `Shift + Tab` | Reverse complete | Cycle backwards |
| `Ctrl + X ?` | Debug completion | Show completion info |
| `Ctrl + X A` | Expand alias | Show alias expansion |

### FZF Integration

#### Fuzzy Finding
| Shortcut | Action | Context |
|----------|--------|----------|
| `Ctrl + T` | File search | Find and insert file path |
| `Alt + C` | Directory search | Find and cd to directory |
| `Ctrl + R` | History search | Find and execute command |

## 🔧 Custom Functions

### System Management

#### free-up-space
Clean up system resources
```bash
# Bound to F4
- Cleans Docker resources
- Cleans UV cache
- Removes pip cache
```

#### quick-backup
Create timestamped backup
```bash
# Bound to F2
- Creates .tar.gz of current directory
- Includes hidden files
- Timestamped filename
```

#### system-stats
Show system information
```bash
# Bound to F8
- Memory usage
- Disk usage
- CPU status
```

### Development Tools

#### proj-search
Project navigation
```bash
# Bound to F5
- Fuzzy search projects directory
- Tree preview
- Quick navigation
```

#### docker-stats
Container management
```bash
# Bound to F6
- List running containers
- Show status and ports
- Formatted output
```

#### git-status
Repository information
```bash
# Bound to F7
- Show modified files
- Recent commits
- Branch status
```

## 🎨 Vim Mode Support

### Mode Switching
| Shortcut | Action | Context |
|----------|--------|----------|
| `ESC` | Command mode | Enter command mode |
| `i` | Insert mode | Enter insert mode |

### Command Mode Keys
| Key | Action | Context |
|-----|--------|----------|
| `k` | History up | Previous command |
| `j` | History down | Next command |
| `/` | Search backward | Search history |
| `?` | Search forward | Search history |

## 🔄 Mode Indicators

### Cursor Shapes
| Mode | Shape | Description |
|------|-------|-------------|
| Command | Block | █ |
| Insert | Line | ┃ |

## 🎛️ Environment Variables

### Configuration
```bash
HISTSIZE=1000000           # History size in memory
SAVEHIST=1000000          # History size on disk
HISTFILE=~/.zsh_history   # History file location
```

## 📚 Tips and Tricks

### Efficiency Tips
1. Use `Ctrl + R` for history search
2. Use `Alt + .` to reuse arguments
3. Use `F4` for regular cleanup
4. Use `F5` for project navigation
5. Use function keys for quick actions

### Common Patterns
```bash
# Quick directory backup
F2

# System cleanup
F4

# Project navigation
F5

# Monitor containers
F6

# Check git status
F7

# Monitor system
F8
```

## 🔄 Updates and Customization

### Adding New Bindings
```bash
# Add to .zshrc
bindkey 'key-sequence' function-name
```

### Creating Custom Functions
```bash
function-name() {
    # Function code
    zle reset-prompt  # Refresh prompt
}
zle -N function-name  # Register function
bindkey 'key-sequence' function-name  # Bind key
```