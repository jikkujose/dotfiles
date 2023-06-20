autoload -Uz vcs_info
zstyle ':vcs_info:git:*' actionformats '%F{white}(%F{cyan}%b%F{white})%F{reset}'
zstyle ':vcs_info:git:*' formats '%F{white}(%F{cyan}%b %F{reset}|%F{red} ✗ %F{reset}%F{white})%F{reset}'
zstyle ':vcs_info:*' enable git
precmd() { vcs_info }
setopt PROMPT_SUBST
PROMPT=$'\n%F{yellow}%~ ${vcs_info_msg_1_}${vcs_info_msg_0_}%F{reset}\n $ '

zstyle ':vcs_info:*' check-for-changes true
+vi-git() {
    if (( $#BUFFER == 0 )); then
        git diff --quiet --ignore-submodules HEAD &>/dev/null
        [[ $? == 0 ]] && hook_com[staged]=''
    fi
}
zstyle -e ':vcs_info:git+set-message:*' hooks 'reply=(vi-git)'
