# asdf environment variables (needed for all shells)
  export ASDF_DIR=$HOME/.asdf
  export ASDF_DATA_DIR=$HOME/.asdf

  # Add asdf to PATH for all shells (interactive and non-interactive)
  export PATH=$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH

  # Source asdf for non-interactive shells only
  # Interactive shells will handle asdf via zshrc.zsh
  if [[ ! -o interactive ]]; then
    [ -f "$ASDF_DIR/asdf.sh" ] && source "$ASDF_DIR/asdf.sh"
  fi