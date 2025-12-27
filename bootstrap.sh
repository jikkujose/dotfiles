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

# Install packages on Linux
install_linux_packages() {
    print_step "Installing packages via apt..."

    sudo apt update

    # Core packages (always installed)
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
        locales

    # Build dependencies (required for mise to compile Ruby/Python)
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

    # Nice-to-have tools
    sudo apt install -y \
        bat \
        ripgrep \
        silversearcher-ag \
        fd-find \
        httpie \
        software-properties-common

    print_success "Packages installed"
}

# Install packages on Mac
install_mac_packages() {
    print_step "Installing packages via Homebrew..."

    # Install Homebrew if not present
    if ! command -v brew &> /dev/null; then
        print_step "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add brew to PATH for this session
        if [[ -d "/opt/homebrew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    # Core packages
    brew install \
        curl \
        git \
        zsh \
        fish \
        tmux \
        tree \
        htop \
        unzip

    # Build dependencies
    brew install \
        openssl \
        readline \
        libyaml \
        gmp \
        rust

    # Nice-to-have tools
    brew install \
        bat \
        ripgrep \
        the_silver_searcher \
        fd \
        httpie

    print_success "Packages installed"
}

# Install Neovim
install_neovim() {
    print_step "Installing Neovim..."

    if [[ "$OS" == "linux" ]]; then
        # Use AppImage for latest version
        NVIM_VERSION="v0.10.2"
        curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz"
        sudo rm -rf /opt/nvim-linux64
        sudo tar -C /opt -xzf nvim-linux64.tar.gz
        rm nvim-linux64.tar.gz
        sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    else
        brew install neovim
    fi

    print_success "Neovim installed"
}

# Install Starship prompt
install_starship() {
    print_step "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    print_success "Starship installed"
}

# Install mise (runtime version manager)
install_mise() {
    print_step "Installing mise..."
    curl https://mise.run | sh

    # Add mise to current shell
    export PATH="$HOME/.local/bin:$PATH"
    eval "$(~/.local/bin/mise activate bash)"

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

    # Backup existing configs
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

    # Starship
    if [[ "$OS" == "linux" ]]; then
        ln -sf "$DOTFILES_DIR/starship/linux.toml" ~/.config/starship.toml
    else
        ln -sf "$DOTFILES_DIR/starship/mac.toml" ~/.config/starship.toml 2>/dev/null || \
        ln -sf "$DOTFILES_DIR/starship/linux.toml" ~/.config/starship.toml
    fi

    # tool-versions for mise
    ln -sf "$DOTFILES_DIR/tool-versions" ~/.tool-versions

    print_success "Symlinks created"
}

# Set default shell to zsh
set_default_shell() {
    print_step "Setting zsh as default shell..."

    ZSH_PATH=$(which zsh)

    # Add zsh to /etc/shells if not present
    if ! grep -q "$ZSH_PATH" /etc/shells; then
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

    if [[ "$OS" == "linux" ]]; then
        install_linux_packages
    else
        install_mac_packages
    fi

    clone_dotfiles
    install_neovim
    install_starship
    install_mise
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
