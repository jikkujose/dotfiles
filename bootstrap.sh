#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_REPO="https://github.com/jikkujose/dotfiles.git"
DOTFILES_BRANCH="v-2026"
DOTFILES_DIR="$HOME/dotfiles"

print_step() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}!${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

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
# MAC: Everything via Homebrew (maximum safety - no curl|bash)
# ============================================================================
install_mac() {
    print_step "Setting up Mac (brew only - no curl installs)..."

    # Install Homebrew if not present (this is the only curl, but it's unavoidable)
    if ! command -v brew &> /dev/null; then
        print_step "Installing Homebrew (required for all other installs)..."
        print_warning "This is the only curl|bash - Homebrew is the standard Mac package manager"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add brew to PATH for this session
        if [[ -d "/opt/homebrew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    print_step "Installing packages via brew..."

    # All packages in one brew install - all from official Homebrew repos
    brew install \
        git \
        zsh \
        fish \
        tmux \
        neovim \
        starship \
        mise \
        bat \
        ripgrep \
        the_silver_searcher \
        fd \
        httpie \
        tree \
        htop \
        openssl \
        readline \
        libyaml \
        gmp

    print_success "All packages installed via brew"
}

# ============================================================================
# LINUX: apt + curl installs (for VMs, less strict)
# ============================================================================
install_linux() {
    print_step "Setting up Linux..."

    sudo apt update

    # Core packages from apt (official Ubuntu repos)
    print_step "Installing apt packages..."
    sudo apt install -y \
        curl \
        git \
        zsh \
        fish \
        tmux \
        tree \
        htop \
        unzip \
        xclip \
        locales \
        bat \
        ripgrep \
        silversearcher-ag \
        fd-find \
        httpie \
        software-properties-common

    # Build dependencies for mise to compile Ruby/Python
    sudo apt install -y \
        build-essential \
        rustc \
        libssl-dev \
        libyaml-dev \
        libreadline-dev \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libsqlite3-dev \
        zlib1g-dev \
        libgmp-dev \
        tk-dev

    print_success "apt packages installed"

    # Neovim (AppImage - official GitHub release)
    print_step "Installing Neovim from GitHub releases..."
    NVIM_VERSION="v0.10.2"
    curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz"
    sudo rm -rf /opt/nvim-linux64
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    print_success "Neovim installed"

    # Starship (curl install)
    print_step "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    print_success "Starship installed"

    # mise (curl install)
    print_step "Installing mise..."
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
    print_success "mise installed"
}

# Clone dotfiles
clone_dotfiles() {
    print_step "Cloning dotfiles..."

    if [[ -d "$DOTFILES_DIR" ]]; then
        print_warning "Dotfiles directory exists, pulling latest..."
        cd "$DOTFILES_DIR"
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
    rm -f ~/.config/starship.toml

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

    # Starship config
    ln -sf "$DOTFILES_DIR/starship/linux.toml" ~/.config/starship.toml

    # tool-versions for mise
    ln -sf "$DOTFILES_DIR/tool-versions" ~/.tool-versions

    print_success "Symlinks created"
}

# Set default shell to zsh
set_default_shell() {
    print_step "Setting zsh as default shell..."

    ZSH_PATH=$(which zsh)

    # Add zsh to /etc/shells if not present (Linux only, Mac has it)
    if [[ "$OS" == "linux" ]] && ! grep -q "$ZSH_PATH" /etc/shells; then
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

# Install tmux plugin manager
install_tpm() {
    print_step "Installing tmux plugin manager..."

    TPM_DIR="$HOME/.tmux/plugins/tpm"
    if [[ ! -d "$TPM_DIR" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
        print_success "TPM installed (press prefix + I in tmux to install plugins)"
    else
        print_success "TPM already installed"
    fi
}

# Main
main() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     Dotfiles Bootstrap v-2026          ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""

    detect_os

    # OS-specific installation
    if [[ "$OS" == "mac" ]]; then
        install_mac
    else
        install_linux
    fi

    clone_dotfiles
    setup_symlinks
    install_tpm
    set_default_shell

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║           Setup Complete!              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Log out and log back in (or run: exec zsh)"
    echo "  2. In tmux, press \` + I to install plugins"
    echo "  3. Run 'mise install' to install Ruby/Node/Python"
    echo ""
    echo "To use fish instead: exec fish"
    echo "To make fish default: chsh -s \$(which fish)"
    echo ""
}

main "$@"
