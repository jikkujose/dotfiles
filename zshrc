#!/usr/bin/zsh

source `brew --prefix`/etc/profile.d/z.sh

export LC_ALL="en_US.UTF-8"
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

export HOST_IP="$(ip route |awk '/^default/{print $3}')"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source ~/dotfiles/aliases-linux.zsh
  source ~/dotfiles/functions-linux.zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source ~/dotfiles/aliases-mac.zsh
  source ~/dotfiles/functions-mac.zsh
else
fi


