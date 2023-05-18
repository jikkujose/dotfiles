#!/usr/bin/zsh

source `brew --prefix`/etc/profile.d/z.sh

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

# pnpm
export PNPM_HOME="/home/polar/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/whiterabbit/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/whiterabbit/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/whiterabbit/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/whiterabbit/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# bun completions
[ -s "/home/whiterabbit/.bun/_bun" ] && source "/home/whiterabbit/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
