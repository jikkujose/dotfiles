# === Helper Function to Clean Environment ===
_claude_clean_env() {
    unset ANTHROPIC_API_KEY
    unset ANTHROPIC_BASE_URL
    unset ANTHROPIC_AUTH_TOKEN
    unset CLAUDE_USE_SUBSCRIPTION
    unset API_TIMEOUT_MS
    unset CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC
    unset ANTHROPIC_MODEL
    unset ANTHROPIC_SMALL_FAST_MODEL
    unset ANTHROPIC_DEFAULT_SONNET_MODEL
    unset ANTHROPIC_DEFAULT_OPUS_MODEL
    unset ANTHROPIC_DEFAULT_HAIKU_MODEL
}

# === Claude Mode Functions ===

ccc() {
    _claude_clean_env
    echo "✓ Mode: Claude"
    ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_API_KEY_SB" \
    claude "$@"
}

ccc-dangerous() {
    _claude_clean_env
    echo "✓ Mode: Claude in dangerous mode"
    ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_API_KEY_SB" \
    claude --allow-dangerously-skip-permissions --dangerously-skip-permissions "$@"
}

# Z.AI Mode (GLM 4.6)
c-zai() {
    _claude_clean_env
    echo "✓ Mode: Z.AI GLM 4.7"
    ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="GLM-4.7" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="GLM-4.7" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.7" \
    claude "$@"
}

c-zai-dangerous() {
    _claude_clean_env
    echo "✓ Mode: Z.AI GLM 4.6"
    ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-air" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.6" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.6" \
    claude --allow-dangerously-skip-permissions --dangerously-skip-permissions "$@"
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
    claude "$@"
}

# Moonshot Mode (Kimi K2)
c-moonshot() {
    _claude_clean_env
    echo "✓ Mode: Moonshot Kimi K2"
    ANTHROPIC_AUTH_TOKEN="$MOONSHOT_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.moonshot.ai/anthropic" \
    ANTHROPIC_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_SMALL_FAST_MODEL="kimi-k2-turbo-preview" \
    claude "$@"
}
