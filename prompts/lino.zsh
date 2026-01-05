# Lino - minimal git-aware zsh prompt
# Format: ~/path (branch: + * | ↓ ↑2)
#         ❯
#
# Colors:
#   path: blue, branch: yellow, punctuation: white
#   staged(+): cyan, dirty(*): red
#   behind(↓): magenta, ahead(↑): green, count: blue

setopt PROMPT_SUBST

git_prompt_info() {
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ -z "$branch" ]] && return

  local status_output=$(git status --porcelain 2>/dev/null)

  # Staged changes (lines with non-space in first column, excluding untracked)
  local staged=""
  if [[ -n "$status_output" ]] && echo "$status_output" | grep -qE '^[MADRC]'; then
    staged="%F{cyan}+%f"
  fi

  # Unstaged/dirty changes (lines with non-space in second column or untracked)
  local dirty=""
  if [[ -n "$status_output" ]] && echo "$status_output" | grep -qE '^.[MD]|\?\?'; then
    dirty="%F{red}*%f"
  fi

  # Commits behind (need to pull)
  local behind_indicator=""
  local behind=$(git rev-list HEAD..@{u} 2>/dev/null | wc -l | tr -d ' ')
  if [[ $behind -gt 1 ]]; then
    behind_indicator="%F{magenta}↓%f%F{blue}${behind}%f"
  elif [[ $behind -eq 1 ]]; then
    behind_indicator="%F{magenta}↓%f"
  fi

  # Commits ahead (need to push)
  local ahead_indicator=""
  local ahead=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
  if [[ $ahead -gt 1 ]]; then
    ahead_indicator="%F{green}↑%f%F{blue}${ahead}%f"
  elif [[ $ahead -eq 1 ]]; then
    ahead_indicator="%F{green}↑%f"
  fi

  # Build local status (staged + dirty)
  local local_status=""
  [[ -n "$staged" ]] && local_status+="$staged"
  [[ -n "$staged" && -n "$dirty" ]] && local_status+=" "
  [[ -n "$dirty" ]] && local_status+="$dirty"

  # Build remote status (behind + ahead)
  local remote_status=""
  [[ -n "$behind_indicator" ]] && remote_status+="$behind_indicator"
  [[ -n "$behind_indicator" && -n "$ahead_indicator" ]] && remote_status+=" "
  [[ -n "$ahead_indicator" ]] && remote_status+="$ahead_indicator"

  # Combine
  local result="%F{white}(%f%F{yellow}${branch}%f"
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

PROMPT='%F{blue}%~%f $(git_prompt_info)
%F{green}➜%f '
