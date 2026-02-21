# Lino — minimal git-aware zsh prompt
#
# Standard repos:    ~/path (repo/branch: + * | ↓ ↑2)
# Worktree container: ~/path (name/worktree: root)
# Worktree branch:    ~/path (name/worktree: branch + * | ↓ ↑2)
#
# Colors: path=blue, repo/name=cyan, branch/mode=yellow, punctuation=white
#         staged(+)=cyan, dirty(*)=red, behind(↓)=magenta, ahead(↑)=green

_lino_dir="${0:A:h}"
source "${_lino_dir}/git/standard.zsh"
source "${_lino_dir}/git/worktree.zsh"
unset _lino_dir

setopt PROMPT_SUBST

git_prompt_info() {
  # Container dir: holds .bare/ + worktree subdirs, not a work tree itself
  if [[ -f ".bare/HEAD" ]]; then
    _lino_worktree_root
    return
  fi

  git rev-parse --is-inside-work-tree &>/dev/null || return

  # Single subprocess: get both dirs to detect a true linked worktree.
  # Use --absolute-git-dir so both sides are absolute before comparing;
  # --git-common-dir can return a relative path for regular subdirectories
  # (e.g. a plain subdir of a normal repo), causing a false positive.
  local _dirs
  _dirs=$(git rev-parse --absolute-git-dir --git-common-dir 2>/dev/null) || return
  local git_dir=${_dirs%%$'\n'*}
  local git_common_dir_raw=${_dirs##*$'\n'}

  # Resolve git-common-dir to absolute if git returned it as relative
  local git_common_dir
  if [[ "$git_common_dir_raw" = /* ]]; then
    git_common_dir="$git_common_dir_raw"
  else
    git_common_dir=$(cd "$git_common_dir_raw" 2>/dev/null && pwd -P)
  fi

  if [[ "$git_dir" != "$git_common_dir" ]]; then
    _lino_worktree_branch "$git_common_dir"
  else
    _lino_standard
  fi
}

PROMPT='%F{blue}%~%f $(git_prompt_info)
%F{green}➜%f '
