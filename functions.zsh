ip(){
	echo "Ethernet: `ipconfig getifaddr en0 \n`"
	echo "External: `curl -s http://ipecho.net/plain`"
  echo "WiFi    : `ifconfig | grep inet | grep broadc | cut -d ' ' -f 2`"
}

# change directory to your finders location
function cdfinder()
{
cd "$(osascript -e 'tell application "Finder"' \
  -e 'set myname to POSIX path of (target of window 1 as alias)' \
  -e 'end tell' 2>/dev/null)"
}

if [ -z "$TMUX" ]; then
  tmux attach-session -t "$target_session" \; select-pane -t "$target_window.$target_pane"
else
  tmux switch-client -t "$target_session:$target_window.$target_pane"
fi
  }

take() {
    mkdir -p "$@" && cd "$@"
}

function sss() {
  surge . "https://$1.surge.sh"
}
