# Linux-specific fish configuration

# asdf version manager
if test -f $HOME/.asdf/asdf.fish
    source $HOME/.asdf/asdf.fish
end

# CUDA paths
if test -d /usr/local/cuda
    set -gx PATH /usr/local/cuda/bin $PATH
    set -gx LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH
end

# Host IP (for containers/WSL)
set -gx HOST_IP (ip route | awk '/^default/{print $3}')

# VS Code shell integration
if test "$TERM_PROGRAM" = "vscode"
    and type -q code
    source (code --locate-shell-integration-path fish)
end
