#!/usr/bin/zsh

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export EDITOR='nvim'

setopt interactivecomments

source ~/dotfiles/variables.zsh
source ~/dotfiles/generated/aliases.zsh
source ~/dotfiles/functions.zsh

if [ -f ~/.private.zsh ]
then
  source ~/.private.zsh
fi

if [ -f ~/dotfiles/claude-modes.zsh ]
then
  source ~/dotfiles/claude-modes.zsh
fi

set -o vi
bindkey -v

clear

# export NODE_PATH=$(npm -g root)

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/share/mise/shims:$PATH"
export PATH="/opt/nvim-linux64/bin/:$PATH"

# Simple prompt: ~/path (branch: * | ↑2)
setopt PROMPT_SUBST

git_prompt_info() {
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ -z "$branch" ]] && return

  local dirty=""
  [[ -n $(git status --porcelain 2>/dev/null) ]] && dirty="%F{red}*%f"

  local unpushed=""
  local ahead=$(git rev-list @{u}.. 2>/dev/null | wc -l | tr -d ' ')
  if [[ $ahead -gt 1 ]]; then
    unpushed="%F{green}↑%f%F{blue}${ahead}%f"
  elif [[ $ahead -eq 1 ]]; then
    unpushed="%F{green}↑%f"
  fi

  local result="%F{white}(%f%F{yellow}${branch}%f"
  if [[ -n "$dirty" || -n "$unpushed" ]]; then
    result+="%F{white}:%f"
    if [[ -n "$dirty" && -n "$unpushed" ]]; then
      result+=" ${dirty} %F{white}|%f ${unpushed}"
    elif [[ -n "$dirty" ]]; then
      result+=" ${dirty}"
    else
      result+=" ${unpushed}"
    fi
  fi
  result+="%F{white})%f"
  echo "$result"
}

PROMPT='%F{blue}%~%f $(git_prompt_info)
%F{green}❯%f '


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source ~/dotfiles/zshrc/linux.zsh
  source ~/dotfiles/generated/aliases-linux.zsh
  source ~/dotfiles/functions/linux.zsh

  if [[ -e ~/.wsl ]]; then
    source ~/dotfiles/generated/aliases-wsl.zsh
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source ~/dotfiles/generated/aliases-mac.zsh
  source ~/dotfiles/zshrc/mac.zsh
  source ~/dotfiles/functions/mac.zsh
fi

# vince
export VINCE_INSTALL="$HOME/.vince"
export PATH="$VINCE_INSTALL/bin:$PATH"

# Completion without dump file
autoload -U compinit; compinit -d /dev/null
