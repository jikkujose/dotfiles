take() {
    mkdir -p "$@" && cd "$@"
}

function sss() {
  surge . "https://$1.surge.sh"
}

rl() {
  ruby -ne "puts \$_.$1"
}

jina() {
    if [ -z "$1" ]; then
        echo "Usage: l2t <URL_TO_EXTRACT>"
        return 1
    fi

    local url="https://r.jina.ai/$1"
    curl -s "$url"
}

q () {
  jina "$1" | llm -p quick | tabularize
}

qq () {
  xclip -o -selection clipboard | llm -p quick | tabularize
}
