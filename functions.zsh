take() {
    mkdir -p "$@" && cd "$@"
}

function sss() {
  surge . "https://$1.surge.sh"
}

gpt3() {
  https --body "https://oai.toolbomber.com/gpt3" prompt="$*" | xargs -0 echo -e
}

gpt4() {
  https --body "https://oai.toolbomber.com/gpt4" prompt="$*" | xargs -0 echo -e
}
