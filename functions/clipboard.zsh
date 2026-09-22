# Portable c/p clipboard functions for zsh.
#
# Local sessions use the operating system clipboard. Headless SSH sessions use
# OSC 52 through the attached terminal; tmux's clipboard bridge is preferred
# because it handles both encoding and terminal responses.

unalias c p 2>/dev/null || true

_clipboard_backend() {
  emulate -L zsh
  local operation="$1"

  # Remote shells should target the clipboard of the terminal running SSH,
  # even when X forwarding or dotfiles leave a DISPLAY value behind.
  if [[ -n "${SSH_CONNECTION:-}${SSH_CLIENT:-}${SSH_TTY:-}" ]]; then
    return 1
  fi

  case "$(uname -s)" in
    Darwin)
      if [[ "$operation" == copy ]] && command -v pbcopy >/dev/null 2>&1; then
        print -r -- mac
        return 0
      fi
      if [[ "$operation" == paste ]] && command -v pbpaste >/dev/null 2>&1; then
        print -r -- mac
        return 0
      fi
      ;;
    Linux)
      if grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
        if [[ "$operation" == copy ]] && command -v clip.exe >/dev/null 2>&1; then
          print -r -- wsl
          return 0
        fi
        if [[ "$operation" == paste ]] && command -v powershell.exe >/dev/null 2>&1; then
          print -r -- wsl
          return 0
        fi
      fi

      if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
        if [[ "$operation" == copy ]] && command -v wl-copy >/dev/null 2>&1; then
          print -r -- wayland
          return 0
        fi
        if [[ "$operation" == paste ]] && command -v wl-paste >/dev/null 2>&1; then
          print -r -- wayland
          return 0
        fi
      fi

      if [[ -n "${DISPLAY:-}" ]]; then
        if command -v xclip >/dev/null 2>&1; then
          print -r -- xclip
          return 0
        fi
        if command -v xsel >/dev/null 2>&1; then
          print -r -- xsel
          return 0
        fi
      fi
      ;;
  esac

  return 1
}

_clipboard_native_copy() {
  emulate -L zsh
  case "$1" in
    mac) command pbcopy ;;
    wayland) command wl-copy ;;
    xclip) command xclip -selection clipboard ;;
    xsel) command xsel --clipboard --input ;;
    wsl) command clip.exe ;;
    *) return 1 ;;
  esac
}

_clipboard_native_paste() {
  emulate -L zsh
  case "$1" in
    mac) command pbpaste ;;
    wayland) command wl-paste --no-newline ;;
    xclip) command xclip -o -selection clipboard ;;
    xsel) command xsel --clipboard --output ;;
    wsl)
      command powershell.exe -NoLogo -NoProfile -NonInteractive -Command \
        '[Console]::Out.Write((Get-Clipboard -Raw))' | command tr -d '\r'
      ;;
    *) return 1 ;;
  esac
}

_clipboard_tmux_copy() {
  emulate -L zsh
  local pane="${TMUX_PANE//[^[:alnum:]]/_}"
  local buffer="clipboard-${pane:-pane}-$$-${RANDOM}"
  local status

  command tmux load-buffer -b "$buffer" -w -
  status=$?
  command tmux delete-buffer -b "$buffer" >/dev/null 2>&1 || true
  return "$status"
}

_clipboard_tmux_buffer_paste() {
  emulate -L zsh
  local timeout="${CLIPBOARD_QUERY_TIMEOUT:-30}"
  local interval="0.05"
  local name found="" status
  local -i attempt attempts
  local -A existing

  [[ "$timeout" == <1-> ]] || {
    print -u2 -- "p: CLIPBOARD_QUERY_TIMEOUT must be a positive integer"
    return 2
  }
  attempts=$(( timeout * 20 ))

  for name in ${(f)"$(command tmux list-buffers -F '#{buffer_name}' 2>/dev/null || true)"}; do
    [[ -n "$name" ]] && existing[$name]=1
  done

  # tmux 3.7 removed refresh-client's direct-to-pane mode. Its remaining -l
  # form stores the terminal's reply in a fresh paste buffer instead.
  command tmux refresh-client -l || return $?

  for (( attempt = 0; attempt < attempts; attempt++ )); do
    for name in ${(f)"$(command tmux list-buffers -F '#{buffer_name}' 2>/dev/null || true)"}; do
      if [[ -n "$name" && -z "${existing[$name]-}" ]]; then
        found="$name"
        break 2
      fi
    done
    command sleep "$interval"
  done

  if [[ -z "$found" ]]; then
    print -u2 -- "p: clipboard query timed out after ${timeout}s (denied, empty, or unsupported)"
    return 1
  fi

  command tmux save-buffer -b "$found" -
  status=$?
  command tmux delete-buffer -b "$found" >/dev/null 2>&1 || true
  return "$status"
}

_clipboard_osc52_copy() {
  emulate -L zsh
  local tty=/dev/tty

  [[ -w "$tty" ]] || {
    print -u2 -- "c: no local clipboard and no writable terminal"
    return 1
  }

  print -rn -- $'\e]52;c;' >"$tty"
  command base64 | command tr -d '\n' >"$tty"
  print -rn -- $'\e\\' >"$tty"
}

_clipboard_base64_decode() {
  emulate -L zsh
  if [[ "$(uname -s)" == Darwin ]]; then
    command base64 -D
  else
    command base64 -d
  fi
}

_clipboard_query_paste() {
  emulate -L zsh
  local request="$1"
  local tty=/dev/tty
  local timeout="${CLIPBOARD_QUERY_TIMEOUT:-30}"
  local saved response="" char body
  local complete=0 request_status=0

  [[ "$timeout" == <1-> ]] || {
    print -u2 -- "p: CLIPBOARD_QUERY_TIMEOUT must be a positive integer"
    return 2
  }
  [[ -r "$tty" && -w "$tty" ]] || {
    print -u2 -- "p: no local clipboard and no readable terminal"
    return 1
  }

  saved="$(command stty -g <"$tty")" || return 1
  command stty raw -echo <"$tty" || return 1
  {
    case "$request" in
      terminal)
        print -rn -- $'\e]52;c;?\e\\' >"$tty"
        request_status=$?
        ;;
      tmux-pane)
        command tmux refresh-client "-l${TMUX_PANE}"
        request_status=$?
        ;;
      *)
        request_status=2
        ;;
    esac

    if (( request_status == 0 )); then
      while IFS= read -r -k 1 -t "$timeout" char <"$tty"; do
        response+="$char"
        if [[ "$response" == *$'\e\\' || "$response" == *$'\a' ]]; then
          complete=1
          break
        fi
      done
    fi
  } always {
    command stty "$saved" <"$tty"
  }

  (( request_status == 0 )) || return "$request_status"
  if (( ! complete )) || [[ "$response" != *$'\e]52;'* ]]; then
    print -u2 -- "p: terminal did not answer the OSC 52 clipboard query"
    return 1
  fi

  body="${response#*$'\e]52;'}"
  body="${body#*;}"
  body="${body%%$'\e\\'*}"
  body="${body%%$'\a'*}"
  print -rn -- "$body" | _clipboard_base64_decode
}

_clipboard_tmux_paste() {
  emulate -L zsh
  local version major rest minor

  version="$(command tmux display-message -p '#{version}' 2>/dev/null)" || return 1
  major="${version%%.*}"
  rest="${version#*.}"
  minor="${rest%%[^0-9]*}"

  # tmux 3.3-3.6 can route the encoded reply directly back to this pane,
  # avoiding paste-buffer races and correctly representing an empty clipboard.
  if [[ "$major" == <-> && "$minor" == <-> ]] &&
     (( major == 3 && minor >= 3 && minor < 7 )); then
    _clipboard_query_paste tmux-pane
  else
    _clipboard_tmux_buffer_paste
  fi
}

_clipboard_osc52_paste() {
  _clipboard_query_paste terminal
}

c() {
  emulate -L zsh
  local backend

  if backend="$(_clipboard_backend copy)"; then
    _clipboard_native_copy "$backend"
  elif [[ -n "${TMUX:-}" ]] && command -v tmux >/dev/null 2>&1; then
    _clipboard_tmux_copy
  else
    _clipboard_osc52_copy
  fi
}

p() {
  emulate -L zsh
  local backend

  if backend="$(_clipboard_backend paste)"; then
    _clipboard_native_paste "$backend"
  elif [[ -n "${TMUX:-}" ]] && command -v tmux >/dev/null 2>&1; then
    _clipboard_tmux_paste
  else
    _clipboard_osc52_paste
  fi
}
