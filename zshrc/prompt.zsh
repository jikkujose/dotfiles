autoload -Uz vcs_info
zstyle ':vcs_info:git:*' actionformats '%F{white}(%F{cyan}%b %F{reset}|%F{green} √ %F{reset}%F{white})%F{reset}'
zstyle ':vcs_info:git:*' formats '%F{white}(%F{cyan}%b %F{reset}|%F{red} ✗%F{reset}%F{white})%F{reset}'
zstyle ':vcs_info:*' enable git
precmd() { vcs_info }
setopt PROMPT_SUBST
PROMPT=$'\n%F{yellow}%~ ${vcs_info_msg_1_}${vcs_info_msg_0_}%F{reset}\n $ '

