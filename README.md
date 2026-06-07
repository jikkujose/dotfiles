# dotfiles

Personal development environment configuration.

## Philosophy

### Privacy & Security

- **No personal identifiers.** No usernames, emails, or repo URLs.
- **No secrets in repo.** API keys live in `~/.private.zsh` (not tracked).
- **Stateless operation.** All tools configured to leave zero trace:
  - No shell history (zsh)
  - No REPL history (python, node, irb)
  - No editor state (nvim swap, undo, shada)
  - No completion caches

### Multi-Platform

- Works on macOS and Linux (including WSL).
- Platform-specific aliases and functions loaded at runtime.
- Platform detection at runtime for OS-specific paths and tools.

### Simplicity

- Minimal dependencies. No plugin managers for tmux or zsh.
- Custom prompt instead of frameworks (no oh-my-zsh, starship).
- Prefer built-in features over plugins.

## Quick Start

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
./bootstrap.sh start
```

## Bootstrap

The bootstrap script sets up a fresh machine.

### Usage

```bash
./bootstrap.sh           # Show help
./bootstrap.sh start     # Run setup
./bootstrap.sh dry-run   # Preview changes
```

### What It Does

1. **Installs Homebrew** (macOS or Linuxbrew)
2. **Installs packages** (git, zsh, tmux, neovim, mise, etc.)
3. **Creates symlinks:**
   - `~/.zshrc` → `zshrc.zsh`
   - `~/.tmux.conf` → `tmux.conf`
   - `~/.config/nvim` → `nvim/`
   - `~/.config/alacritty/` → `alacritty/`
   - `~/.tool-versions` → `tool-versions`
4. **Installs mise** (runtime version manager)
5. **Installs Ruby** via mise (precompiled binaries)
6. **Installs Nerd Font** (Caskaydia Cove)
7. **Loads iTerm2 preferences** (macOS only)

### Requirements

- macOS or Debian-based Linux
- Internet connection
- sudo access (for Homebrew)

## Structure

```
dotfiles/
├── bootstrap.sh          # Setup script
│
├── zshrc.zsh             # Main zsh config
├── variables.zsh         # Environment variables
├── functions.zsh         # Shell functions
├── zshrc/                # Platform-specific zsh
│   ├── linux.zsh
│   └── mac.zsh
│
├── aliases.zsh           # Shared aliases
├── aliases-linux.zsh     # Linux-specific aliases
├── aliases-mac.zsh       # macOS-specific aliases
├── aliases-wsl.zsh       # WSL-specific aliases
│
├── functions/            # Platform-specific functions
│   ├── linux.zsh
│   └── mac.zsh
│
├── prompts/              # Custom prompts
│   └── lino.zsh          # Lino prompt
│
├── nvim/                 # Neovim config
│   ├── init.lua          # Main config
│   ├── init/             # Platform-specific
│   ├── colors/           # Color schemes
│   └── autoload/         # vim-plug
│
├── tmux.conf             # Tmux config
├── tool-versions         # mise runtime versions
├── claude-modes.zsh      # Claude API mode switcher
├── prettierrc.json       # Prettier config
├── iterm2/               # iTerm2 preferences (macOS)
└── alacritty/            # Alacritty terminal config
```

## Key Files

### Alacritty themes

Alacritty imports the default dark theme plus a user-state theme file. Switch without restarting:

```bash
alacritty-theme light
alacritty-theme dark
# or: alacritty-light / alacritty-dark
```

The selected theme is written to `~/.local/state/alacritty/theme.toml` and live-reloaded by Alacritty.

### tool-versions

Runtime versions managed by mise:

```
nodejs 24.8.0
ruby 3.3.0
python 3.12.0
rust 1.90.0
golang 1.25.1
bun 1.2.22
swift 5.7.1
```

### claude-modes.zsh

Functions for switching Claude API providers:

- `ccc` - Default Claude
- `ccc-dangerous` - Skip permissions
- `c-zai` - ZAI provider
- `c-minimax` - Minimax provider
- `c-moonshot` - Moonshot provider

## Private Configuration

Create `~/.private.zsh` for secrets:

```bash
export ANTHROPIC_API_KEY="sk-..."
export ZAI_API_KEY="..."
export MOONSHOT_API_KEY="..."
```

This file is sourced but never committed.

## Stateless Configuration

All tools are configured to avoid writing state:

| Tool   | Disabled                          |
|--------|-----------------------------------|
| zsh    | HISTFILE, SAVEHIST, zcompdump     |
| nvim   | shada, swapfile, undofile         |
| tmux   | history-file                      |
| less   | LESSHISTFILE                      |
| python | PYTHON_HISTORY                    |
| node   | NODE_REPL_HISTORY                 |
| irb    | IRB_HISTFILE                      |

## Maintenance

### Update Runtime Versions

Edit `tool-versions`, then:

```bash
mise install
```

### Add New Packages

Install via Homebrew:

```bash
brew install <package>
```

## Kodemachine Integration

These dotfiles are designed to work with kodemachine for ephemeral Linux VMs on macOS.

### How It Works

```
┌─────────────────────────────────────────────────────────────┐
│ macOS Host                                                  │
│                                                             │
│   kodemachine create-base                                   │
│         │                                                   │
│         ├── Provisions Ubuntu VM                            │
│         ├── Clones these dotfiles                           │
│         ├── Runs bootstrap.sh                               │
│         └── Creates golden image                            │
│                                                             │
│   kodemachine start myproject                               │
│         │                                                   │
│         └── APFS clone → instant VM with your config        │
└─────────────────────────────────────────────────────────────┘
```

### Workflow

1. **Once per Mac**: `kodemachine setup-host`
2. **Every ~6 months**: `kodemachine create-base --dotfiles <repo-url>`
3. **Daily**: `kodemachine start myproject` (SSH with full dev environment)

### Design Decisions

- **bootstrap.sh stays portable**: No GUI dependencies - works on Mac, Linux, servers
- **GUI lives in create-base.rb**: XFCE, browsers, fonts installed during base image build
- **Stateless by default**: VMs are disposable; LUKS disk holds persistent data
