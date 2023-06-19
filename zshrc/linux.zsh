. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

export HOST_IP="$(ip route |awk '/^default/{print $3}')"
