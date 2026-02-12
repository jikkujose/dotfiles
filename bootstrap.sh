#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Detect dotfiles directory from script location
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false

show_help() {
    echo ""
    echo -e "${BLUE}Dotfiles Bootstrap${NC}"
    echo "Sets up zsh, tmux, neovim via Homebrew. Idempotent & safe to re-run."
    echo "Review the code first: less bootstrap.sh"
    echo ""
    echo -e "${YELLOW}Usage:${NC} ./bootstrap.sh <command>"
    echo ""
    echo -e "${YELLOW}Commands:${NC}"
    echo "  dry-run    Preview changes (recommended first)"
    echo "  start      Run the bootstrap"
    echo ""
    echo -e "${YELLOW}Requires:${NC} sudo, internet"
    echo ""
}

# Parse command
case "${1:-}" in
    start)
        DRY_RUN=false
        ;;
    dry-run)
        DRY_RUN=true
        ;;
    help|-h|--help)
        show_help
        exit 0
        ;;
    *)
        show_help
        exit 0
        ;;
esac

print_step() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}!${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_dry() { echo -e "${GRAY}[dry-run]${NC} $1"; }

# Run command or show what would run
run() {
    if [[ "$DRY_RUN" == true ]]; then
        print_dry "$*"
    else
        "$@"
    fi
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)  OS="linux";;
        Darwin*) OS="mac";;
        *)       print_error "Unsupported OS"; exit 1;;
    esac
    print_success "Detected OS: $OS"
}

# ============================================================================
# Install Homebrew (works on both Mac and Linux)
# ============================================================================
install_homebrew() {
    if command -v brew &> /dev/null; then
        print_success "Homebrew already installed"
        return
    fi

    print_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for this session
    if [[ "$OS" == "mac" ]]; then
        if [[ -d "/opt/homebrew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed"
}

# ============================================================================
# Install build dependencies (Linux only - needed before Linuxbrew)
# ============================================================================
install_linux_build_deps() {
    print_step "Installing build dependencies via apt..."

    sudo apt update
    sudo apt install -y \
        build-essential \
        curl \
        file \
        git \
        procps

    print_success "Build dependencies installed"
}

# ============================================================================
# Install packages via Homebrew (same for Mac and Linux)
# ============================================================================
install_packages() {
    print_step "Installing packages via brew..."

    # Core packages - all from official Homebrew repos
    brew install \
        git \
        zsh \
        tmux \
        neovim \
        mise \
        bat \
        ripgrep \
        the_silver_searcher \
        fd \
        httpie \
        tree \
        htop

    # Build dependencies for mise to compile Ruby/Python
    brew install \
        openssl \
        readline \
        libyaml \
        gmp

    print_success "All packages installed via brew"
}

# ============================================================================
# Linux-specific extras (xclip, alacritty, etc. not in Homebrew)
# ============================================================================
install_linux_extras() {
    print_step "Installing Linux-specific packages via apt..."

    sudo apt install -y \
        xclip \
        locales \
        alacritty

    print_success "Linux extras installed"
}

# ============================================================================
# Install Nerd Font (Caskaydia Cove)
# ============================================================================
install_font() {
    print_step "Installing Nerd Font (Caskaydia Cove)..."

    if [[ "$OS" == "mac" ]]; then
        # macOS: Install via Homebrew cask
        if ls ~/Library/Fonts/CaskaydiaCove* &>/dev/null; then
            print_success "Nerd Font already installed"
            return
        fi
        brew install --cask font-caskaydia-cove-nerd-font
    else
        # Linux: Download and install to local fonts
        FONT_DIR="$HOME/.local/share/fonts"
        FONT_NAME="CaskaydiaCove"

        if ls "$FONT_DIR"/$FONT_NAME* &>/dev/null; then
            print_success "Nerd Font already installed"
            return
        fi

        mkdir -p "$FONT_DIR"
        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
        TEMP_ZIP="/tmp/nerd-font.zip"

        curl -fsSL "$FONT_URL" -o "$TEMP_ZIP"
        unzip -o "$TEMP_ZIP" -d "$FONT_DIR" '*.ttf'
        rm "$TEMP_ZIP"

        # Rebuild font cache
        fc-cache -fv &>/dev/null || true
    fi

    print_success "Nerd Font installed"
}

# ============================================================================
# Setup iTerm2 preferences (macOS only)
# ============================================================================
setup_iterm2() {
    if [[ "$OS" != "mac" ]]; then
        return
    fi

    print_step "Setting up iTerm2 preferences..."

    ITERM_PLIST="$DOTFILES_DIR/iterm2/com.googlecode.iterm2.plist"

    if [[ ! -f "$ITERM_PLIST" ]]; then
        print_warning "iTerm2 plist not found, skipping"
        return
    fi

    # Import preferences
    defaults import com.googlecode.iterm2 "$ITERM_PLIST"

    print_success "iTerm2 preferences loaded"
}

# Verify dotfiles directory
verify_dotfiles() {
    print_step "Verifying dotfiles at $DOTFILES_DIR..."

    # Check required files exist
    if [[ ! -f "$DOTFILES_DIR/zshrc.zsh" ]]; then
        print_error "Not a valid dotfiles directory: $DOTFILES_DIR"
        echo "Run this script from the cloned dotfiles repository."
        exit 1
    fi

    # Check for uncommitted changes
    if [[ -d "$DOTFILES_DIR/.git" ]] && [[ -n $(git -C "$DOTFILES_DIR" status --porcelain 2>/dev/null) ]]; then
        print_warning "Uncommitted changes detected in $DOTFILES_DIR"
        echo "Consider committing or stashing before bootstrap."
    fi

    print_success "Dotfiles verified at $DOTFILES_DIR"
}

# Install nvim plugins via vim-plug
install_nvim_plugins() {
    print_step "Installing nvim plugins..."

    # Install vim-plug if not present
    PLUG_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
    if [[ ! -f "$PLUG_FILE" ]]; then
        curl -fLo "$PLUG_FILE" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    # Install plugins headlessly
    nvim --headless +PlugInstall +qall 2>/dev/null

    print_success "nvim plugins installed"
}

# Setup symlinks
setup_symlinks() {
    print_step "Setting up symlinks..."

    mkdir -p ~/.config
    mkdir -p ~/.config/alacritty

    # Backup existing configs (only real files, not symlinks)
    for file in ~/.zshrc ~/.config/nvim ~/.tmux.conf; do
        if [[ -e "$file" && ! -L "$file" ]]; then
            mv "$file" "${file}.backup.$(date +%s)"
            print_warning "Backed up existing $file"
        fi
    done

    # Remove existing symlinks
    rm -rf ~/.config/nvim
    rm -f ~/.zshrc
    rm -f ~/.tmux.conf

    # Zsh
    ln -sf "$DOTFILES_DIR/zshrc.zsh" ~/.zshrc

    # Tmux
    ln -sf "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf

    # Neovim
    ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim

    # tool-versions for mise
    ln -sf "$DOTFILES_DIR/tool-versions" ~/.tool-versions

    # Alacritty
    ln -sf "$DOTFILES_DIR/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml

    print_success "Symlinks created"
}

# Set default shell to zsh
set_default_shell() {
    print_step "Setting zsh as default shell..."

    # Use brew's zsh
    if [[ "$OS" == "mac" ]]; then
        ZSH_PATH="/opt/homebrew/bin/zsh"
        [[ ! -f "$ZSH_PATH" ]] && ZSH_PATH="/usr/local/bin/zsh"
    else
        ZSH_PATH="/home/linuxbrew/.linuxbrew/bin/zsh"
    fi

    # Fallback to system zsh
    [[ ! -f "$ZSH_PATH" ]] && ZSH_PATH=$(which zsh)

    # Add zsh to /etc/shells if not present
    if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi

    # Change default shell
    if [[ "$SHELL" != "$ZSH_PATH" ]]; then
        chsh -s "$ZSH_PATH"
        print_success "Default shell set to zsh (will take effect on next login)"
    else
        print_success "zsh is already the default shell"
    fi
}

# Main
main() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     Dotfiles Bootstrap v-2026          ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}║           DRY RUN MODE                 ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    fi
    echo ""

    detect_os

    if [[ "$DRY_RUN" == true ]]; then
        echo ""
        print_step "Would perform the following actions:"
        echo ""

        if [[ "$OS" == "linux" ]]; then
            print_dry "sudo apt install build-essential curl git..."
        fi

        if command -v brew &> /dev/null; then
            print_dry "brew install (skip - already installed)"
        else
            print_dry "Install Homebrew from https://brew.sh"
        fi
        print_dry "brew install git zsh tmux neovim mise bat ripgrep..."

        if [[ "$OS" == "linux" ]]; then
            print_dry "sudo apt install xclip locales alacritty"
        fi

        print_dry "Verify dotfiles at $DOTFILES_DIR"
        print_dry "nvim --headless +PlugInstall +qall"

        echo ""
        print_step "Would create symlinks:"
        print_dry "~/.zshrc -> $DOTFILES_DIR/zshrc.zsh"
        print_dry "~/.tmux.conf -> $DOTFILES_DIR/tmux.conf"
        print_dry "~/.config/nvim -> $DOTFILES_DIR/nvim"
        print_dry "~/.config/alacritty/alacritty.toml -> $DOTFILES_DIR/alacritty/alacritty.toml"

        echo ""
        print_step "Would install extras:"
        if [[ "$OS" == "mac" ]]; then
            print_dry "brew install --cask font-caskaydia-cove-nerd-font"
            print_dry "defaults import com.googlecode.iterm2 (load preferences)"
        else
            print_dry "Download Nerd Font to ~/.local/share/fonts"
        fi

        echo ""
        print_dry "chsh -s $(which zsh)"
        echo ""
        return
    fi

    # Linux needs build deps before Homebrew
    if [[ "$OS" == "linux" ]]; then
        install_linux_build_deps
    fi

    # Homebrew for both platforms
    install_homebrew
    install_packages

    # Linux extras not in Homebrew
    if [[ "$OS" == "linux" ]]; then
        install_linux_extras
    fi

    verify_dotfiles
    setup_symlinks
    install_nvim_plugins
    install_font
    setup_iterm2
    set_default_shell

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║           Setup Complete!              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Log out and log back in (or run: exec zsh)"
    echo "  2. Run 'mise install' to install Node/Python"
    echo ""
}

main "$@"
