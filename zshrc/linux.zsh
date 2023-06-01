. "$HOME/.asdf/asdf.sh"

export HOST_IP="$(ip route |awk '/^default/{print $3}')"
