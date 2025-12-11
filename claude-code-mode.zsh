{\rtf1\ansi\ansicpg1252\cocoartf2867
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww18880\viewh13720\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # ============================================================================\
# Claude Code Multi-Provider Configuration\
# ============================================================================\
# Add this to your ~/.zshrc or ~/.bash_profile\
# Usage: c-list to see all available commands\
# ============================================================================\
\
# === Helper Function to Clean Environment ===\
_claude_clean_env() \{\
    unset ANTHROPIC_API_KEY\
    unset ANTHROPIC_BASE_URL\
    unset ANTHROPIC_AUTH_TOKEN\
    unset CLAUDE_USE_SUBSCRIPTION\
    unset API_TIMEOUT_MS\
    unset CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC\
    unset ANTHROPIC_MODEL\
    unset ANTHROPIC_SMALL_FAST_MODEL\
    unset ANTHROPIC_DEFAULT_SONNET_MODEL\
    unset ANTHROPIC_DEFAULT_OPUS_MODEL\
    unset ANTHROPIC_DEFAULT_HAIKU_MODEL\
\}\
\
# === Helper Function to Show Current Mode ===\
_claude_show_mode() \{\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    echo "\uc0\u55358 \u56598  Claude Mode: $1"\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    [ -n "$2" ] && echo "   Model: $2"\
    [ -n "$3" ] && echo "   Base URL: $3"\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
\}\
\
# === Helper Function to Validate API Key ===\
_claude_check_key() \{\
    if [ -z "$1" ]; then\
        echo "\uc0\u10060  Error: API key not found for $2"\
        echo "   Please set \\$$3 environment variable"\
        echo ""\
        echo "\uc0\u55357 \u56481  Add this to your ~/.zshrc:"\
        echo "   export $3=\\"your-api-key-here\\""\
        return 1\
    fi\
    return 0\
\}\
\
# === Helper Function to Log Usage ===\
_claude_log_usage() \{\
    local log_file="$HOME/.claude_usage.log"\
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1 | $2" >> "$log_file"\
\}\
\
# ============================================================================\
# PROVIDER MODE FUNCTIONS\
# ============================================================================\
\
# Z.AI Mode (GLM 4.6)\
c-zai() \{\
    _claude_check_key "$ZAI_API_KEY" "Z.AI" "ZAI_API_KEY" || return 1\
    _claude_clean_env\
    _claude_show_mode "Z.AI GLM 4.6" "glm-4.6" "api.z.ai"\
    _claude_log_usage "Z.AI" "Session started"\
    \
    export ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY"\
    export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"\
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-air"\
    export ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.6"\
    export ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.6"\
    \
    claude "$@"\
\}\
\
# Z.AI Dangerous Mode (\uc0\u9888 \u65039  USE WITH EXTREME CAUTION)\
c-zai-dangerous() \{\
    _claude_check_key "$ZAI_API_KEY" "Z.AI" "ZAI_API_KEY" || return 1\
    _claude_clean_env\
    \
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    echo "\uc0\u9888 \u65039   DANGEROUS MODE ACTIVATED"\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    echo "   This mode skips ALL safety permissions!"\
    echo "   Files can be deleted without confirmation!"\
    echo "   Use only if you know what you're doing!"\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    \
    _claude_log_usage "Z.AI-DANGEROUS" "\uc0\u9888 \u65039  Dangerous mode started"\
    \
    export ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY"\
    export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"\
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-air"\
    export ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.6"\
    export ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.6"\
    \
    claude --allow-dangerously-skip-permissions --dangerously-skip-permissions "$@"\
\}\
\
# MiniMax Mode (M2)\
c-minimax() \{\
    _claude_check_key "$MINIMAX_API_KEY" "MiniMax" "MINIMAX_API_KEY" || return 1\
    _claude_clean_env\
    _claude_show_mode "MiniMax M2" "MiniMax-M2" "api.minimax.io"\
    _claude_log_usage "MiniMax" "Session started"\
    \
    export ANTHROPIC_AUTH_TOKEN="$MINIMAX_API_KEY"\
    export ANTHROPIC_BASE_URL="https://api.minimax.io/anthropic"\
    export API_TIMEOUT_MS="3000000"\
    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1\
    export ANTHROPIC_MODEL="MiniMax-M2"\
    export ANTHROPIC_SMALL_FAST_MODEL="MiniMax-M2"\
    export ANTHROPIC_DEFAULT_SONNET_MODEL="MiniMax-M2"\
    export ANTHROPIC_DEFAULT_OPUS_MODEL="MiniMax-M2"\
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="MiniMax-M2"\
    \
    claude "$@"\
\}\
\
# Moonshot Mode (Kimi K2)\
c-moonshot() \{\
    _claude_check_key "$MOONSHOT_API_KEY" "Moonshot" "MOONSHOT_API_KEY" || return 1\
    _claude_clean_env\
    _claude_show_mode "Moonshot Kimi K2" "kimi-k2-turbo-preview" "api.moonshot.ai"\
    _claude_log_usage "Moonshot" "Session started"\
    \
    export ANTHROPIC_AUTH_TOKEN="$MOONSHOT_API_KEY"\
    export ANTHROPIC_BASE_URL="https://api.moonshot.ai/anthropic"\
    export ANTHROPIC_MODEL="kimi-k2-turbo-preview"\
    export ANTHROPIC_SMALL_FAST_MODEL="kimi-k2-turbo-preview"\
    export ANTHROPIC_DEFAULT_SONNET_MODEL="kimi-k2-turbo-preview"\
    export ANTHROPIC_DEFAULT_OPUS_MODEL="kimi-k2-turbo-preview"\
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="kimi-k2-turbo-preview"\
    \
    claude "$@"\
\}\
\
# ============================================================================\
# UTILITY FUNCTIONS\
# ============================================================================\
\
# Show current Claude mode configuration\
c-mode() \{\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    echo "\uc0\u55357 \u56523  Current Claude Configuration"\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    echo "Base URL:     $\{ANTHROPIC_BASE_URL:-Not set (using default)\}"\
    echo "Model:        $\{ANTHROPIC_MODEL:-Not set\}"\
    echo "Sonnet Model: $\{ANTHROPIC_DEFAULT_SONNET_MODEL:-Not set\}"\
    echo "Opus Model:   $\{ANTHROPIC_DEFAULT_OPUS_MODEL:-Not set\}"\
    echo "Haiku Model:  $\{ANTHROPIC_DEFAULT_HAIKU_MODEL:-Not set\}"\
    echo "Timeout:      $\{API_TIMEOUT_MS:-Default\}"\
    \
    if [ -n "$ANTHROPIC_AUTH_TOKEN" ]; then\
        echo "API Key:      ***$\{ANTHROPIC_AUTH_TOKEN: -4\}"\
    else\
        echo "API Key:      Not set (using default)"\
    fi\
    \
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
\}\
\
# Reset to default Claude mode\
c-reset() \{\
    _claude_clean_env\
    echo "\uc0\u10003  Claude environment reset to default"\
    echo "  All custom configurations cleared"\
\}\
\
# List all available modes with status\
c-list() \{\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    echo "\uc0\u55357 \u56538  Available Claude Modes"\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    \
    # Z.AI\
    if [ -n "$ZAI_API_KEY" ]; then\
        echo "  \uc0\u10003  c-zai             Z.AI GLM 4.6 (Ready)"\
        echo "  \uc0\u10003  c-zai-dangerous   Z.AI GLM 4.6 \u9888 \u65039  Dangerous Mode"\
    else\
        echo "  \uc0\u10007  c-zai             Z.AI GLM 4.6 (No API key)"\
        echo "  \uc0\u10007  c-zai-dangerous   Z.AI GLM 4.6 (No API key)"\
    fi\
    \
    # MiniMax\
    if [ -n "$MINIMAX_API_KEY" ]; then\
        echo "  \uc0\u10003  c-minimax         MiniMax M2 (Ready)"\
    else\
        echo "  \uc0\u10007  c-minimax         MiniMax M2 (No API key)"\
    fi\
    \
    # Moonshot\
    if [ -n "$MOONSHOT_API_KEY" ]; then\
        echo "  \uc0\u10003  c-moonshot        Moonshot Kimi K2 (Ready)"\
    else\
        echo "  \uc0\u10007  c-moonshot        Moonshot Kimi K2 (No API key)"\
    fi\
    \
    echo ""\
    echo "\uc0\u55357 \u57056 \u65039   Utility Commands"\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    echo "  c-mode              Show current configuration"\
    echo "  c-reset             Reset to default Claude"\
    echo "  c-info <provider>   Show detailed provider info"\
    echo "  c-test <provider>   Test provider connection"\
    echo "  c-usage             Show usage logs"\
    echo "  c-list              Show this help"\
    echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
    echo ""\
    echo "\uc0\u55357 \u56481  Quick Start:"\
    echo "   1. Set API keys in ~/.zshrc (see c-info)"\
    echo "   2. Run 'c-zai' to use Z.AI provider"\
    echo "   3. Run 'c-mode' to verify configuration"\
\}\
\
# Show detailed information about a provider\
c-info() \{\
    case "$1" in\
        zai)\
            echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
            echo "\uc0\u55357 \u56536  Z.AI Provider Configuration"\
            echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
            echo "Provider:      Z.AI (\uc0\u26234 \u35889 AI)"\
            echo "Base URL:      https://api.z.ai/api/anthropic"\
            echo "Sonnet Model:  glm-4.6"\
            echo "Opus Model:    glm-4.6"\
            echo "Haiku Model:   glm-4.5-air"\
            echo ""\
            echo "API Key Status:"\
            if [ -n "$ZAI_API_KEY" ]; then\
                echo "  \uc0\u10003  Configured (***$\{ZAI_API_KEY: -4\})"\
            else\
                echo "  \uc0\u10007  Not configured"\
                echo ""\
                echo "Setup Instructions:"\
                echo "  1. Get API key from: https://api.z.ai"\
                echo "  2. Add to ~/.zshrc:"\
                echo "     export ZAI_API_KEY=\\"your-key-here\\""\
                echo "  3. Reload: source ~/.zshrc"\
            fi\
            echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
            ;;\
            \
        minimax)\
            echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
            echo "\uc0\u55357 \u56536  MiniMax Provider Configuration"\
            echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
            echo "Provider:      MiniMax"\
            echo "Base URL:      https://api.minimax.io/anthropic"\
            echo "Model:         MiniMax-M2"\
            echo "Timeout:       3000000ms (50 minutes)"\
            echo "Traffic Mode:  Non-essential disabled"\
            echo ""\
            echo "API Key Status:"\
            if [ -n "$MINIMAX_API_KEY" ]; then\
                echo "  \uc0\u10003  Configured (***$\{MINIMAX_API_KEY: -4\})"\
            else\
                echo "  \uc0\u10007  Not configured"\
                echo ""\
                echo "Setup Instructions:"\
                echo "  1. Get API key from: https://api.minimax.io"\
                echo "  2. Add to ~/.zshrc:"\
                echo "     export MINIMAX_API_KEY=\\"your-key-here\\""\
                echo "  3. Reload: source ~/.zshrc"\
            fi\
            echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
            ;;\
            \
        moonshot)\
            echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
            echo "\uc0\u55357 \u56536  Moonshot Provider Configuration"\
            echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
            echo "Provider:      Moonshot AI (\uc0\u26376 \u20043 \u26263 \u38754 )"\
            echo "Base URL:      https://api.moonshot.ai/anthropic"\
            echo "Model:         kimi-k2-turbo-preview"\
            echo ""\
            echo "API Key Status:"\
            if [ -n "$MOONSHOT_API_KEY" ]; then\
                echo "  \uc0\u10003  Configured (***$\{MOONSHOT_API_KEY: -4\})"\
            else\
                echo "  \uc0\u10007  Not configured"\
                echo ""\
                echo "Setup Instructions:"\
                echo "  1. Get API key from: https://platform.moonshot.cn"\
                echo "  2. Add to ~/.zshrc:"\
                echo "     export MOONSHOT_API_KEY=\\"your-key-here\\""\
                echo "  3. Reload: source ~/.zshrc"\
            fi\
            echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
            ;;\
            \
        *)\
            echo "Usage: c-info <provider>"\
            echo ""\
            echo "Available providers:"\
            echo "  zai      - Z.AI GLM 4.6"\
            echo "  minimax  - MiniMax M2"\
            echo "  moonshot - Moonshot Kimi K2"\
            ;;\
    esac\
\}\
\
# Test provider connection\
c-test() \{\
    case "$1" in\
        zai)\
            if [ -z "$ZAI_API_KEY" ]; then\
                echo "\uc0\u10060  ZAI_API_KEY not set"\
                return 1\
            fi\
            echo "\uc0\u55358 \u56810  Testing Z.AI connection..."\
            c-zai "echo 'Connection test successful!'"\
            ;;\
            \
        minimax)\
            if [ -z "$MINIMAX_API_KEY" ]; then\
                echo "\uc0\u10060  MINIMAX_API_KEY not set"\
                return 1\
            fi\
            echo "\uc0\u55358 \u56810  Testing MiniMax connection..."\
            c-minimax "echo 'Connection test successful!'"\
            ;;\
            \
        moonshot)\
            if [ -z "$MOONSHOT_API_KEY" ]; then\
                echo "\uc0\u10060  MOONSHOT_API_KEY not set"\
                return 1\
            fi\
            echo "\uc0\u55358 \u56810  Testing Moonshot connection..."\
            c-moonshot "echo 'Connection test successful!'"\
            ;;\
            \
        *)\
            echo "Usage: c-test <provider>"\
            echo ""\
            echo "Available providers: zai, minimax, moonshot"\
            ;;\
    esac\
\}\
\
# Show usage logs\
c-usage() \{\
    local log_file="$HOME/.claude_usage.log"\
    \
    if [ -f "$log_file" ]; then\
        echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
        echo "\uc0\u55357 \u56522  Claude Usage Log (Last 20 entries)"\
        echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
        tail -20 "$log_file"\
        echo "\uc0\u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 \u9473 "\
        echo "Full log: $log_file"\
    else\
        echo "No usage log found. Start using Claude modes to create logs."\
    fi\
\}}