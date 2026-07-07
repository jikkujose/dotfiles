# === Claude Mode Helpers ===

_claude_clean_env() {
    unset ANTHROPIC_API_KEY
    unset ANTHROPIC_BASE_URL
    unset ANTHROPIC_AUTH_TOKEN
    unset CLAUDE_USE_SUBSCRIPTION
    unset API_TIMEOUT_MS
    unset CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC
    unset ANTHROPIC_MODEL
    unset ANTHROPIC_SMALL_FAST_MODEL
    unset ANTHROPIC_DEFAULT_FABLE_MODEL
    unset ANTHROPIC_DEFAULT_SONNET_MODEL
    unset ANTHROPIC_DEFAULT_OPUS_MODEL
    unset ANTHROPIC_DEFAULT_HAIKU_MODEL
    unset CLAUDE_CODE_AUTO_COMPACT_WINDOW
    unset CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY
    unset CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS
}

_claude_run() {
    local permissive=0
    if [[ "${1:-}" == "--permissive" ]]; then
        permissive=1
        shift
    fi

    if (( permissive )); then
        command claude --allow-dangerously-skip-permissions --dangerously-skip-permissions "$@"
    else
        command claude "$@"
    fi
}

_claude_deep_claude_bin() {
    if [[ -n "${DEEP_CLAUDE_BIN:-}" ]]; then
        print -r -- "$DEEP_CLAUDE_BIN"
        return 0
    fi

    local podman_bin="${DEEP_CLAUDE_HOME:-$HOME/Projects/deep-claude}/podman/deep-claude"
    if [[ -x "$podman_bin" ]]; then
        print -r -- "$podman_bin"
        return 0
    fi

    if command -v deep-claude >/dev/null 2>&1; then
        command -v deep-claude
        return 0
    fi

    echo "deep-claude: not found. Set DEEP_CLAUDE_HOME or DEEP_CLAUDE_BIN." >&2
    return 1
}

_claude_deep_run() {
    local permissive=0
    if [[ "${1:-}" == "--permissive" ]]; then
        permissive=1
        shift
    fi

    local deep_claude_bin
    deep_claude_bin="$(_claude_deep_claude_bin)" || return

    if (( permissive )); then
        "$deep_claude_bin" --allow-dangerously-skip-permissions --dangerously-skip-permissions "$@"
    else
        "$deep_claude_bin" "$@"
    fi
}

# === Claude Mode Functions ===

ccc() {
    _claude_clean_env
    echo "✓ Mode: Claude"
    _claude_run "$@"
}

ccc-dangerous() {
    _claude_clean_env
    echo "✓ Mode: Claude (permissive)"
    _claude_run --permissive "$@"
}

# Z.AI Mode (GLM mapped)
# Claude Code model mapping:
#   Haiku -> glm-4.7-flash
#   Sonnet -> glm-5-turbo
#   Opus -> glm-5.2[1m]
c-zai() {
    _claude_clean_env
    echo "✓ Mode: Z.AI GLM mapped"
    ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
    CLAUDE_CODE_AUTO_COMPACT_WINDOW="1000000" \
    ANTHROPIC_SMALL_FAST_MODEL="glm-4.7-flash" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.7-flash" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="glm-5-turbo" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="glm-5.2[1m]" \
    _claude_run "$@"
}

c-zai-dangerous() {
    _claude_clean_env
    echo "✓ Mode: Z.AI GLM mapped (permissive)"
    ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
    CLAUDE_CODE_AUTO_COMPACT_WINDOW="1000000" \
    ANTHROPIC_SMALL_FAST_MODEL="glm-4.7-flash" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.7-flash" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="glm-5-turbo" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="glm-5.2[1m]" \
    _claude_run --permissive "$@"
}

# MiniMax Mode (M2)
c-minimax() {
    _claude_clean_env
    echo "✓ Mode: MiniMax M2"
    ANTHROPIC_AUTH_TOKEN="$MINIMAX_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.minimax.io/anthropic" \
    API_TIMEOUT_MS="3000000" \
    CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
    ANTHROPIC_MODEL="MiniMax-M2" \
    ANTHROPIC_SMALL_FAST_MODEL="MiniMax-M2" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="MiniMax-M2" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="MiniMax-M2" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="MiniMax-M2" \
    _claude_run "$@"
}

c-minimax-dangerous() {
    _claude_clean_env
    echo "✓ Mode: MiniMax M2 (permissive)"
    ANTHROPIC_AUTH_TOKEN="$MINIMAX_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.minimax.io/anthropic" \
    API_TIMEOUT_MS="3000000" \
    CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
    ANTHROPIC_MODEL="MiniMax-M2" \
    ANTHROPIC_SMALL_FAST_MODEL="MiniMax-M2" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="MiniMax-M2" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="MiniMax-M2" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="MiniMax-M2" \
    _claude_run --permissive "$@"
}

# Moonshot Mode (Kimi K2)
c-moonshot() {
    _claude_clean_env
    echo "✓ Mode: Moonshot Kimi K2"
    ANTHROPIC_AUTH_TOKEN="$MOONSHOT_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.moonshot.ai/anthropic" \
    ANTHROPIC_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_SMALL_FAST_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="kimi-k2-turbo-preview" \
    _claude_run "$@"
}

c-moonshot-dangerous() {
    _claude_clean_env
    echo "✓ Mode: Moonshot Kimi K2 (permissive)"
    ANTHROPIC_AUTH_TOKEN="$MOONSHOT_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.moonshot.ai/anthropic" \
    ANTHROPIC_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_SMALL_FAST_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="kimi-k2-turbo-preview" \
    _claude_run --permissive "$@"
}

# OpenRouter via deep-claude (prefers the Podman wrapper in ~/Projects/deep-claude)
c-openrouter() {
    _claude_clean_env
    echo "✓ Mode: OpenRouter (deep-claude)"
    _claude_deep_run "$@"
}

c-openrouter-dangerous() {
    _claude_clean_env
    echo "✓ Mode: OpenRouter (deep-claude, permissive)"
    _claude_deep_run --permissive "$@"
}

c-or() {
    c-openrouter "$@"
}

c-or-dangerous() {
    c-openrouter-dangerous "$@"
}

# OpenRouter free-only quick modes. The deep-claude .env should keep
# ROUTER_STRICT=1 and only currently-free entries in ROUTER_MODELS.
c-free() {
    _claude_clean_env
    echo "✓ Mode: OpenRouter free default (deep-claude)"
    _claude_deep_run --model free "$@"
}

c-free-dangerous() {
    _claude_clean_env
    echo "✓ Mode: OpenRouter free default (deep-claude, permissive)"
    _claude_deep_run --permissive --model free "$@"
}

c-owl() {
    _claude_clean_env
    echo "✓ Mode: OpenRouter Owl Alpha free (deep-claude)"
    _claude_deep_run --model owl "$@"
}

c-owl-dangerous() {
    _claude_clean_env
    echo "✓ Mode: OpenRouter Owl Alpha free (deep-claude, permissive)"
    _claude_deep_run --permissive --model owl "$@"
}
