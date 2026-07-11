# === Pi Mode Functions ===
# Self-contained dotfiles copy: do not source project checkout files here.
# Secrets stay outside dotfiles. Add this to ~/.private.zsh, export it in your
# shell, or put a plain assignment in ${PI_ZYT_ENV_FILE:-$HOME/.foundry-zyt.env}:
#   FOUNDRY_API_KEY=fnd_<12-char-key-id>_<secret>
#
# Optional overrides:
#   PI_ZYT_ENV_FILE=/path/to/env-file
#   PI_ZYT_BASE_URL=https://foundry.zyt.app/v1
#   PI_ZYT_MODEL=gpt-5.6-sol
#   PI_ZYT_THINKING=max
#   PI_ZYT_MODELS=foundry-zyt/gpt-5.6-*
#   PI_ZYT_TOOLS=read,bash,edit,write,grep,find,ls

_pi_zyt_require_cli() {
  if ! command -v pi >/dev/null 2>&1; then
    print -u2 "pi-zyt: pi command not found."
    return 1
  fi
}

_pi_zyt_provider() {
  print -r -- "${PI_ZYT_PROVIDER:-foundry-zyt}"
}

_pi_zyt_base_url() {
  print -r -- "${PI_ZYT_BASE_URL:-${FOUNDRY_BASE_URL:-https://foundry.zyt.app/v1}}"
}

_pi_zyt_env_file() {
  print -r -- "${PI_ZYT_ENV_FILE:-$HOME/.foundry-zyt.env}"
}

_pi_zyt_load_env() {
  [[ -n "${FOUNDRY_API_KEY:-}" ]] && return 0

  local env_file line value
  env_file="$(_pi_zyt_env_file)" || return
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

_pi_zyt_model() {
  print -r -- "${PI_ZYT_MODEL:-gpt-5.6-sol}"
}

_pi_zyt_thinking() {
  print -r -- "${PI_ZYT_THINKING:-max}"
}

_pi_zyt_tools() {
  print -r -- "${PI_ZYT_TOOLS:-read,bash,edit,write,grep,find,ls}"
}

_pi_zyt_model_scope() {
  print -r -- "${PI_ZYT_MODELS:-$(_pi_zyt_provider)/gpt-5.6-*}"
}

_pi_zyt_models_json() {
  print -r -- "${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/models.json"
}

_pi_zyt_require_key() {
  _pi_zyt_load_env

  if [[ -z "${FOUNDRY_API_KEY:-}" ]]; then
    print -u2 "pi-zyt: set FOUNDRY_API_KEY first, for example in ~/.private.zsh or $(_pi_zyt_env_file):"
    print -u2 "  FOUNDRY_API_KEY=fnd_<12-char-key-id>_<secret>"
    return 1
  fi
}

_pi_zyt_ensure_provider() {
  emulate -L zsh

  local agent_dir models_json provider base_url
  agent_dir="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
  models_json="$agent_dir/models.json"
  provider="$(_pi_zyt_provider)" || return
  base_url="$(_pi_zyt_base_url)" || return

  mkdir -p "$agent_dir" || return 1

  PI_ZYT_MODELS_JSON="$models_json" \
  PI_ZYT_PROVIDER_VALUE="$provider" \
  PI_ZYT_BASE_URL_VALUE="$base_url" \
    node <<'NODE'
const fs = require('fs')
const path = require('path')

const file = process.env.PI_ZYT_MODELS_JSON
const providerName = process.env.PI_ZYT_PROVIDER_VALUE || 'foundry-zyt'
const baseUrl = process.env.PI_ZYT_BASE_URL_VALUE || 'https://foundry.zyt.app/v1'
const dir = path.dirname(file)

let data = { providers: {} }
try {
  if (fs.existsSync(file)) data = JSON.parse(fs.readFileSync(file, 'utf8'))
} catch (err) {
  throw new Error(`${file} is not valid JSON: ${err.message}`)
}
if (!data || typeof data !== 'object' || Array.isArray(data)) data = { providers: {} }
if (!data.providers || typeof data.providers !== 'object' || Array.isArray(data.providers)) data.providers = {}

const models = [
  { id: 'gpt-4.1', reasoning: false, contextWindow: 1048576, maxTokens: 32768 },
  { id: 'gpt-4.1-mini', reasoning: false, contextWindow: 1048576, maxTokens: 32768 },
  { id: 'gpt-4.1-nano', reasoning: false, contextWindow: 1048576, maxTokens: 32768 },
  { id: 'gpt-4o', reasoning: false, contextWindow: 128000, maxTokens: 16384 },
  { id: 'gpt-4o-mini', reasoning: false, contextWindow: 128000, maxTokens: 16384 },
  { id: 'gpt-chat-latest', reasoning: false, contextWindow: 128000, maxTokens: 16384 },

  { id: 'gpt-5', reasoning: true, contextWindow: 400000, maxTokens: 32768 },
  { id: 'gpt-5-mini', reasoning: true, contextWindow: 400000, maxTokens: 32768 },
  { id: 'gpt-5-nano', reasoning: true, contextWindow: 400000, maxTokens: 32768 },
  { id: 'gpt-5-pro', reasoning: true, contextWindow: 400000, maxTokens: 32768 },
  { id: 'gpt-5-codex', reasoning: true, contextWindow: 400000, maxTokens: 32768 },

  { id: 'gpt-5.1', reasoning: true, contextWindow: 400000, maxTokens: 32768 },
  { id: 'gpt-5.1-codex', reasoning: true, contextWindow: 400000, maxTokens: 32768 },
  { id: 'gpt-5.1-codex-max', reasoning: true, contextWindow: 400000, maxTokens: 32768 },
  { id: 'gpt-5.1-codex-mini', reasoning: true, contextWindow: 400000, maxTokens: 32768 },

  { id: 'gpt-5.2', reasoning: true, contextWindow: 400000, maxTokens: 32768 },
  { id: 'gpt-5.2-codex', reasoning: true, contextWindow: 400000, maxTokens: 32768 },

  { id: 'gpt-5.3-chat', reasoning: false, contextWindow: 128000, maxTokens: 16384 },
  { id: 'gpt-5.3-codex', reasoning: true, contextWindow: 400000, maxTokens: 32768 },

  { id: 'gpt-5.4', reasoning: true, contextWindow: 1048576, maxTokens: 32768 },
  { id: 'gpt-5.4-mini', reasoning: true, contextWindow: 400000, maxTokens: 32768 },
  { id: 'gpt-5.4-nano', reasoning: true, contextWindow: 400000, maxTokens: 32768 },
  { id: 'gpt-5.4-pro', reasoning: true, contextWindow: 1048576, maxTokens: 32768 },

  { id: 'gpt-5.5', reasoning: true, contextWindow: 1048576, maxTokens: 32768 },

  { id: 'gpt-5.6-luna', reasoning: true, input: ['text', 'image'], contextWindow: 1050000, maxTokens: 128000 },
  { id: 'gpt-5.6-sol', reasoning: true, input: ['text', 'image'], contextWindow: 1050000, maxTokens: 128000 },
  { id: 'gpt-5.6-terra', reasoning: true, input: ['text', 'image'], contextWindow: 1050000, maxTokens: 128000 }
]

const costs = {
  'gpt-4.1': { input: 2, output: 8, cacheRead: 0.5, cacheWrite: 0 },
  'gpt-4.1-mini': { input: 0.4, output: 1.6, cacheRead: 0.1, cacheWrite: 0 },
  'gpt-4.1-nano': { input: 0.1, output: 0.4, cacheRead: 0.025, cacheWrite: 0 },
  'gpt-4o': { input: 2.5, output: 10, cacheRead: 1.25, cacheWrite: 0 },
  'gpt-4o-mini': { input: 0.15, output: 0.6, cacheRead: 0.075, cacheWrite: 0 },
  'gpt-5': { input: 1.25, output: 10, cacheRead: 0.125, cacheWrite: 0 },
  'gpt-5-mini': { input: 0.25, output: 2, cacheRead: 0.025, cacheWrite: 0 },
  'gpt-5-nano': { input: 0.05, output: 0.4, cacheRead: 0.005, cacheWrite: 0 },
  'gpt-5-pro': { input: 15, output: 120, cacheRead: 0, cacheWrite: 0 },
  'gpt-5-codex': { input: 1.25, output: 10, cacheRead: 0.125, cacheWrite: 0 },
  'gpt-5.1': { input: 1.25, output: 10, cacheRead: 0.125, cacheWrite: 0 },
  'gpt-5.1-codex': { input: 1.25, output: 10, cacheRead: 0.125, cacheWrite: 0 },
  'gpt-5.1-codex-max': { input: 1.25, output: 10, cacheRead: 0.125, cacheWrite: 0 },
  'gpt-5.1-codex-mini': { input: 0.25, output: 2, cacheRead: 0.025, cacheWrite: 0 },
  'gpt-5.2': { input: 1.75, output: 14, cacheRead: 0.175, cacheWrite: 0 },
  'gpt-5.2-codex': { input: 1.75, output: 14, cacheRead: 0.175, cacheWrite: 0 },
  'gpt-5.3-chat': { input: 5, output: 30, cacheRead: 0.5, cacheWrite: 0 },
  'gpt-5.3-codex': { input: 1.75, output: 14, cacheRead: 0.175, cacheWrite: 0 },
  'gpt-5.4': { input: 2.5, output: 15, cacheRead: 0.25, cacheWrite: 0 },
  'gpt-5.4-mini': { input: 0.75, output: 4.5, cacheRead: 0.075, cacheWrite: 0 },
  'gpt-5.4-nano': { input: 0.2, output: 1.25, cacheRead: 0.02, cacheWrite: 0 },
  'gpt-5.4-pro': { input: 30, output: 180, cacheRead: 0, cacheWrite: 0 },
  'gpt-5.5': { input: 5, output: 30, cacheRead: 0.5, cacheWrite: 0 },
  'gpt-5.6-luna': { input: 1, output: 6, cacheRead: 0.1, cacheWrite: 1.25 },
  'gpt-5.6-sol': { input: 5, output: 30, cacheRead: 0.5, cacheWrite: 6.25 },
  'gpt-5.6-terra': { input: 2.5, output: 15, cacheRead: 0.25, cacheWrite: 3.125 },
  'gpt-chat-latest': { input: 5, output: 30, cacheRead: 0.5, cacheWrite: 0 }
}
const thinkingLevelMaps = {
  // Pi only exposes/sends xhigh when a model explicitly maps that level.
  // Mirror Pi/OpenAI model metadata for Foundry aliases so gpt-5.5:xhigh
  // reaches the Responses API as reasoning.effort = "xhigh" instead of
  // being clamped to high locally.
  'gpt-5': { off: null },
  'gpt-5-mini': { off: null },
  'gpt-5-nano': { off: null },
  'gpt-5-pro': { off: null },
  'gpt-5-codex': { off: null },
  'gpt-5.1': { off: 'none' },
  'gpt-5.1-codex': { off: null },
  'gpt-5.1-codex-max': { off: null },
  'gpt-5.1-codex-mini': { off: null },
  'gpt-5.2': { off: 'none', xhigh: 'xhigh' },
  'gpt-5.2-codex': { off: null, xhigh: 'xhigh' },
  'gpt-5.3-codex': { off: 'none', xhigh: 'xhigh' },
  'gpt-5.4': { off: 'none', xhigh: 'xhigh' },
  'gpt-5.4-mini': { off: 'none', xhigh: 'xhigh' },
  'gpt-5.4-nano': { off: 'none', xhigh: 'xhigh' },
  'gpt-5.4-pro': { off: null, xhigh: 'xhigh' },
  'gpt-5.5': { off: 'none', xhigh: 'xhigh', minimal: null },
  'gpt-5.6-luna': { off: null, xhigh: 'xhigh', max: 'max' },
  'gpt-5.6-sol': { off: null, xhigh: 'xhigh', max: 'max' },
  'gpt-5.6-terra': { off: null, xhigh: 'xhigh', max: 'max' }
}

for (const model of models) {
  if (costs[model.id]) model.cost = costs[model.id]
  if (thinkingLevelMaps[model.id]) model.thinkingLevelMap = thinkingLevelMaps[model.id]
}

const provider = {
  name: 'Foundry ZYT (Responses)',
  baseUrl,
  api: 'openai-responses',
  apiKey: '$FOUNDRY_API_KEY',
  models
}

if (JSON.stringify(data.providers[providerName]) !== JSON.stringify(provider)) {
  fs.mkdirSync(dir, { recursive: true })
  if (fs.existsSync(file) && !fs.existsSync(`${file}.pi-zyt.bak`)) {
    fs.copyFileSync(file, `${file}.pi-zyt.bak`)
  }
  data.providers[providerName] = provider
  fs.writeFileSync(file, `${JSON.stringify(data, null, 2)}\n`)
}
NODE
}

pi-zyt-status() {
  emulate -L zsh

  _pi_zyt_load_env

  local key_state="missing"
  [[ -n "${FOUNDRY_API_KEY:-}" ]] && key_state="set"

  print -r -- "provider=$(_pi_zyt_provider)"
  print -r -- "base_url=$(_pi_zyt_base_url)"
  print -r -- "model=$(_pi_zyt_model)"
  print -r -- "thinking=$(_pi_zyt_thinking)"
  print -r -- "model_scope=$(_pi_zyt_model_scope)"
  print -r -- "tools=$(_pi_zyt_tools)"
  print -r -- "api_key=$key_state (FOUNDRY_API_KEY)"
  print -r -- "env_file=$(_pi_zyt_env_file)"
  print -r -- "models_json=$(_pi_zyt_models_json)"
}

pi-zyt-models() {
  emulate -L zsh

  _pi_zyt_require_cli || return
  _pi_zyt_require_key || return
  _pi_zyt_ensure_provider || return

  local search="$(_pi_zyt_provider)"
  if (( $# > 0 )); then
    search="${search} $*"
  fi

  FOUNDRY_API_KEY="$FOUNDRY_API_KEY" \
    command pi --list-models "$search"
}

pi-zyt-smoke() {
  emulate -L zsh

  _pi_zyt_require_cli || return
  _pi_zyt_require_key || return
  _pi_zyt_ensure_provider || return

  FOUNDRY_API_KEY="$FOUNDRY_API_KEY" \
    command pi \
      --provider "$(_pi_zyt_provider)" \
      --model "$(_pi_zyt_model)" \
      --thinking "$(_pi_zyt_thinking)" \
      --no-context-files \
      --no-tools \
      --no-session \
      --print "Reply with exactly: pi-zyt ok"
}

pi-zyt() {
  emulate -L zsh

  _pi_zyt_require_cli || return
  _pi_zyt_require_key || return
  _pi_zyt_ensure_provider || return

  local provider model thinking tools model_scope
  provider="$(_pi_zyt_provider)" || return
  model="$(_pi_zyt_model)" || return
  thinking="$(_pi_zyt_thinking)" || return
  tools="$(_pi_zyt_tools)" || return
  model_scope="$(_pi_zyt_model_scope)" || return

  local has_provider=0
  local has_model=0
  local has_thinking=0
  local has_tools=0
  local has_models=0
  local has_approval=0
  local arg next display_provider display_model display_thinking
  display_provider="$provider"
  display_model="$model"
  display_thinking="$thinking"

  local i
  for (( i = 1; i <= $#; i++ )); do
    arg="${argv[i]}"
    next="${argv[i+1]:-}"
    case "$arg" in
      --provider) has_provider=1; [[ -n "$next" ]] && display_provider="$next" ;;
      --provider=*) has_provider=1; display_provider="${arg#--provider=}" ;;
      --model) has_model=1; [[ -n "$next" ]] && display_model="$next" ;;
      --model=*) has_model=1; display_model="${arg#--model=}" ;;
      --thinking) has_thinking=1; [[ -n "$next" ]] && display_thinking="$next" ;;
      --thinking=*) has_thinking=1; display_thinking="${arg#--thinking=}" ;;
      --models|--models=*) has_models=1 ;;
      --tools|-t|--tools=*|-t=*) has_tools=1 ;;
      --no-tools|-nt|--no-builtin-tools|-nbt) has_tools=1 ;;
      --approve|-a|--no-approve|-na) has_approval=1 ;;
    esac
  done

  local -a prefix
  prefix=()
  (( has_provider == 0 )) && prefix+=(--provider "$provider")
  (( has_model == 0 )) && prefix+=(--model "$model")
  if (( has_thinking == 0 )) && [[ "$model" != *:* ]]; then
    prefix+=(--thinking "$thinking")
  fi
  if (( has_models == 0 )) && [[ -n "$model_scope" && "$model_scope" != "default" ]]; then
    prefix+=(--models "$model_scope")
  fi
  if (( has_tools == 0 )) && [[ -n "$tools" && "$tools" != "default" ]]; then
    prefix+=(--tools "$tools")
  fi
  (( has_approval == 0 )) && prefix+=(--approve)

  local model_display="$display_model"
  [[ "$model_display" != *:* ]] && model_display="${model_display}:${display_thinking}"
  print -r -- "Mode: Pi via Foundry ZYT (${display_provider}, ${model_display}, $(_pi_zyt_base_url))"

  PI_MODE_LABEL=pi-zyt \
  FOUNDRY_API_KEY="$FOUNDRY_API_KEY" \
    command pi "${prefix[@]}" "$@"
}

# === Pi OpenRouter Mode ===
# Uses PI_OR_API_KEY internally because ~/commands/pi intentionally scrubs
# OPENROUTER_API_KEY before launching pi.
#
# Secrets stay outside dotfiles. Export OPENROUTER_API_KEY/PI_OR_API_KEY in your
# shell, or put a plain assignment in ${PI_OR_ENV_FILE:-$HOME/.openrouter.env}:
#   OPENROUTER_API_KEY=sk-or-v1-...
#
# Optional overrides:
#   PI_OR_ENV_FILE=/path/to/env-file
#   PI_OR_PROVIDER=openrouter-free
#   PI_OR_BASE_URL=https://openrouter.ai/api/v1
#   PI_OR_MODEL=tencent/hy3:free
#   PI_OR_THINKING=off
#   PI_OR_TOOLS=read,bash,edit,write,grep,find,ls

_pi_or_require_cli() {
  if ! command -v pi >/dev/null 2>&1; then
    print -u2 "pi-or: pi command not found."
    return 1
  fi
}

_pi_or_provider() {
  print -r -- "${PI_OR_PROVIDER:-openrouter-free}"
}

_pi_or_base_url() {
  print -r -- "${PI_OR_BASE_URL:-https://openrouter.ai/api/v1}"
}

_pi_or_env_file() {
  print -r -- "${PI_OR_ENV_FILE:-$HOME/.openrouter.env}"
}

_pi_or_load_env() {
  [[ -n "${PI_OR_API_KEY:-}" ]] && return 0

  if [[ -n "${OPENROUTER_API_KEY:-}" ]]; then
    export PI_OR_API_KEY="$OPENROUTER_API_KEY"
    return 0
  fi

  local env_file line value
  env_file="$(_pi_or_env_file)" || return
  [[ -f "$env_file" ]] || return 0

  line="$(command grep -m 1 '^PI_OR_API_KEY=' "$env_file" 2>/dev/null)"
  if [[ -z "$line" ]]; then
    line="$(command grep -m 1 '^OPENROUTER_API_KEY=' "$env_file" 2>/dev/null)"
  fi
  [[ -n "$line" ]] || return 0

  value="${line#PI_OR_API_KEY=}"
  value="${value#OPENROUTER_API_KEY=}"
  value="${value%$'\r'}"
  value="${value#\"}"
  value="${value%\"}"
  value="${value#\'}"
  value="${value%\'}"

  [[ -n "$value" ]] && export PI_OR_API_KEY="$value"
}

_pi_or_model() {
  print -r -- "${PI_OR_MODEL:-tencent/hy3:free}"
}

_pi_or_thinking() {
  print -r -- "${PI_OR_THINKING:-off}"
}

_pi_or_tools() {
  print -r -- "${PI_OR_TOOLS:-read,bash,edit,write,grep,find,ls}"
}

_pi_or_models_json() {
  print -r -- "${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/models.json"
}

_pi_or_require_key() {
  _pi_or_load_env

  if [[ -z "${PI_OR_API_KEY:-}" ]]; then
    print -u2 "pi-or: set OPENROUTER_API_KEY or PI_OR_API_KEY first, for example in ~/.private.zsh or $(_pi_or_env_file):"
    print -u2 "  OPENROUTER_API_KEY=sk-or-v1-..."
    return 1
  fi
}

_pi_or_ensure_provider() {
  emulate -L zsh

  local agent_dir models_json provider base_url
  agent_dir="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
  models_json="$agent_dir/models.json"
  provider="$(_pi_or_provider)" || return
  base_url="$(_pi_or_base_url)" || return

  mkdir -p "$agent_dir" || return 1

  PI_OR_MODELS_JSON="$models_json" \
  PI_OR_PROVIDER_VALUE="$provider" \
  PI_OR_BASE_URL_VALUE="$base_url" \
    node <<'NODE'
const fs = require('fs')
const path = require('path')

const file = process.env.PI_OR_MODELS_JSON
const providerName = process.env.PI_OR_PROVIDER_VALUE || 'openrouter-free'
const baseUrl = process.env.PI_OR_BASE_URL_VALUE || 'https://openrouter.ai/api/v1'
const dir = path.dirname(file)

let data = { providers: {} }
try {
  if (fs.existsSync(file)) data = JSON.parse(fs.readFileSync(file, 'utf8'))
} catch (err) {
  throw new Error(`${file} is not valid JSON: ${err.message}`)
}
if (!data || typeof data !== 'object' || Array.isArray(data)) data = { providers: {} }
if (!data.providers || typeof data.providers !== 'object' || Array.isArray(data.providers)) data.providers = {}

const provider = {
  name: 'OpenRouter Free (Chat Completions)',
  baseUrl,
  api: 'openai-completions',
  apiKey: '$PI_OR_API_KEY',
  headers: {
    'HTTP-Referer': 'https://github.com/earendil-works/pi-coding-agent',
    'X-Title': 'pi-openrouter-free'
  },
  compat: {
    supportsDeveloperRole: false,
    maxTokensField: 'max_tokens',
    thinkingFormat: 'openrouter',
    openRouterRouting: {
      max_price: { prompt: 0, completion: 0 }
    }
  },
  models: [
    {
      id: 'tencent/hy3:free',
      name: 'Tencent Hy3 Free (OpenRouter)',
      reasoning: true,
      input: ['text'],
      contextWindow: 262144,
      maxTokens: 262144,
      cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
      thinkingLevelMap: { xhigh: null }
    }
  ]
}

if (JSON.stringify(data.providers[providerName]) !== JSON.stringify(provider)) {
  fs.mkdirSync(dir, { recursive: true })
  if (fs.existsSync(file) && !fs.existsSync(`${file}.pi-or.bak`)) {
    fs.copyFileSync(file, `${file}.pi-or.bak`)
  }
  data.providers[providerName] = provider
  fs.writeFileSync(file, `${JSON.stringify(data, null, 2)}\n`)
}
NODE
}

pi-or-status() {
  emulate -L zsh

  _pi_or_load_env

  local key_state="missing"
  [[ -n "${PI_OR_API_KEY:-}" ]] && key_state="set"

  print -r -- "provider=$(_pi_or_provider)"
  print -r -- "base_url=$(_pi_or_base_url)"
  print -r -- "model=$(_pi_or_model)"
  print -r -- "thinking=$(_pi_or_thinking)"
  print -r -- "tools=$(_pi_or_tools)"
  print -r -- "api_key=$key_state (OPENROUTER_API_KEY -> PI_OR_API_KEY)"
  print -r -- "env_file=$(_pi_or_env_file)"
  print -r -- "models_json=$(_pi_or_models_json)"
}

pi-or-models() {
  emulate -L zsh

  _pi_or_require_cli || return
  _pi_or_require_key || return
  _pi_or_ensure_provider || return

  local search="$(_pi_or_provider)"
  if (( $# > 0 )); then
    search="${search} $*"
  fi

  PI_OR_API_KEY="$PI_OR_API_KEY" \
    command pi --list-models "$search"
}

pi-or-smoke() {
  emulate -L zsh

  _pi_or_require_cli || return
  _pi_or_require_key || return
  _pi_or_ensure_provider || return

  PI_OR_API_KEY="$PI_OR_API_KEY" \
    command pi \
      --provider "$(_pi_or_provider)" \
      --model "$(_pi_or_model)" \
      --thinking "$(_pi_or_thinking)" \
      --no-context-files \
      --no-tools \
      --no-session \
      --print "Reply with exactly: pi-or ok"
}

pi-or() {
  emulate -L zsh

  _pi_or_require_cli || return
  _pi_or_require_key || return
  _pi_or_ensure_provider || return

  local provider model thinking tools
  provider="$(_pi_or_provider)" || return
  model="$(_pi_or_model)" || return
  thinking="$(_pi_or_thinking)" || return
  tools="$(_pi_or_tools)" || return

  local -a list_search
  local list_models=0
  local i=1
  while (( i <= $# )); do
    case "${argv[i]}" in
      --list-models)
        list_models=1
        list_search=("${argv[@]:$((i + 1))}")
        break
        ;;
      --list-models=*)
        list_models=1
        list_search=("${argv[i]#--list-models=}")
        break
        ;;
    esac
    (( i++ ))
  done
  if (( list_models )); then
    pi-or-models "${list_search[@]}"
    return
  fi

  local has_provider=0
  local has_model=0
  local has_thinking=0
  local has_tools=0
  local has_approval=0
  local arg

  for arg in "$@"; do
    case "$arg" in
      --provider|--provider=*) has_provider=1 ;;
      --model|--model=*) has_model=1 ;;
      --thinking|--thinking=*) has_thinking=1 ;;
      --tools|-t|--tools=*|-t=*) has_tools=1 ;;
      --no-tools|-nt|--no-builtin-tools|-nbt) has_tools=1 ;;
      --approve|-a|--no-approve|-na) has_approval=1 ;;
    esac
  done

  local -a prefix
  prefix=()
  (( has_provider == 0 )) && prefix+=(--provider "$provider")
  (( has_model == 0 )) && prefix+=(--model "$model")
  if (( has_thinking == 0 )) && [[ -n "$thinking" && "$thinking" != "default" ]]; then
    prefix+=(--thinking "$thinking")
  fi
  if (( has_tools == 0 )) && [[ -n "$tools" && "$tools" != "default" ]]; then
    prefix+=(--tools "$tools")
  fi
  (( has_approval == 0 )) && prefix+=(--approve)

  local model_display="$model"
  [[ -n "$thinking" && "$thinking" != "default" ]] && model_display="${model_display} (thinking=${thinking})"
  print -r -- "Mode: Pi via OpenRouter (${provider}, ${model_display}, $(_pi_or_base_url))"

  PI_MODE_LABEL=pi-or \
  PI_OR_API_KEY="$PI_OR_API_KEY" \
    command pi "${prefix[@]}" "$@"
}
