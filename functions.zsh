take() {
    mkdir -p "$@" && cd "$@"
}

kimi() {
ANTHROPIC_BASE_URL="$MOONSHOT_BASE_URL"
ANTHROPIC_AUTH_TOKEN="$MOONSHOT_API_KEY"

claude $1
}

function sss() {
  surge . "https://$1.surge.sh"
}

rl() {
  ruby -ne "puts \$_.$1"
}

jina() {
    if [ -z "$1" ]; then
        echo "Usage: l2t <URL_TO_EXTRACT>"
        return 1
    fi

    local url="https://r.jina.ai/$1"
    curl -s "$url"
}

q () {
  jina "$1" | llm -i li -p json | tabularize
}

qq () {
  xclip -o -selection clipboard | llm -i li -p json | tabularize
}

function expose() {
  if [[ -z "$1" ]]; then
    echo "Error: No port specified."
    return 1  # Exit the function with an error status
  fi
  local port=$1
  ssh -R 80:localhost:${port} nokey@localhost.run 2>&1 | awk '/https:\/\/[a-zA-Z0-9]+\.lhr\.life/ {print $NF; fflush(); exit}'
}

jq-analyze() {
  local threshold=${1:-50}
  jq "walk(if type == \"string\" and length > $threshold then \"[content truncated]\" else . end)"
}

# git worktree add with relative paths (portable when renaming container)
gwa() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwa <path> [branch]"
    echo "       gwa ../feature-branch feature-branch"
    return 1
  fi

  local wt_path="$1"
  local branch="${2:-$(basename "$wt_path")}"

  # Create the worktree
  git worktree add "$wt_path" -b "$branch" || return $?

  # Get the actual gitdir path (includes worktrees/<branch>)
  local wt_gitdir=$(cd "$wt_path" && git rev-parse --git-dir)
  local wt_abs=$(cd "$wt_path" && pwd)

  # Calculate relative path from worktree to its gitdir
  local rel_path=$(realpath --relative-to="$wt_abs" "$wt_gitdir" 2>/dev/null || \
                   python3 -c "import os.path; print(os.path.relpath('$wt_gitdir', '$wt_abs'))")

  echo "gitdir: $rel_path" > "$wt_abs/.git"
  echo "Created worktree with relative path: $wt_path"
}

alacritty-theme() {
  local theme="${1:-}"
  local config_dir="$HOME/.config/alacritty"
  local state_dir="$HOME/.local/state/alacritty"
  local dest="$state_dir/theme.toml"

  case "$theme" in
    dark|night)
      theme="dark"
      ;;
    light|day)
      theme="light"
      ;;
    reset|default)
      rm -f "$dest"
      touch "$config_dir/alacritty.toml" 2>/dev/null || true
      echo "Alacritty theme reset to default dark"
      return 0
      ;;
    ""|-h|--help)
      echo "Usage: alacritty-theme <dark|light|reset>"
      echo "Aliases: alacritty-dark, alacritty-light"
      return 0
      ;;
    *)
      echo "Unknown Alacritty theme: $theme"
      echo "Available: dark, light, reset"
      return 1
      ;;
  esac

  local source="$config_dir/themes/$theme.toml"
  if [[ ! -f "$source" ]]; then
    echo "Theme file not found: $source"
    echo "Expected ~/.config/alacritty to point at the dotfiles alacritty directory."
    return 1
  fi

  mkdir -p "$state_dir" || return 1
  cp "$source" "$dest" || return 1

  # Nudge Alacritty's live config reload. No restart required.
  touch "$config_dir/alacritty.toml" 2>/dev/null || true
  echo "Alacritty theme: $theme"
}
