# Lino - minimal git-aware fish prompt
# Format: ~/path (branch: + * | ↓ ↑2)
#         ❯
#
# Colors:
#   path: blue, branch: yellow, punctuation: white
#   staged(+): cyan, dirty(*): red
#   behind(↓): magenta, ahead(↑): green, count: blue

function fish_prompt
    set -l cwd (prompt_pwd)
    set -l git_info (lino_git_info)

    echo (set_color blue)$cwd(set_color normal) $git_info
    echo -n (set_color green)"➜"(set_color normal)" "
end

function lino_git_info
    set -l branch (git symbolic-ref --short HEAD 2>/dev/null)
    test -z "$branch"; and return

    set -l status_output (git status --porcelain 2>/dev/null)

    # Staged changes
    set -l staged ""
    if test -n "$status_output"
        if echo "$status_output" | grep -qE '^[MADRC]'
            set staged (set_color cyan)"+"(set_color normal)
        end
    end

    # Unstaged/dirty changes
    set -l dirty ""
    if test -n "$status_output"
        if echo "$status_output" | grep -qE '^.[MD]|\?\?'
            set dirty (set_color red)"*"(set_color normal)
        end
    end

    # Commits behind (need to pull)
    set -l behind_indicator ""
    set -l behind (git rev-list HEAD..@{u} 2>/dev/null | wc -l | tr -d ' ')
    if test "$behind" -gt 1
        set behind_indicator (set_color magenta)"↓"(set_color blue)$behind(set_color normal)
    else if test "$behind" -eq 1
        set behind_indicator (set_color magenta)"↓"(set_color normal)
    end

    # Commits ahead (need to push)
    set -l ahead_indicator ""
    set -l ahead (git rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
    if test "$ahead" -gt 1
        set ahead_indicator (set_color green)"↑"(set_color blue)$ahead(set_color normal)
    else if test "$ahead" -eq 1
        set ahead_indicator (set_color green)"↑"(set_color normal)
    end

    # Build local status (staged + dirty)
    set -l local_status ""
    if test -n "$staged" -a -n "$dirty"
        set local_status "$staged $dirty"
    else if test -n "$staged"
        set local_status "$staged"
    else if test -n "$dirty"
        set local_status "$dirty"
    end

    # Build remote status (behind + ahead)
    set -l remote_status ""
    if test -n "$behind_indicator" -a -n "$ahead_indicator"
        set remote_status "$behind_indicator $ahead_indicator"
    else if test -n "$behind_indicator"
        set remote_status "$behind_indicator"
    else if test -n "$ahead_indicator"
        set remote_status "$ahead_indicator"
    end

    # Combine
    set -l result (set_color white)"("(set_color yellow)$branch(set_color normal)
    if test -n "$local_status" -o -n "$remote_status"
        set result $result(set_color white)":"(set_color normal)
        if test -n "$local_status" -a -n "$remote_status"
            set result "$result $local_status "(set_color white)"|"(set_color normal)" $remote_status"
        else if test -n "$local_status"
            set result "$result $local_status"
        else
            set result "$result $remote_status"
        end
    end
    set result $result(set_color white)")"(set_color normal)

    echo $result
end
