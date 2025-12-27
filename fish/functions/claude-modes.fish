# Claude mode functions for fish

function _claude_clean_env
    set -e ANTHROPIC_API_KEY
    set -e ANTHROPIC_BASE_URL
    set -e ANTHROPIC_AUTH_TOKEN
    set -e CLAUDE_USE_SUBSCRIPTION
    set -e API_TIMEOUT_MS
    set -e CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC
    set -e ANTHROPIC_MODEL
    set -e ANTHROPIC_SMALL_FAST_MODEL
    set -e ANTHROPIC_DEFAULT_SONNET_MODEL
    set -e ANTHROPIC_DEFAULT_OPUS_MODEL
    set -e ANTHROPIC_DEFAULT_HAIKU_MODEL
end

function ccc
    _claude_clean_env
    echo "✓ Mode: Claude"
    claude $argv
end

function ccc-dangerous
    _claude_clean_env
    echo "✓ Mode: Claude in dangerous mode"
    claude --allow-dangerously-skip-permissions --dangerously-skip-permissions $argv
end

function c-zai
    _claude_clean_env
    echo "✓ Mode: Z.AI GLM 4.7"
    ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="GLM-4.7" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="GLM-4.7" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="GLM-4.7" \
    claude $argv
end

function c-zai-dangerous
    _claude_clean_env
    echo "✓ Mode: Z.AI GLM 4.7"
    ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="GLM-4.7" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="GLM-4.7" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="GLM-4.7" \
    claude --allow-dangerously-skip-permissions --dangerously-skip-permissions $argv
end

function c-minimax
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
    claude $argv
end

function c-moonshot
    _claude_clean_env
    echo "✓ Mode: Moonshot Kimi K2"
    ANTHROPIC_AUTH_TOKEN="$MOONSHOT_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.moonshot.ai/anthropic" \
    ANTHROPIC_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_SMALL_FAST_MODEL="kimi-k2-turbo-preview" \
    claude $argv
end
