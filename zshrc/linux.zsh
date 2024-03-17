. "$HOME/.asdf/asdf.sh"

fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

export HOST_IP="$(ip route |awk '/^default/{print $3}')"
