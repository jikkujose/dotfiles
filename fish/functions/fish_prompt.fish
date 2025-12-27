# Simple prompt: ~/path branch* ❯
# * = dirty, nothing = clean
function fish_prompt
    set -l cwd (prompt_pwd)
    set -l git_branch (git branch --show-current 2>/dev/null)
    set -l git_dirty ""

    if test -n "$git_branch"
        if test -n (git status --porcelain 2>/dev/null)
            set git_dirty (set_color red)"*"(set_color normal)
        end
        set git_branch " "(set_color yellow)$git_branch(set_color normal)$git_dirty
    end

    echo -n (set_color blue)$cwd(set_color normal)$git_branch (set_color green)"❯"(set_color normal)" "
end
