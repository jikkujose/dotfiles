function s () {
  ccat $1 | less
}

fo() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && open "$file"
}

fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

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

function fzf_windows() {
local panes target

panes=$(tmux list-panes -a -F '#{session_name}: #{window_name} (#I:#P)')
target=$(echo "$panes" | column -t -s ";" | fzf --select-1 --exit-0 --query="$1" --prompt="tmux window > ") || return

local target_session=$(echo $target | cut -d ":" -f1)
local target_window=$(echo $target | cut -d "(" -f2 | cut -d ":" -f1)
local target_pane=$(echo $target | cut -d '(' -f2 | cut -d ':' -f2 | cut -c 1)

if [ -z "$TMUX" ]; then
  tmux attach-session -t "$target_session" \; select-pane -t "$target_window.$target_pane"
else
  tmux switch-client -t "$target_session:$target_window.$target_pane"
fi
  }
