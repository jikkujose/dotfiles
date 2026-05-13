# === Codex Mode Functions ===

_codex_toml_string() {
    local value="$1"
    value="${value//\\/\\\\}"
    value="${value//\"/\\\"}"
    print -r -- "\"$value\""
}

_codex_require_cli() {
    if ! command -v codex >/dev/null 2>&1; then
        echo "codex: command not found" >&2
        return 1
    fi
}

_codex_home() {
    local home_dir="$1"
    mkdir -p "$home_dir"
    print -r -- "$home_dir"
}

_codex_azure_key_env() {
    if [[ -n "${CODEX_AZURE_API_KEY:-}" ]]; then
        print -r -- "CODEX_AZURE_API_KEY"
    elif [[ -n "${AZURE_OPENAI_KEY:-}" ]]; then
        print -r -- "AZURE_OPENAI_KEY"
    elif [[ -n "${AZURE_OPENAI_API_KEY:-}" ]]; then
        print -r -- "AZURE_OPENAI_API_KEY"
    else
        echo "cx-azure: set AZURE_OPENAI_API_KEY, AZURE_OPENAI_KEY, or CODEX_AZURE_API_KEY." >&2
        return 1
    fi
}

_codex_azure_base_url() {
    local base_url="${CODEX_AZURE_BASE_URL:-${AZURE_OPENAI_BASE_URL:-}}"
    local endpoint="${CODEX_AZURE_ENDPOINT:-${AZURE_OPENAI_ENDPOINT:-}}"
    local resource="${CODEX_AZURE_RESOURCE:-${AZURE_OPENAI_RESOURCE:-}}"

    if [[ -n "$base_url" ]]; then
        print -r -- "${base_url%/}"
        return
    fi

    if [[ -n "$endpoint" ]]; then
        endpoint="${endpoint%/}"
        case "$endpoint" in
            */openai/v1) print -r -- "$endpoint" ;;
            */openai) print -r -- "$endpoint/v1" ;;
            *) print -r -- "$endpoint/openai/v1" ;;
        esac
        return
    fi

    if [[ -n "$resource" ]]; then
        resource="${resource#https://}"
        resource="${resource#http://}"
        resource="${resource%%/*}"
        resource="${resource%.openai.azure.com}"
        print -r -- "https://${resource}.openai.azure.com/openai/v1"
        return
    fi

    echo "cx-azure: set AZURE_OPENAI_ENDPOINT, AZURE_OPENAI_BASE_URL, AZURE_OPENAI_RESOURCE, or CODEX_AZURE_BASE_URL." >&2
    return 1
}

_codex_azure_model() {
    local model="${CODEX_AZURE_MODEL:-${AZURE_OPENAI_DEPLOYMENT:-${AZURE_OPENAI_DEPLOYMENT_NAME:-${AZURE_OPENAI_MODEL:-}}}}"

    if [[ -z "$model" ]]; then
        echo "cx-azure: set AZURE_OPENAI_DEPLOYMENT, AZURE_OPENAI_DEPLOYMENT_NAME, AZURE_OPENAI_MODEL, or CODEX_AZURE_MODEL." >&2
        return 1
    fi

    print -r -- "$model"
}

cx-subscription-login() {
    emulate -L zsh
    _codex_require_cli || return

    local home_dir
    home_dir="$(_codex_home "${CODEX_SUBSCRIPTION_HOME:-$HOME/.codex-chatgpt}")" || return

    echo "Mode: Codex ChatGPT subscription login"
    CODEX_HOME="$home_dir" env -u OPENAI_API_KEY -u AZURE_OPENAI_API_KEY -u AZURE_OPENAI_KEY codex login "$@"
}

cx-subscription-status() {
    emulate -L zsh
    _codex_require_cli || return

    local home_dir
    home_dir="$(_codex_home "${CODEX_SUBSCRIPTION_HOME:-$HOME/.codex-chatgpt}")" || return

    CODEX_HOME="$home_dir" env -u OPENAI_API_KEY -u AZURE_OPENAI_API_KEY -u AZURE_OPENAI_KEY codex login status "$@"
}

cx-subscription() {
    emulate -L zsh
    _codex_require_cli || return

    local home_dir
    home_dir="$(_codex_home "${CODEX_SUBSCRIPTION_HOME:-$HOME/.codex-chatgpt}")" || return

    echo "Mode: Codex ChatGPT subscription"
    CODEX_HOME="$home_dir" env -u OPENAI_API_KEY -u AZURE_OPENAI_API_KEY -u AZURE_OPENAI_KEY \
        codex --dangerously-bypass-approvals-and-sandbox "$@"
}

cx-azure() {
    emulate -L zsh
    _codex_require_cli || return

    local home_dir key_env base_url model
    home_dir="$(_codex_home "${CODEX_AZURE_HOME:-$HOME/.codex-azure}")" || return
    key_env="$(_codex_azure_key_env)" || return
    base_url="$(_codex_azure_base_url)" || return
    model="$(_codex_azure_model)" || return

    echo "Mode: Codex Azure OpenAI (${model})"
    CODEX_HOME="$home_dir" env -u OPENAI_API_KEY \
        codex --dangerously-bypass-approvals-and-sandbox \
        --model "$model" \
        --config "model_provider=$(_codex_toml_string "azure")" \
        --config "model_providers.azure.name=$(_codex_toml_string "Azure OpenAI")" \
        --config "model_providers.azure.base_url=$(_codex_toml_string "$base_url")" \
        --config "model_providers.azure.env_key=$(_codex_toml_string "$key_env")" \
        --config "model_providers.azure.wire_api=$(_codex_toml_string "responses")" \
        "$@"
}

cx-azure-status() {
    emulate -L zsh

    local key_env base_url model
    key_env="$(_codex_azure_key_env)" || return
    base_url="$(_codex_azure_base_url)" || return
    model="$(_codex_azure_model)" || return

    echo "Azure key env: ${key_env}"
    echo "Azure base URL: ${base_url}"
    echo "Azure model/deployment: ${model}"
}

unalias cx 2>/dev/null
cx() {
    cx-azure "$@"
}
