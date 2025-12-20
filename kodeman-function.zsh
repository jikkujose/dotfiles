#!/bin/zsh
# Kodeman - Easy access function for the kodeman sandbox
#
# Installation:
#   Add this to your ~/.zshrc or dotfiles:
#     source ~/Projects/testman/sandboxes/kodeman/kodeman-function.zsh
#
# Usage:
#   kodeman <workspace-path> [OPTIONS]
#   kodeman .                    # Use current directory
#   kodeman ~/Projects/myapp     # Use specific directory
#   kodeman ~/Projects/myapp --audit
#   kodeman ~/Projects/myapp --map-ports 3000,9090

kodeman() {
  local TESTMAN_ROOT="${HOME}/Projects/testman"
  local KODEMAN_SCRIPT="${TESTMAN_ROOT}/sandboxes/kodeman/run.zsh"

  # Check if script exists
  if [[ ! -f "$KODEMAN_SCRIPT" ]]; then
    echo "Error: kodeman script not found at $KODEMAN_SCRIPT" >&2
    return 1
  fi

  # Check if at least one argument is provided
  if [[ $# -eq 0 ]]; then
    echo "Usage: kodeman <workspace-path> [OPTIONS]" >&2
    echo "" >&2
    echo "Examples:" >&2
    echo "  kodeman .                                         # Use current directory" >&2
    echo "  kodeman ~/Projects/myapp                          # Use specific directory" >&2
    echo "  kodeman ~/Projects/myapp --audit                  # With auditing" >&2
    echo "  kodeman ~/Projects/myapp --map-ports 3000,9090    # With port mapping" >&2
    echo "  kodeman ~/Projects/myapp --include-agents claude,gemini,aider  # Select agents" >&2
    echo "  kodeman ~/Projects/myapp --exclude-agents amp,forge             # Exclude agents" >&2
    echo "" >&2
    echo "Run 'kodeman --help' for full documentation" >&2
    return 1
  fi

  # Handle help flag
  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    "$KODEMAN_SCRIPT" --help
    return $?
  fi

  # First argument is the workspace path
  local workspace="$1"
  shift

  # Call the kodeman script with --workspace and --private flags
  KODEMAN_DEFAULT_AGENTS="${KODEMAN_DEFAULT_AGENTS:-}" "$KODEMAN_SCRIPT" --workspace "$workspace" --private "$@"
}

# Completion function for zsh
_kodeman() {
  local -a options
  options=(
    '--name:Project name'
    '--persist:Preserve config across runs'
    '--audit:Enable syscall auditing'
    '--map-ports:Mirror ports (comma-separated)'
    '--include-agents:Install only these agents (comma-separated)'
    '--exclude-agents:Skip these agents (comma-separated)'
    '--help:Show help message'
  )

  if [[ $CURRENT -eq 2 ]]; then
    # First argument: offer directory completion
    _files -/
  else
    # Subsequent arguments: offer options
    _describe 'kodeman options' options
  fi
}

compdef _kodeman kodeman
