. "$HOME/.asdf/asdf.sh"

fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

export HOST_IP="$(ip route |awk '/^default/{print $3}')"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/media/whiterabbit/68927B1F927AF0C4/Symlinks/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/media/whiterabbit/68927B1F927AF0C4/Symlinks/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/media/whiterabbit/68927B1F927AF0C4/Symlinks/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/media/whiterabbit/68927B1F927AF0C4/Symlinks/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

