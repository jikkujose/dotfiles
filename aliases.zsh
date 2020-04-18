#!/usr/bin/zsh

alias ..="cd .."
alias ag="ag -i"
alias bex="bundle exec"
alias bi="bundle install"
alias bs="source ~/.zshrc"
alias buc="bundle console"
alias c="pbcopy"
alias cat="ccat"
alias crn="cmus-remote -n"
alias crp="cmus-remote -p"
alias crs="cmus-remote -s"
alias ctags="`brew --prefix`/bin/ctags"
alias cask-repo="cd /usr/local/Homebrew/Library/Taps/caskroom/homebrew-cask"
alias d-hide="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias d-show="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias d="cd ~/Desktop"
alias dld="http --body --download --continue -o"
alias encrypt_for="gpg --encrypt --armor --recipient $1"
alias decrypt="gpg --decrypt"
alias largest-files="du -hs * | sort -r | head -5"
alias docker-init_env='eval "$(docker-machine env default)"'
alias dw="cd ~/Downloads"
alias e="echo"
alias ee="set -o emacs"
alias etest="rerun -c ruby *test*"
alias ga="git add"
alias gb="git branch --all"
alias gc="git commit "
alias geth_dev="geth --dev --datadir $ETHEREUM_DEV --rpc"
alias geth_forked="geth --cache=2048 --datadir $ETHEREUM_FORKED --light"
alias geth-console="geth --jspath $HOME/Ethereum/scripts attach"
alias geth_testnet-console="geth attach "ipc://$HOME/Library/Ethereum/testnet/geth.ipc" --jspath /Users/jikkujose/Ethereum/scripts"
alias gdoc="open 'https://drive.google.com/open?id=1yFH4zSq0AJ9nnqneRyZ8uEzPPVmldqlV9asM3EDExgI'"
alias gh_markdown="pandoc -c 'http://yegor256.github.io/tacit/tacit.min.css' -s"
alias ginvoice="open 'https://drive.google.com/open?id=1rpLt4NE3FkSIOfiairt-yaqOjO8X6q3pFZ9LyvB_7-A'"
alias gp="git push"
alias grep="grep -i --extended-regex "
alias gs="git status"
alias gss="open 'https://drive.google.com/open?id=1WOSl0pNHUvPd94ASWkNezdZcrNR4pOHSGVotBq0Y9rI'"
alias gu="git pull"
alias h="http --follow"
alias json="python -m json.tool"
alias l="ls -Gurp"
alias learnt="echo `date '+ %a %h %d %Y %r'` ' - ' $@ >> ~/Links/logs/learning.log"
alias ll="ls -lGurp"
alias lll="ls -laGurp"
alias logit="echo `date '+ %a %h %d %Y %r'` ' - ' $@"
alias nn="nvim"
alias p="pbpaste"
alias pc="glo | head -n 1"
alias pdf-join="'/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py' -o"
alias pmt-dbg='PROMPT="☕️  @ dbg > "'
alias pmt-long="PROMPT='%{$reset_color%}[%{$fg[cyan]%}%2~%{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}%{$reset_color%}] $ '"
alias pmt-short="PROMPT='%{$fg[cyan]%}> %{$resetcolor%}'"
alias pr="pagerank"
alias pry="pry --simple-prompt"
alias ql="qlmanage -p"
alias r="ruby"
alias rake="noglob rake"
alias rm="rm -i"
alias rmrf="rm -rfi"
alias rr="rerun -c ruby"
alias rrr="cd ~/Ruby/scrap"
alias rspec="rspec --color"
alias sd="say 'ding dong'"
alias sizeof="du -sh"
alias sl="df -h / | tail -n 1 | ruby -e \"puts STDIN.read.split(' ')[3].split('G')[0] + ' GB'\""
alias ss="subdb download ./*"
alias ta="tmux attach"
alias tt="tree -N -I 'node_modules|dist'"
alias uf="pbpaste | pbcopy"
alias fu="pbcopy | pbpaste"
alias v="vim"
alias vd="source ~/Downloads/vd.sh"
alias vv="set -o vi"
alias wf="wolfram"
alias wttr="curl -4s http://wttr.in | head -n 7"
alias ww='fzf_windows'
alias xx="logout"
alias xxx="logout"
alias cors-less-chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --disable-web-security --user-data-dir /tmp"
alias qb="gs && ga . && gc -m 'Automated commit' && gp"
alias hmc="glo | wc -l"
