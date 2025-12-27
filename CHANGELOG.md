# Changelog

All notable changes to this dotfiles repository.

## 2025-12-27 - Major Refresh

Complete overhaul of 10-year-old dotfiles.

### Added

- **Fish shell support**
  - Full config at `fish/config.fish`
  - Platform-specific configs in `fish/conf.d/`
  - Custom prompt with git status
  - Tab completion accepts autosuggestions

- **Unified alias system**
  - Single source of truth: `aliases.yml`
  - Generator script: `generate-aliases.rb`
  - Outputs for zsh, fish, and platform variants

- **Claude mode switcher**
  - `claude-modes.zsh` for zsh
  - `fish/functions/claude-modes.fish` for fish
  - Functions: `ccc`, `ccc-dangerous`, `c-zai`, `c-minimax`, `c-moonshot`

- **Bootstrap script**
  - Safe by default (shows help without args)
  - Commands: `start`, `dry-run`
  - Installs Homebrew, packages, symlinks
  - Installs mise and Ruby with precompiled binaries
  - Installs Nerd Font (Caskaydia Cove) on all platforms
  - Loads iTerm2 preferences on macOS

- **iTerm2 configuration**
  - Exported preferences in `iterm2/com.googlecode.iterm2.plist`
  - XML format (readable, git-friendly)
  - Auto-loaded by bootstrap on macOS

- **Stateless configuration**
  - No shell history (zsh, fish)
  - No REPL history (python, node, irb)
  - No nvim state (shada, swap, undo)
  - No less history
  - No zsh completion cache

### Changed

- **Replaced asdf with mise**
  - Faster runtime version management
  - Precompiled binaries enabled
  - Path: `~/.local/share/mise/shims`

- **Simplified prompts**
  - Removed starship dependency
  - Custom 10-line prompts for zsh and fish
  - Shows: path, git branch, dirty indicator

- **Neovim config**
  - Switched to original lightline.vim (was fork)
  - Disabled all persistent state

### Removed

- **Personal identifiers**
  - Removed hardcoded usernames and URLs
  - Removed `snippets/` folder
  - Removed `kodemachine/` folder

- **Unused configurations**
  - i3 window manager config
  - conda config
  - ruff config
  - starship prompt

- **Plugin managers**
  - TPM (tmux plugin manager)
  - Using native tmux copy-mode instead

- **Orphaned files**
  - `nvim/rplugin/ruby/` (unused remote plugins)
  - `iterm2/` (unused color schemes)
  - `paths.zsh` (redundant path config)

## Pre-2025

Legacy dotfiles accumulated over 10 years. No detailed changelog maintained.
