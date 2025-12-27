# dotfiles

Personal development environment configuration.

## Philosophy

### Privacy & Security

- **No personal identifiers.** No usernames, emails, or repo URLs.
- **No secrets in repo.** API keys live in `~/.private.zsh` (not tracked).
- **Stateless operation.** All tools configured to leave zero trace:
  - No shell history (zsh, fish)
  - No REPL history (python, node, irb)
  - No editor state (nvim swap, undo, shada)
  - No completion caches

### Multi-Platform

- Works on macOS and Linux (including WSL).
- Single alias source (`aliases.yml`) generates shell-specific files.
- Platform detection at runtime for OS-specific paths and tools.

### Simplicity

- Minimal dependencies. No plugin managers for tmux or zsh.
- Custom prompts instead of frameworks (no oh-my-zsh, starship).
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
2. **Installs packages** (git, zsh, fish, tmux, neovim, mise, etc.)
3. **Creates symlinks:**
   - `~/.zshrc` → `zshrc.zsh`
   - `~/.tmux.conf` → `tmux.conf`
   - `~/.config/nvim` → `nvim/`
   - `~/.config/fish` → `fish/`
   - `~/.tool-versions` → `tool-versions`
4. **Installs mise** (runtime version manager)
5. **Installs Ruby** via mise (precompiled binaries)
6. **Generates aliases** for zsh and fish
7. **Installs Nerd Font** (Caskaydia Cove)
8. **Loads iTerm2 preferences** (macOS only)

### Requirements

- macOS or Debian-based Linux
- Internet connection
- sudo access (for Homebrew)

## Structure

```
dotfiles/
├── bootstrap.sh          # Setup script
├── aliases.yml           # Alias definitions (single source)
├── generate-aliases.rb   # Generates shell-specific aliases
├── generated/            # Auto-generated alias files
│
├── zshrc.zsh             # Main zsh config
├── variables.zsh         # Environment variables
├── functions.zsh         # Shell functions
├── zshrc/                # Platform-specific zsh
│   ├── linux.zsh
│   └── mac.zsh
│
├── fish/                 # Fish shell config
│   ├── config.fish
│   ├── conf.d/           # Platform-specific
│   └── functions/        # Fish functions
│
├── nvim/                 # Neovim config
│   ├── init.lua          # Main config
│   ├── colors/           # Color schemes
│   └── lua/plugins/      # Custom plugins
│
├── tmux.conf             # Tmux config
├── tool-versions         # mise runtime versions
├── claude-modes.zsh      # Claude API mode switcher
└── iterm2/               # iTerm2 preferences (macOS)
```

## Key Files

### aliases.yml

Single source of truth for all shell aliases.

```yaml
shared:
  g: git
  v: nvim

linux:
  pbcopy: "xclip -selection clipboard"

mac:
  flushdns: "sudo dscacheutil -flushcache"
```

Run `ruby generate-aliases.rb` after changes.

### tool-versions

Runtime versions managed by mise:

```
nodejs 24.8.0
ruby 3.3.0
python 3.12.0
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
| fish   | fish_history                      |
| nvim   | shada, swapfile, undofile         |
| tmux   | history-file                      |
| less   | LESSHISTFILE                      |
| python | PYTHON_HISTORY                    |
| node   | NODE_REPL_HISTORY                 |
| irb    | IRB_HISTFILE                      |

## Shell Support

Both zsh and fish are supported with feature parity:

- Same aliases (generated from aliases.yml)
- Same prompt style (path + git branch + dirty indicator)
- Same Claude mode functions
- Vi keybindings

Switch temporarily: just type `fish` or `zsh`.

## Maintenance

### Regenerate Aliases

```bash
ruby generate-aliases.rb
```

### Update Runtime Versions

Edit `tool-versions`, then:

```bash
mise install
```

### Add New Packages

Edit `Brewfile`, then:

```bash
brew bundle
```
