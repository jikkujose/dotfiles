export HOST_IP="$(ip route |awk '/^default/{print $3}')"

export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

# Cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
