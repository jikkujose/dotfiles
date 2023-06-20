autoload -Uz vcs_info
setopt PROMPT_SUBST
precmd() {
    vcs_info
    if [ -d .git ] || git rev-parse --is-inside-work-tree 2>/dev/null | grep -q 'true'; then
        if git diff --quiet && git diff --staged --quiet && git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' > /dev/null 2>&1; then
            # No changes
            zstyle ':vcs_info:git:*' formats '%F{white}(%F{cyan}%b%F{white})%F{reset}'
        else
            # Changes
            zstyle ':vcs_info:git:*' formats '%F{white}(%F{cyan}%b %F{reset}|%F{red}✗%F{white})%F{reset}'
        fi
    else
        zstyle ':vcs_info:*' formats ''
    fi
}
zstyle ':vcs_info:*' enable git
PROMPT=$'\n%F{yellow}%~ ${vcs_info_msg_0_}${vcs_info_msg_1_}%F{reset}\n $ '

