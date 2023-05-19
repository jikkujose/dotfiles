#!/usr/bin/zsh
#
alias d="cd ~/Desktop"
alias dw="cd ~/Downloads/"

alias ..="cd .."
alias "..."="cd ../.."
alias ag="ag -i"
alias bs="source ~/.zshrc"
alias e="echo"

alias uf="p | c"
alias fu="c | p"
alias rp="echo 'Hello' | c"

alias sp="switch_profile"
alias wp="which_profile"

alias ee="set -o emacs"
alias vv="set -o vi"

alias ga="git add"
alias gb="git branch --all"
alias gc="git commit "
alias gp="git push"
alias gs="git status"
alias gu="git pull"
alias gl="git log --oneline"
alias gd="git diff"
alias gt="git log --oneline | head -n 1"
alias gr="gs && ga . && gc -m 'Automated commit' && gp"
alias gco="git checkout"

alias grep="grep -i --extended-regex "
alias h="http --follow"
alias l="ls -Gurp"
alias ll="ls -lGurp"
alias lll="ls -laGurp"

alias np='unshare -rn nvim --clean -n -c "set nobackup noswapfile noundofile"'
alias nn="NVIM_APPNAME=nvim/legacy nvim"
alias nz="NVIM_APPNAME=nvim/lazy unshare -rn nvim"
alias nzi="NVIM_APPNAME=nvim/lazy nvim"

alias r="ruby"
alias rr="rerun -c ruby"
alias rrr="cd ~/Ruby/scrap"

alias rm="rm -i"
alias rmrf="rm -rfi"

alias pf="ps aux | ag"
alias sl="df -h / | tail -n 1 | ruby -e \"puts STDIN.read.split(' ')[3].split('G')[0] + ' GB'\""
alias ta="tmux attach"
alias tt="tree -N -I 'node_modules|dist'"
alias xx="logout"
alias xxx="logout"
alias cat="batcat"
alias nm_weight="find . -name 'node_modules' -type d -prune -print0 | xargs -0 du -chs"
alias nm_delete="find . -name 'node_modules' -type d -prune -print0 | xargs -0 rm -rf"

alias tb="nc termbin.com 9999"
alias city="curl https://am.i.mullvad.net/city"
alias q="qrencode -t ASCII | sed \"s/#/█/g\""
alias yy="yt-dlp -f 22"
alias br="bun run"
alias python="python3"
alias lora="~/Projects/gpt4all/chat/gpt4all-lora-quantized-linux-x86  -m ~/Projects/gpt4all/chat/gpt4all-lora-unfiltered-quantized.bin"
