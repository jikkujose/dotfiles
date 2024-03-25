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
source ~/dotfiles/conda.zsh

if [ -f ~/.private.zsh ]
then
  source ~/.private.zsh
fi

set -o vi
bindkey -v

clear

export NODE_PATH=$(npm -g root)

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.asdf/shims:$PATH"
export PATH="$HOME/miniconda3/bin:$PATH"

eval "$(starship init zsh)"


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

conda deactivate
