#!/usr/bin/zsh

source $HOME/antigen/antigen.zsh
source `brew --prefix`/etc/profile.d/z.sh

export LC_ALL="en_US.UTF-8"
export EDITOR='nvim'

antigen use oh-my-zsh

antigen bundles <<BUNDLES
  git
  heroku
  pip
  lein
  command-not-found
  zsh-users/zsh-syntax-highlighting
  tarruda/zsh-autosuggestions
BUNDLES

antigen theme JikkuJose/themes jiks

antigen apply

setopt interactivecomments

source ~/.paths.zsh
source ~/.variables.zsh
source ~/.functions.zsh
source ~/.aliases.zsh

if [ -f ~/.private.zsh ]
then
  source ~/.private.zsh
fi

set -o vi
bindkey -v

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby 2.2.2

clear
