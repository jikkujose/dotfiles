# _lino_standard — prompt segment for ordinary git repos
# Output: (repo/branch) or (repo/branch: + * | ↓ ↑2)

_lino_standard() {
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ -z "$branch" ]] && branch="$(git rev-parse --short HEAD 2>/dev/null)…"
  [[ -z "$branch" ]] && return

  local repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
  [[ -z "$repo" ]] && return

  local status_output=$(git status --porcelain 2>/dev/null)

  local staged=""
  if [[ -n "$status_output" ]] && echo "$status_output" | grep -qE '^[MADRC]'; then
    staged="%F{cyan}+%f"
  fi

  local dirty=""
  if [[ -n "$status_output" ]] && echo "$status_output" | grep -qE '^.[MD]|\?\?'; then
    dirty="%F{red}*%f"
  fi

  # Resolve upstream: prefer @{u}, fall back to origin/<branch>
  local upstream
  upstream=$(git rev-parse --verify --quiet @{u} 2>/dev/null) \
    || upstream=$(git rev-parse --verify --quiet "origin/${branch}" 2>/dev/null)

  local behind_indicator=""
  local behind=$(git rev-list HEAD..$upstream 2>/dev/null | wc -l | tr -d ' ')
  if [[ $behind -gt 1 ]]; then
    behind_indicator="%F{magenta}↓%f%F{blue}${behind}%f"
  elif [[ $behind -eq 1 ]]; then
    behind_indicator="%F{magenta}↓%f"
  fi

  local ahead_indicator=""
  local ahead=$(git rev-list $upstream..HEAD 2>/dev/null | wc -l | tr -d ' ')
  if [[ $ahead -gt 1 ]]; then
    ahead_indicator="%F{green}↑%f%F{blue}${ahead}%f"
  elif [[ $ahead -eq 1 ]]; then
    ahead_indicator="%F{green}↑%f"
  fi

  local local_status=""
  [[ -n "$staged" ]] && local_status+="$staged"
  [[ -n "$staged" && -n "$dirty" ]] && local_status+=" "
  [[ -n "$dirty" ]] && local_status+="$dirty"

  local remote_status=""
  [[ -n "$behind_indicator" ]] && remote_status+="$behind_indicator"
  [[ -n "$behind_indicator" && -n "$ahead_indicator" ]] && remote_status+=" "
  [[ -n "$ahead_indicator" ]] && remote_status+="$ahead_indicator"

  local result="%F{white}(%f%F{cyan}${repo}%F{white}/%f%F{yellow}${branch}%f"
  if [[ -n "$local_status" || -n "$remote_status" ]]; then
    result+="%F{white}:%f"
    if [[ -n "$local_status" && -n "$remote_status" ]]; then
      result+=" ${local_status} %F{white}|%f ${remote_status}"
    elif [[ -n "$local_status" ]]; then
      result+=" ${local_status}"
    else
      result+=" ${remote_status}"
    fi
  fi
  result+="%F{white})%f"
  echo "$result"
}
