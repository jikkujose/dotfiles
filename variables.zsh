COMPLETION_WAITING_DOTS="true"
DISABLE_AUTO_TITLE="true"
DISABLE_AUTO_UPDATE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
# Graphical sessions and SSH forwarding must supply their own DISPLAY value.
# A hard-coded display breaks headless tools and remote clipboard routing.
# Disable all history/state
HISTSIZE=0
SAVEHIST=0
unset HISTFILE
LESSHISTFILE="-"
PYTHON_HISTORY=" "
NODE_REPL_HISTORY=""
IRB_HISTFILE="/dev/null"
PRYRC="/dev/null"
KEYTIMEOUT=1
RUBYOPT=""

OLLAMA_HOST="0.0.0.0"
OLLAMA_BASE_URL="http://localhost:11434"
