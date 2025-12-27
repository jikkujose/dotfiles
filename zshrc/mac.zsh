# z directory jumping
source $(brew --prefix)/share/zsh-site-functions/_z 2>/dev/null || source $(brew --prefix)/etc/profile.d/z.sh 2>/dev/null

alias unquarintine="xattr -d com.apple.quarantine"
alias brave-debug-instance='/Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser --remote-debugging-port=9222 --user-data-dir="$HOME/.config/brave-browser"'
