#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

DOTFILES_REPO="https://github.com/jikkujose/dotfiles.git"
DOTFILES_BRANCH="v-2026"
DOTFILES_DIR="$HOME/dotfiles"
DRY_RUN=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            echo "Usage: bootstrap.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -n, --dry-run    Show what would be done without making changes"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
    esac
done

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
        fish \
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
# Linux-specific extras (xclip, etc. not in Homebrew)
# ============================================================================
install_linux_extras() {
    print_step "Installing Linux-specific packages via apt..."

    sudo apt install -y \
        xclip \
        locales

    print_success "Linux extras installed"
}

# Clone dotfiles
clone_dotfiles() {
    print_step "Cloning dotfiles..."

    if [[ -d "$DOTFILES_DIR" ]]; then
        print_warning "Dotfiles directory exists, checking status..."
        cd "$DOTFILES_DIR"

        # Check for uncommitted changes
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            print_error "Uncommitted changes detected in $DOTFILES_DIR"
            echo ""
            echo "Please commit or stash your changes first:"
            echo "  cd $DOTFILES_DIR"
            echo "  git status"
            echo "  git stash      # to temporarily save changes"
            echo "  git commit -am 'Save changes'  # to commit"
            echo ""
            echo "Then re-run this bootstrap script."
            exit 1
        fi

        git fetch origin
        git checkout "$DOTFILES_BRANCH"
        git pull origin "$DOTFILES_BRANCH"
        cd -
    else
        git clone -b "$DOTFILES_BRANCH" "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi

    print_success "Dotfiles ready at $DOTFILES_DIR"
}

# Setup symlinks
setup_symlinks() {
    print_step "Setting up symlinks..."

    mkdir -p ~/.config
    mkdir -p ~/.config/fish/functions
    mkdir -p ~/.config/fish/conf.d

    # Backup existing configs (only real files, not symlinks)
    for file in ~/.zshrc ~/.config/nvim ~/.tmux.conf ~/.config/fish/config.fish; do
        if [[ -e "$file" && ! -L "$file" ]]; then
            mv "$file" "${file}.backup.$(date +%s)"
            print_warning "Backed up existing $file"
        fi
    done

    # Remove existing symlinks
    rm -rf ~/.config/nvim
    rm -f ~/.zshrc
    rm -f ~/.tmux.conf
    rm -f ~/.config/fish/config.fish

    # Zsh
    ln -sf "$DOTFILES_DIR/zshrc.zsh" ~/.zshrc

    # Tmux
    ln -sf "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf

    # Neovim
    ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim

    # Fish
    ln -sf "$DOTFILES_DIR/fish/config.fish" ~/.config/fish/config.fish
    for f in "$DOTFILES_DIR"/fish/functions/*.fish; do
        ln -sf "$f" ~/.config/fish/functions/
    done
    for f in "$DOTFILES_DIR"/fish/conf.d/*.fish; do
        ln -sf "$f" ~/.config/fish/conf.d/
    done

    # tool-versions for mise
    ln -sf "$DOTFILES_DIR/tool-versions" ~/.tool-versions

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

# Install Ruby via mise and generate aliases
install_ruby_and_generate() {
    print_step "Installing Ruby via mise (precompiled binaries)..."

    # Enable precompiled binaries (much faster than compiling from source)
    export MISE_EXPERIMENTAL=1

    # Activate mise for this session
    eval "$(mise activate bash)"

    # Install Ruby (reads version from tool-versions)
    mise install ruby

    # Generate aliases for zsh and fish
    cd "$DOTFILES_DIR"
    ruby generate-aliases.rb
    cd -

    print_success "Ruby installed and aliases generated"
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
        print_dry "brew install git zsh fish tmux neovim mise bat ripgrep..."

        if [[ "$OS" == "linux" ]]; then
            print_dry "sudo apt install xclip locales"
        fi

        if [[ -d "$DOTFILES_DIR" ]]; then
            print_dry "cd $DOTFILES_DIR && git checkout $DOTFILES_BRANCH && git pull"
        else
            print_dry "git clone -b $DOTFILES_BRANCH $DOTFILES_REPO $DOTFILES_DIR"
        fi

        print_dry "mise install ruby && ruby generate-aliases.rb"

        echo ""
        print_step "Would create symlinks:"
        print_dry "~/.zshrc -> $DOTFILES_DIR/zshrc.zsh"
        print_dry "~/.tmux.conf -> $DOTFILES_DIR/tmux.conf"
        print_dry "~/.config/nvim -> $DOTFILES_DIR/nvim"
        print_dry "~/.config/fish/config.fish -> $DOTFILES_DIR/fish/config.fish"

        echo ""
        print_dry "chsh -s $(which zsh)"

        echo ""
        print_success "Dry run complete. Run without -n to execute."
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

    clone_dotfiles
    install_ruby_and_generate
    setup_symlinks
    set_default_shell

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║           Setup Complete!              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Log out and log back in (or run: exec zsh)"
    echo "  2. Run 'mise install' to install Node/Python (Ruby already installed)"
    echo ""
    echo "To use fish instead: exec fish"
    echo "To make fish default: chsh -s \$(which fish)"
    echo ""
}

main "$@"
