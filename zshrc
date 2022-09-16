#!/usr/bin/zsh

# Start tmux by default
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# source $HOME/antigen/antigen.zsh
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
chruby 3.1.2

clear
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

eval "$(starship init zsh)"

export NODE_PATH=$(npm -g root)

export HOST_IP="$(ip route |awk '/^default/{print $3}')"
export PULSE_SERVER="tcp:$HOST_IP"

switch_profile null

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/polar/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/polar/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/polar/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/polar/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda deactivate

# bun completions
[ -s "/home/polar/.bun/_bun" ] && source "/home/polar/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
