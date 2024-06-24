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
  jina "$1" | llm -i li -p json | tabularize
}

qq () {
  xclip -o -selection clipboard | llm -i li -p json | tabularize
}

function expose() {
  if [[ -z "$1" ]]; then
    echo "Error: No port specified."
    return 1  # Exit the function with an error status
  fi
  local port=$1
  ssh -R 80:localhost:${port} nokey@localhost.run 2>&1 | awk '/https:\/\/[a-zA-Z0-9]+\.lhr\.life/ {print $NF; fflush(); exit}'
}
