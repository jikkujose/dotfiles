#!/usr/bin/zsh

source $HOME/antigen/antigen.zsh
source `brew --prefix`/etc/profile.d/z.sh

export LC_ALL="en_US.UTF-8"
export EDITOR='nvim'
export HOMEBREW_CASK_OPTS="--caskroom=/opt/homebrew-cask/Caskroom"

antigen use oh-my-zsh

antigen bundles <<BUNDLES
  git
  uvaes/fzf-marks
  heroku
  pip
  lein
  command-not-found
  zsh-users/zsh-syntax-highlighting
BUNDLES

antigen theme JikkuJose/themes jiks

antigen apply

setopt interactivecomments

source ~/.paths.zsh
source ~/.variables.zsh
source ~/.aliases.zsh
source ~/.functions.zsh

if [ -f ~/.private.zsh ]
then
  source ~/.private.zsh
fi

set -o vi
bindkey -v

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby 2.3.3

clear
