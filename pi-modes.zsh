# === Pi Mode Functions ===
# Secrets stay outside dotfiles. Add this to ~/.private.zsh:
#   export FOUNDRY_API_KEY='fnd_<12-char-key-id>_<secret>'

_pi_zyt_source="$HOME/Projects/zyt/foundry/scripts/pi-zyt.zsh"

if [[ -f "$_pi_zyt_source" ]]; then
  source "$_pi_zyt_source"
else
  pi-zyt() {
    print -u2 "pi-zyt: missing $_pi_zyt_source"
    return 1
  }

  pi-zyt-status() {
    print -u2 "pi-zyt: missing $_pi_zyt_source"
    return 1
  }

  pi-zyt-models() {
    print -u2 "pi-zyt: missing $_pi_zyt_source"
    return 1
  }

  pi-zyt-smoke() {
    print -u2 "pi-zyt: missing $_pi_zyt_source"
    return 1
  }
fi

unset _pi_zyt_source
