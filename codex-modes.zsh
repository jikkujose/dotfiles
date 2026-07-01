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

_codex_zyt_provider() {
    print -r -- "${CODEX_ZYT_PROVIDER:-foundry-zyt}"
}

_codex_zyt_base_url() {
    print -r -- "${CODEX_ZYT_BASE_URL:-${PI_ZYT_BASE_URL:-${FOUNDRY_BASE_URL:-https://foundry.zyt.app/v1}}}"
}

_codex_zyt_env_file() {
    print -r -- "${CODEX_ZYT_ENV_FILE:-${PI_ZYT_ENV_FILE:-$HOME/.foundry-zyt.env}}"
}

_codex_zyt_load_env() {
    [[ -n "${FOUNDRY_API_KEY:-}" ]] && return 0

    local env_file line value
    env_file="$(_codex_zyt_env_file)" || return
    [[ -f "$env_file" ]] || return 0

    line="$(command grep -m 1 '^FOUNDRY_API_KEY=' "$env_file" 2>/dev/null)" || return 0
    value="${line#FOUNDRY_API_KEY=}"
    value="${value%$'\r'}"
    value="${value#\"}"
    value="${value%\"}"
    value="${value#\'}"
    value="${value%\'}"

    [[ -n "$value" ]] && export FOUNDRY_API_KEY="$value"
}

_codex_zyt_require_key() {
    _codex_zyt_load_env

    if [[ -z "${FOUNDRY_API_KEY:-}" ]]; then
        echo "cx-zyt: set FOUNDRY_API_KEY first, for example in ~/.private.zsh or $(_codex_zyt_env_file):" >&2
        echo "  FOUNDRY_API_KEY=fnd_<12-char-key-id>_<secret>" >&2
        return 1
    fi
}

_codex_zyt_model() {
    print -r -- "${CODEX_ZYT_MODEL:-${PI_ZYT_MODEL:-gpt-5.5}}"
}

_codex_zyt_reasoning() {
    print -r -- "${CODEX_ZYT_REASONING:-${PI_ZYT_THINKING:-xhigh}}"
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

_codex_azure_alt_model() {
    local model="${CODEX_AZURE_ALT_MODEL:-${CODEX_AZURE_ALT_DEPLOYMENT:-${AZURE_OPENAI_ALT_DEPLOYMENT:-${AZURE_OPENAI_ALT_DEPLOYMENT_NAME:-}}}}"

    if [[ -n "$model" ]]; then
        print -r -- "$model"
        return
    fi

    _codex_azure_model
}

_codex_azure_alt_resource() {
    print -r -- "${CODEX_AZURE_ALT_RESOURCE:-${AZURE_OPENAI_ALT_RESOURCE:-vishak}}"
}

_codex_azure_alt_resource_group() {
    print -r -- "${CODEX_AZURE_ALT_RESOURCE_GROUP:-${AZURE_OPENAI_ALT_RESOURCE_GROUP:-storybrain}}"
}

_codex_azure_alt_base_url() {
    local base_url="${CODEX_AZURE_ALT_BASE_URL:-${AZURE_OPENAI_ALT_BASE_URL:-}}"
    local endpoint="${CODEX_AZURE_ALT_ENDPOINT:-${AZURE_OPENAI_ALT_ENDPOINT:-}}"
    local resource

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

    resource="$(_codex_azure_alt_resource)" || return
    resource="${resource#https://}"
    resource="${resource#http://}"
    resource="${resource%%/*}"
    resource="${resource%.openai.azure.com}"
    print -r -- "https://${resource}.openai.azure.com/openai/v1"
}

_codex_azure_alt_key_value() {
    if [[ -n "${CODEX_AZURE_ALT_API_KEY:-}" ]]; then
        print -r -- "$CODEX_AZURE_ALT_API_KEY"
        return
    fi

    if [[ -n "${AZURE_OPENAI_ALT_API_KEY:-}" ]]; then
        print -r -- "$AZURE_OPENAI_ALT_API_KEY"
        return
    fi

    local resource resource_group key
    resource="$(_codex_azure_alt_resource)" || return
    resource_group="$(_codex_azure_alt_resource_group)" || return

    if ! command -v az >/dev/null 2>&1; then
        echo "cx-azure-alt: set CODEX_AZURE_ALT_API_KEY or AZURE_OPENAI_ALT_API_KEY; az not found for key lookup." >&2
        return 1
    fi

    key="$(az cognitiveservices account keys list --name "$resource" --resource-group "$resource_group" --query key1 -o tsv 2>/dev/null)" || {
        echo "cx-azure-alt: could not retrieve key for ${resource_group}/${resource}; set CODEX_AZURE_ALT_API_KEY." >&2
        return 1
    }

    if [[ -z "$key" ]]; then
        echo "cx-azure-alt: empty key for ${resource_group}/${resource}; set CODEX_AZURE_ALT_API_KEY." >&2
        return 1
    fi

    print -r -- "$key"
}

cx-zyt-status() {
    emulate -L zsh

    _codex_zyt_load_env

    local key_state="missing"
    [[ -n "${FOUNDRY_API_KEY:-}" ]] && key_state="set"

    local model reasoning
    model="$(_codex_zyt_model)" || return
    reasoning="$(_codex_zyt_reasoning)" || return
    if [[ "$model" == *:* ]]; then
        [[ -z "${CODEX_ZYT_REASONING:-}" ]] && reasoning="${model##*:}"
        model="${model%%:*}"
    fi

    echo "provider=$(_codex_zyt_provider)"
    echo "base_url=$(_codex_zyt_base_url)"
    echo "model=${model}"
    echo "reasoning=${reasoning}"
    echo "api_key=$key_state (FOUNDRY_API_KEY)"
    echo "env_file=$(_codex_zyt_env_file)"
    echo "codex_home=${CODEX_ZYT_HOME:-$HOME/.codex-zyt}"
}

cx-zyt() {
    emulate -L zsh
    _codex_require_cli || return
    _codex_zyt_require_key || return

    local home_dir provider base_url model reasoning model_display
    local has_model=0
    local arg

    for arg in "$@"; do
        case "$arg" in
            --model|-m|--model=*|-m=*) has_model=1 ;;
        esac
    done

    home_dir="$(_codex_home "${CODEX_ZYT_HOME:-$HOME/.codex-zyt}")" || return
    provider="$(_codex_zyt_provider)" || return
    base_url="$(_codex_zyt_base_url)" || return
    model="$(_codex_zyt_model)" || return
    reasoning="$(_codex_zyt_reasoning)" || return

    if [[ "$model" == *:* ]]; then
        [[ -z "${CODEX_ZYT_REASONING:-}" ]] && reasoning="${model##*:}"
        model="${model%%:*}"
    fi

    local -a model_args reasoning_args
    model_args=()
    reasoning_args=()
    (( has_model == 0 )) && model_args+=(--model "$model")
    if [[ -n "$reasoning" && "$reasoning" != "default" ]]; then
        reasoning_args+=(--config "model_reasoning_effort=$(_codex_toml_string "$reasoning")")
    fi

    model_display="$model"
    [[ -n "$reasoning" && "$reasoning" != "default" ]] && model_display="${model_display}:${reasoning}"
    echo "Mode: Codex via Foundry ZYT (${provider}, ${model_display}, ${base_url})"

    CODEX_HOME="$home_dir" FOUNDRY_API_KEY="$FOUNDRY_API_KEY" env -u OPENAI_API_KEY -u AZURE_OPENAI_API_KEY -u AZURE_OPENAI_KEY \
        codex --dangerously-bypass-approvals-and-sandbox \
        "${model_args[@]}" \
        --config "model_provider=$(_codex_toml_string "$provider")" \
        --config "model_providers.${provider}.name=$(_codex_toml_string "Foundry ZYT")" \
        --config "model_providers.${provider}.base_url=$(_codex_toml_string "$base_url")" \
        --config "model_providers.${provider}.env_key=$(_codex_toml_string "FOUNDRY_API_KEY")" \
        --config "model_providers.${provider}.wire_api=$(_codex_toml_string "responses")" \
        "${reasoning_args[@]}" \
        "$@"
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
    local -a codex_args
    codex_args=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --fast)
                echo "cx-azure: --fast ignored; Azure priority is controlled by the selected deployment." >&2
                shift
                ;;
            --)
                shift
                codex_args+=("$@")
                break
                ;;
            *)
                codex_args+=("$1")
                shift
                ;;
        esac
    done

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
        "${codex_args[@]}"
}

cx-azure-alt() {
    emulate -L zsh

    local base_url key model
    base_url="$(_codex_azure_alt_base_url)" || return
    key="$(_codex_azure_alt_key_value)" || return
    model="$(_codex_azure_alt_model)" || return

    CODEX_AZURE_API_KEY="$key" CODEX_AZURE_BASE_URL="$base_url" CODEX_AZURE_MODEL="$model" cx-azure "$@"
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
    echo "Priority control: Azure deployment setting; Codex service_tier is not sent"
}

cx-azure-alt-status() {
    emulate -L zsh

    local base_url key model resource resource_group
    resource="$(_codex_azure_alt_resource)" || return
    resource_group="$(_codex_azure_alt_resource_group)" || return
    base_url="$(_codex_azure_alt_base_url)" || return
    key="$(_codex_azure_alt_key_value)" || return
    model="$(_codex_azure_alt_model)" || return

    echo "Azure alt resource: ${resource_group}/${resource}"
    CODEX_AZURE_API_KEY="$key" CODEX_AZURE_BASE_URL="$base_url" CODEX_AZURE_MODEL="$model" cx-azure-status "$@"
}

unalias cx 2>/dev/null
cx() {
    cx-azure "$@"
}
