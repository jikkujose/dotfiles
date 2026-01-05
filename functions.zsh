take() {
    mkdir -p "$@" && cd "$@"
}

kimi() {
ANTHROPIC_BASE_URL="$MOONSHOT_BASE_URL"
ANTHROPIC_AUTH_TOKEN="$MOONSHOT_API_KEY"

claude $1
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

jq-analyze() {
  local threshold=${1:-50}
  jq "walk(if type == \"string\" and length > $threshold then \"[content truncated]\" else . end)"
}

server() {
    local port=${1:-8000}
    python3 -c "
from http.server import SimpleHTTPRequestHandler, HTTPServer
from datetime import datetime
class Q(SimpleHTTPRequestHandler):
    def handle(self):
        try: super().handle()
        except BrokenPipeError: pass
    def log_message(self, format, *args):
        print(f'{self.client_address[0]} - {datetime.now().strftime(\"%H:%M:%S\")} - {args[0].split()[1]}')
print('Serving on http://0.0.0.0:$port')
HTTPServer(('0.0.0.0', $port), Q).serve_forever()
"
}
