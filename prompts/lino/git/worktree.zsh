# Pro Workflow: bare repo + git worktree
#
# Format (container dir — holds .bare/ and worktree subdirs):
#   (name/worktree: root)
#
# Format (inside a checked-out worktree):
#   (name/worktree: branch) or (name/worktree: branch + * | ↓ ↑2)
#
# "worktree" is a literal mode label; "root" marks the container level.

# Called when CWD is the container dir (has .bare/HEAD, not a work tree).
_lino_worktree_root() {
  local name=$(basename "$PWD")
  echo "%F{white}(%f%F{cyan}${name}%F{white}/%f%F{yellow}worktree%F{white}: %froot%F{white})%f"
}

# Called when inside a linked worktree. Receives git-common-dir as $1.
_lino_worktree_branch() {
  local git_common_dir="$1"

  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ -z "$branch" ]] && branch="$(git rev-parse --short HEAD 2>/dev/null)…"
  [[ -z "$branch" ]] && return

  # Resolve container name from common dir (parent of .bare/)
  local common_abs
  if [[ "$git_common_dir" = /* ]]; then
    common_abs=$(cd "$git_common_dir" 2>/dev/null && pwd -P)
  else
    common_abs=$(cd "${PWD}/${git_common_dir}" 2>/dev/null && pwd -P)
  fi
  local repo=$(basename "$(dirname "$common_abs")")
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

  local behind_indicator=""
  local behind=$(git rev-list HEAD..@{u} 2>/dev/null | wc -l | tr -d ' ')
  if [[ $behind -gt 1 ]]; then
    behind_indicator="%F{magenta}↓%f%F{blue}${behind}%f"
  elif [[ $behind -eq 1 ]]; then
    behind_indicator="%F{magenta}↓%f"
  fi

  local ahead_indicator=""
  local ahead=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
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

  # name/worktree: branch [status]
  local result="%F{white}(%f%F{cyan}${repo}%F{white}/%f%F{yellow}worktree%F{white}: %f%F{yellow}${branch}%f"
  if [[ -n "$local_status" && -n "$remote_status" ]]; then
    result+=" ${local_status} %F{white}|%f ${remote_status}"
  elif [[ -n "$local_status" ]]; then
    result+=" ${local_status}"
  elif [[ -n "$remote_status" ]]; then
    result+=" ${remote_status}"
  fi
  result+="%F{white})%f"
  echo "$result"
}
