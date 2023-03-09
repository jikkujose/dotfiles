take() {
    mkdir -p "$@" && cd "$@"
}

function sss() {
  surge . "https://$1.surge.sh"
}
