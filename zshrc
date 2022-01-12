#!/usr/bin/zsh

# Start tmux by default
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# source $HOME/antigen/antigen.zsh
source `brew --prefix`/etc/profile.d/z.sh

export LC_ALL="en_US.UTF-8"
export EDITOR='nvim'
# export HOMEBREW_CASK_OPTS="--caskroom=/opt/homebrew-cask/Caskroom"

# antigen use oh-my-zsh

# antigen bundles <<BUNDLES
#   git
#   uvaes/fzf-marks
#   heroku
#   pip
#   lein
#   command-not-found
#   zsh-users/zsh-syntax-highlighting
# BUNDLES
#
# antigen theme JikkuJose/themes jiks
#
# antigen apply

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

set -o vi
bindkey -v

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
chruby 3.1.0

clear
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

eval "$(starship init zsh)"

export NODE_PATH=$(npm -g root)
