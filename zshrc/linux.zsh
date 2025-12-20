. "$HOME/.asdf/asdf.sh"

fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit -i 2>/dev/null || true

export HOST_IP="$(ip route |awk '/^default/{print $3}')"

export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

# Cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

alias unlock='sudo cryptsetup open /dev/vdb crypt_projects && sudo mount /dev/mapper/crypt_projects ~/Projects && echo \"🔓 Vault Unlocked\"'
