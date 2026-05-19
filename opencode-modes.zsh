# === OpenCode Mode Functions ===

_opencode_require_cli() {
    if ! command -v opencode >/dev/null 2>&1; then
        echo "opencode: command not found" >&2
        return 1
    fi
}

_opencode_require_jq() {
    if ! command -v jq >/dev/null 2>&1; then
        echo "opencode-azure: jq is required to build runtime OpenCode config." >&2
        return 1
    fi
}

_opencode_azure_key_value() {
    if [[ -n "${OPENCODE_AZURE_API_KEY:-}" ]]; then
        print -r -- "$OPENCODE_AZURE_API_KEY"
    elif [[ -n "${CODEX_AZURE_API_KEY:-}" ]]; then
        print -r -- "$CODEX_AZURE_API_KEY"
    elif [[ -n "${AZURE_OPENAI_API_KEY:-}" ]]; then
        print -r -- "$AZURE_OPENAI_API_KEY"
    elif [[ -n "${AZURE_OPENAI_KEY:-}" ]]; then
        print -r -- "$AZURE_OPENAI_KEY"
    else
        echo "opencode-azure: set OPENCODE_AZURE_API_KEY, CODEX_AZURE_API_KEY, AZURE_OPENAI_API_KEY, or AZURE_OPENAI_KEY." >&2
        return 1
    fi
}

_opencode_azure_key_source() {
    if [[ -n "${OPENCODE_AZURE_API_KEY:-}" ]]; then
        print -r -- "OPENCODE_AZURE_API_KEY"
    elif [[ -n "${CODEX_AZURE_API_KEY:-}" ]]; then
        print -r -- "CODEX_AZURE_API_KEY"
    elif [[ -n "${AZURE_OPENAI_API_KEY:-}" ]]; then
        print -r -- "AZURE_OPENAI_API_KEY"
    elif [[ -n "${AZURE_OPENAI_KEY:-}" ]]; then
        print -r -- "AZURE_OPENAI_KEY"
    else
        echo "opencode-azure: set OPENCODE_AZURE_API_KEY, CODEX_AZURE_API_KEY, AZURE_OPENAI_API_KEY, or AZURE_OPENAI_KEY." >&2
        return 1
    fi
}

_opencode_azure_base_url_from_parts() {
    local base_url="$1"
    local endpoint="$2"
    local resource="$3"

    if [[ -n "$base_url" ]]; then
        base_url="${base_url%/}"
        base_url="${base_url%/openai/v1}"
        base_url="${base_url%/v1}"
        if [[ "$base_url" != */openai ]]; then
            base_url="${base_url}/openai"
        fi
        print -r -- "${base_url}"
        return
    fi

    if [[ -n "$endpoint" ]]; then
        endpoint="${endpoint%/}"
        case "$endpoint" in
            */openai/v1) print -r -- "${endpoint%/v1}" ;;
            */openai) print -r -- "$endpoint" ;;
            *) print -r -- "$endpoint/openai" ;;
        esac
        return
    fi

    if [[ -n "$resource" ]]; then
        resource="${resource#https://}"
        resource="${resource#http://}"
        resource="${resource%%/*}"
        resource="${resource%.openai.azure.com}"
        print -r -- "https://${resource}.openai.azure.com/openai"
        return
    fi

    echo "opencode-azure: set AZURE_OPENAI_ENDPOINT, AZURE_OPENAI_BASE_URL, AZURE_OPENAI_RESOURCE, or OPENCODE_AZURE_RESOURCE." >&2
    return 1
}

_opencode_azure_base_url() {
    _opencode_azure_base_url_from_parts \
        "${OPENCODE_AZURE_BASE_URL:-${CODEX_AZURE_BASE_URL:-${AZURE_OPENAI_BASE_URL:-}}}" \
        "${OPENCODE_AZURE_ENDPOINT:-${CODEX_AZURE_ENDPOINT:-${AZURE_OPENAI_ENDPOINT:-}}}" \
        "${OPENCODE_AZURE_RESOURCE:-${CODEX_AZURE_RESOURCE:-${AZURE_OPENAI_RESOURCE:-}}}"
}

_opencode_azure_resource_from_base_url() {
    local base_url="$1"
    local host="${base_url#https://}"
    host="${host#http://}"
    host="${host%%/*}"

    if [[ "$host" == *.openai.azure.com ]]; then
        print -r -- "${host%.openai.azure.com}"
        return
    fi

    print -r -- ""
}

_opencode_azure_resource() {
    local resource="${OPENCODE_AZURE_RESOURCE:-${CODEX_AZURE_RESOURCE:-${AZURE_OPENAI_RESOURCE:-}}}"
    local base_url

    if [[ -n "$resource" ]]; then
        resource="${resource#https://}"
        resource="${resource#http://}"
        resource="${resource%%/*}"
        resource="${resource%.openai.azure.com}"
        print -r -- "$resource"
        return
    fi

    base_url="$(_opencode_azure_base_url)" || return
    resource="$(_opencode_azure_resource_from_base_url "$base_url")"

    if [[ -z "$resource" ]]; then
        echo "opencode-azure: set OPENCODE_AZURE_RESOURCE or AZURE_OPENAI_RESOURCE; could not infer resourceName from ${base_url}." >&2
        return 1
    fi

    print -r -- "$resource"
}

_opencode_azure_model() {
    local model="${OPENCODE_AZURE_MODEL:-${OPENCODE_AZURE_DEPLOYMENT:-${CODEX_AZURE_MODEL:-${AZURE_OPENAI_DEPLOYMENT:-${AZURE_OPENAI_DEPLOYMENT_NAME:-${AZURE_OPENAI_MODEL:-}}}}}}"

    if [[ -z "$model" ]]; then
        echo "opencode-azure: set OPENCODE_AZURE_MODEL, OPENCODE_AZURE_DEPLOYMENT, AZURE_OPENAI_DEPLOYMENT, AZURE_OPENAI_DEPLOYMENT_NAME, or AZURE_OPENAI_MODEL." >&2
        return 1
    fi

    print -r -- "$model"
}

_opencode_azure_alt_resource() {
    print -r -- "${OPENCODE_AZURE_ALT_RESOURCE:-${CODEX_AZURE_ALT_RESOURCE:-${AZURE_OPENAI_ALT_RESOURCE:-vishak}}}"
}

_opencode_azure_alt_resource_group() {
    print -r -- "${OPENCODE_AZURE_ALT_RESOURCE_GROUP:-${CODEX_AZURE_ALT_RESOURCE_GROUP:-${AZURE_OPENAI_ALT_RESOURCE_GROUP:-storybrain}}}"
}

_opencode_azure_alt_base_url() {
    local resource
    resource="$(_opencode_azure_alt_resource)" || return

    _opencode_azure_base_url_from_parts \
        "${OPENCODE_AZURE_ALT_BASE_URL:-${CODEX_AZURE_ALT_BASE_URL:-${AZURE_OPENAI_ALT_BASE_URL:-}}}" \
        "${OPENCODE_AZURE_ALT_ENDPOINT:-${CODEX_AZURE_ALT_ENDPOINT:-${AZURE_OPENAI_ALT_ENDPOINT:-}}}" \
        "$resource"
}

_opencode_azure_alt_model() {
    local model="${OPENCODE_AZURE_ALT_MODEL:-${OPENCODE_AZURE_ALT_DEPLOYMENT:-${CODEX_AZURE_ALT_MODEL:-${CODEX_AZURE_ALT_DEPLOYMENT:-${AZURE_OPENAI_ALT_DEPLOYMENT:-${AZURE_OPENAI_ALT_DEPLOYMENT_NAME:-}}}}}}"

    if [[ -n "$model" ]]; then
        print -r -- "$model"
        return
    fi

    _opencode_azure_model
}

_opencode_azure_alt_key_value() {
    if [[ -n "${OPENCODE_AZURE_ALT_API_KEY:-}" ]]; then
        print -r -- "$OPENCODE_AZURE_ALT_API_KEY"
        return
    fi

    if [[ -n "${CODEX_AZURE_ALT_API_KEY:-}" ]]; then
        print -r -- "$CODEX_AZURE_ALT_API_KEY"
        return
    fi

    if [[ -n "${AZURE_OPENAI_ALT_API_KEY:-}" ]]; then
        print -r -- "$AZURE_OPENAI_ALT_API_KEY"
        return
    fi

    local resource resource_group key
    resource="$(_opencode_azure_alt_resource)" || return
    resource_group="$(_opencode_azure_alt_resource_group)" || return

    if ! command -v az >/dev/null 2>&1; then
        echo "opencode-azure-alt: set OPENCODE_AZURE_ALT_API_KEY, CODEX_AZURE_ALT_API_KEY, or AZURE_OPENAI_ALT_API_KEY; az not found for key lookup." >&2
        return 1
    fi

    key="$(az cognitiveservices account keys list --name "$resource" --resource-group "$resource_group" --query key1 -o tsv 2>/dev/null)" || {
        echo "opencode-azure-alt: could not retrieve key for ${resource_group}/${resource}; set OPENCODE_AZURE_ALT_API_KEY." >&2
        return 1
    }

    if [[ -z "$key" ]]; then
        echo "opencode-azure-alt: empty key for ${resource_group}/${resource}; set OPENCODE_AZURE_ALT_API_KEY." >&2
        return 1
    fi

    print -r -- "$key"
}

_opencode_azure_alt_key_source() {
    if [[ -n "${OPENCODE_AZURE_ALT_API_KEY:-}" ]]; then
        print -r -- "OPENCODE_AZURE_ALT_API_KEY"
    elif [[ -n "${CODEX_AZURE_ALT_API_KEY:-}" ]]; then
        print -r -- "CODEX_AZURE_ALT_API_KEY"
    elif [[ -n "${AZURE_OPENAI_ALT_API_KEY:-}" ]]; then
        print -r -- "AZURE_OPENAI_ALT_API_KEY"
    else
        local resource resource_group
        resource="$(_opencode_azure_alt_resource)" || return
        resource_group="$(_opencode_azure_alt_resource_group)" || return
        print -r -- "az:${resource_group}/${resource}:key1"
    fi
}

_opencode_arg_model() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -m|--model)
                if [[ $# -gt 1 ]]; then
                    print -r -- "$2"
                    return
                fi
                return 1
                ;;
            --model=*)
                print -r -- "${1#--model=}"
                return
                ;;
            --)
                return 1
                ;;
        esac
        shift
    done

    return 1
}

_opencode_has_model_arg() {
    _opencode_arg_model "$@" >/dev/null 2>&1
}

_opencode_azure_deployment_from_model_arg() {
    local model_arg="$1"

    case "$model_arg" in
        azure/*) print -r -- "${model_arg#azure/}" ;;
        */*) print -r -- "" ;;
        *) print -r -- "$model_arg" ;;
    esac
}

_opencode_first_non_option_arg() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --)
                shift
                [[ $# -gt 0 ]] && print -r -- "$1"
                return
                ;;
            -m|--model|-s|--session|--log-level|--port|--hostname|--mdns-domain|--cors|--prompt|--agent)
                if [[ $# -gt 1 ]]; then
                    shift 2
                else
                    return 1
                fi
                ;;
            --model=*|--session=*|--log-level=*|--port=*|--hostname=*|--mdns-domain=*|--cors=*|--prompt=*|--agent=*)
                shift
                ;;
            -*)
                shift
                ;;
            *)
                print -r -- "$1"
                return
                ;;
        esac
    done

    return 1
}

_opencode_command_accepts_model() {
    local command="$1"

    case "$command" in
        ""|run|serve|web|attach|pr)
            return 0
            ;;
        acp|agent|auth|completion|db|debug|export|github|import|mcp|models|plugin|plug|providers|session|stats|uninstall|upgrade)
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

_opencode_azure_config() {
    local key="$1"
    local base_url="$2"
    local resource="$3"
    local deployment="$4"

    jq -cn \
        --arg key "$key" \
        --arg base_url "$base_url" \
        --arg resource "$resource" \
        --arg deployment "$deployment" \
        '{
          "$schema": "https://opencode.ai/config.json",
          provider: {
            azure: {
              name: "Azure OpenAI",
              options: {
                apiKey: $key,
                baseURL: $base_url,
                resourceName: $resource
              },
              models: {
                ($deployment): {
                  name: $deployment
                }
              }
            }
          }
        }'
}

_opencode_azure_run() {
    emulate -L zsh
    _opencode_require_cli || return
    _opencode_require_jq || return

    local key="$1"
    local base_url="$2"
    local resource="$3"
    local default_deployment="$4"
    shift 4

    local model_arg deployment command config
    local -a opencode_args
    opencode_args=("$@")

    if _opencode_has_model_arg "$@"; then
        model_arg="$(_opencode_arg_model "$@")" || return
        deployment="$(_opencode_azure_deployment_from_model_arg "$model_arg")"
        [[ -n "$deployment" ]] || deployment="$default_deployment"
    else
        deployment="$default_deployment"
        command="$(_opencode_first_non_option_arg "${opencode_args[@]}")" || command=""
        if _opencode_command_accepts_model "$command"; then
            opencode_args=(--model "azure/${deployment}" "${opencode_args[@]}")
        fi
    fi

    config="$(_opencode_azure_config "$key" "$base_url" "$resource" "$deployment")" || return

    echo "Mode: OpenCode Azure OpenAI (${resource}/${deployment})"
    AZURE_RESOURCE_NAME="$resource" OPENCODE_CONFIG_CONTENT="$config" opencode "${opencode_args[@]}"
}

opencode-azure() {
    emulate -L zsh

    local key base_url resource model
    key="$(_opencode_azure_key_value)" || return
    base_url="$(_opencode_azure_base_url)" || return
    resource="$(_opencode_azure_resource)" || return
    model="$(_opencode_azure_model)" || return

    _opencode_azure_run "$key" "$base_url" "$resource" "$model" "$@"
}

opencode-azure-alt() {
    emulate -L zsh

    local key base_url resource model
    key="$(_opencode_azure_alt_key_value)" || return
    base_url="$(_opencode_azure_alt_base_url)" || return
    resource="$(_opencode_azure_alt_resource)" || return
    model="$(_opencode_azure_alt_model)" || return

    _opencode_azure_run "$key" "$base_url" "$resource" "$model" "$@"
}

opencode-azure-status() {
    emulate -L zsh

    local key_source base_url resource model
    key_source="$(_opencode_azure_key_source)" || return
    base_url="$(_opencode_azure_base_url)" || return
    resource="$(_opencode_azure_resource)" || return
    model="$(_opencode_azure_model)" || return

    echo "OpenCode Azure key source: ${key_source}"
    echo "OpenCode Azure resource: ${resource}"
    echo "OpenCode Azure base URL: ${base_url}"
    echo "OpenCode Azure model/deployment: ${model}"
    echo "OpenCode model arg: azure/${model}"
    echo "OpenCode config: OPENCODE_CONFIG_CONTENT runtime override"
}

opencode-azure-alt-status() {
    emulate -L zsh

    local key_source base_url resource resource_group model
    key_source="$(_opencode_azure_alt_key_source)" || return
    base_url="$(_opencode_azure_alt_base_url)" || return
    resource="$(_opencode_azure_alt_resource)" || return
    resource_group="$(_opencode_azure_alt_resource_group)" || return
    model="$(_opencode_azure_alt_model)" || return

    echo "OpenCode Azure alt key source: ${key_source}"
    echo "OpenCode Azure alt resource: ${resource_group}/${resource}"
    echo "OpenCode Azure alt base URL: ${base_url}"
    echo "OpenCode Azure alt model/deployment: ${model}"
    echo "OpenCode model arg: azure/${model}"
    echo "OpenCode config: OPENCODE_CONFIG_CONTENT runtime override"
}

opencode-azure-models() {
    emulate -L zsh

    local key base_url resource model config
    key="$(_opencode_azure_key_value)" || return
    base_url="$(_opencode_azure_base_url)" || return
    resource="$(_opencode_azure_resource)" || return
    model="$(_opencode_azure_model)" || return
    config="$(_opencode_azure_config "$key" "$base_url" "$resource" "$model")" || return

    AZURE_RESOURCE_NAME="$resource" OPENCODE_CONFIG_CONTENT="$config" opencode models azure "$@"
}

opencode-azure-alt-models() {
    emulate -L zsh

    local key base_url resource model config
    key="$(_opencode_azure_alt_key_value)" || return
    base_url="$(_opencode_azure_alt_base_url)" || return
    resource="$(_opencode_azure_alt_resource)" || return
    model="$(_opencode_azure_alt_model)" || return
    config="$(_opencode_azure_config "$key" "$base_url" "$resource" "$model")" || return

    AZURE_RESOURCE_NAME="$resource" OPENCODE_CONFIG_CONTENT="$config" opencode models azure "$@"
}

oc-azure() {
    opencode-azure "$@"
}

oc-azure-alt() {
    opencode-azure-alt "$@"
}
