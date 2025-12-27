#!/usr/bin/zsh

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export EDITOR='nvim'

setopt interactivecomments
setopt HIST_IGNORE_SPACE

source ~/dotfiles/paths.zsh
source ~/dotfiles/variables.zsh
source ~/dotfiles/aliases.zsh
source ~/dotfiles/functions.zsh

if [ -f ~/.private.zsh ]
then
  source ~/.private.zsh
fi

if [ -f ~/claude-modes.zsh ]
then
  source ~/claude-modes.zsh
fi

set -o vi
bindkey -v

clear

# export NODE_PATH=$(npm -g root)

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.asdf/shims:$PATH"
export PATH="/opt/nvim-linux64/bin/:$PATH"

# Simple prompt: ~/path (branch*) ❯
# * = dirty, nothing = clean
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{yellow}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}%b%f %F{red}%a%f'
setopt PROMPT_SUBST

# Check for uncommitted changes
git_dirty() {
  [[ -n $(git status --porcelain 2>/dev/null) ]] && echo '%F{red}*%f'
}

PROMPT='%F{blue}%~%f${vcs_info_msg_0_}$(git_dirty) %F{green}❯%f '


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source ~/dotfiles/zshrc/linux.zsh
  source ~/dotfiles/aliases/linux.zsh
  source ~/dotfiles/functions/linux.zsh

  if [[ -e ~/.wsl ]]; then
    source ~/dotfiles/aliases/wsl.zsh
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source ~/dotfiles/aliases/mac.zsh
  source ~/dotfiles/zshrc/mac.zsh
  source ~/dotfiles/functions/mac.zsh
fi

# vince
export VINCE_INSTALL="$HOME/.vince"
export PATH="$VINCE_INSTALL/bin:$PATH"

autoload -U compinit; compinit


. "$HOME/.local/bin/env"
