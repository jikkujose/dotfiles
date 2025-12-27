# Fish shell configuration
# v-2026: Cross-platform fish config

# Disable all history/state
set -g fish_history ""
set -gx LESSHISTFILE "-"
set -gx PYTHON_HISTORY " "
set -gx NODE_REPL_HISTORY ""
set -gx IRB_HISTFILE "/dev/null"
set -gx PRYRC "/dev/null"

set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
set -gx EDITOR nvim

# Paths
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.bun/bin $PATH
set -gx PATH $HOME/.local/share/mise/shims $PATH

# Vi mode
fish_vi_key_bindings

# Tab accepts autosuggestion, or completes if no suggestion
bind -M insert \t accept-autosuggestion or complete

# Source shared aliases/abbreviations
if test -f ~/dotfiles/generated/aliases.fish
    source ~/dotfiles/generated/aliases.fish
end

# OS-specific configuration
switch (uname)
    case Linux
        if test -f ~/dotfiles/generated/aliases-linux.fish
            source ~/dotfiles/generated/aliases-linux.fish
        end
        if test -f ~/dotfiles/fish/conf.d/linux.fish
            source ~/dotfiles/fish/conf.d/linux.fish
        end

        # Linux-specific paths
        set -gx PATH /opt/nvim-linux64/bin $PATH
        set -gx PATH /home/linuxbrew/.linuxbrew/bin $PATH

    case Darwin
        if test -f ~/dotfiles/generated/aliases-mac.fish
            source ~/dotfiles/generated/aliases-mac.fish
        end
        if test -f ~/dotfiles/fish/conf.d/mac.fish
            source ~/dotfiles/fish/conf.d/mac.fish
        end

        # Mac-specific paths
        set -gx PATH /opt/homebrew/bin $PATH
end

# Private config (API keys, etc)
if test -f ~/.private.fish
    source ~/.private.fish
end

# Claude mode functions
if test -f ~/dotfiles/fish/functions/claude-modes.fish
    source ~/dotfiles/fish/functions/claude-modes.fish
end

# Bun completions
if test -f $HOME/.bun/_bun.fish
    source $HOME/.bun/_bun.fish
end
