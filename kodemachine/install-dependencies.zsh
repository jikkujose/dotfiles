#!/bin/zsh
# install-dependencies.zsh
# Non-interactive dependency installer for kodemachine
# Run: zsh install-dependencies.zsh [--headless]

set -e

export DEBIAN_FRONTEND=noninteractive

echo "▶ kodemachine dependencies"

# ─────────────────────────────────────────────────────────────
# SYSTEM UPDATE
# ─────────────────────────────────────────────────────────────
echo "▶ apt update..."
sudo apt-get update -qq
sudo apt-get upgrade -y -qq

# ─────────────────────────────────────────────────────────────
# CORE PACKAGES
# ─────────────────────────────────────────────────────────────
echo "▶ core packages..."
sudo apt-get install -y -qq \
    zsh git curl wget unzip \
    build-essential cmake \
    libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libncursesw5-dev \
    xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev \
    podman podman-docker \
    tshark \
    spice-vdagent

# ─────────────────────────────────────────────────────────────
# CLI TOOLS
# ─────────────────────────────────────────────────────────────
echo "▶ cli tools..."
sudo apt-get install -y -qq \
    neovim vim \
    tmux \
    btop htop \
    bat \
    fd-find \
    ripgrep \
    silversearcher-ag \
    jq \
    httpie \
    tree \
    moreutils \
    strace \
    inotify-tools

# Symlink bat/fd (Ubuntu uses different names)
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true
ln -sf /usr/bin/fdfind ~/.local/bin/fd 2>/dev/null || true

# ─────────────────────────────────────────────────────────────
# GUI (skip if headless)
# ─────────────────────────────────────────────────────────────
if [[ "$1" != "--headless" ]]; then
    echo "▶ gui packages..."
    sudo apt-get install -y -qq \
        xfce4 xfce4-goodies xfce4-terminal \
        firefox chromium-browser

    # ─────────────────────────────────────────────────────────
    # NERD FONTS (CaskaydiaCove)
    # ─────────────────────────────────────────────────────────
    if [[ ! -d "$HOME/.local/share/fonts/CaskaydiaCove" ]]; then
        echo "▶ nerd fonts (CaskaydiaCove)..."
        mkdir -p ~/.local/share/fonts/CaskaydiaCove
        cd /tmp
        wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip
        unzip -q -o CascadiaCode.zip -d ~/.local/share/fonts/CaskaydiaCove
        rm CascadiaCode.zip
        fc-cache -f
        cd ~
    else
        echo "▶ nerd fonts (exists)"
    fi

    # ─────────────────────────────────────────────────────────
    # XFCE TERMINAL CONFIG
    # ─────────────────────────────────────────────────────────
    echo "▶ terminal config..."
    mkdir -p ~/.config/xfce4/terminal
    cat > ~/.config/xfce4/terminal/terminalrc << 'EOF'
[Configuration]
FontName=CaskaydiaCove Nerd Font 13
MiscAlwaysShowTabs=FALSE
MiscBell=FALSE
MiscBordersDefault=FALSE
MiscMenubarDefault=FALSE
ScrollingBar=TERMINAL_SCROLLBAR_NONE
ColorBackground=#0d1117
ColorForeground=#c9d1d9
ColorCursor=#58a6ff
ColorPalette=#484f58;#ff7b72;#3fb950;#d29922;#58a6ff;#bc8cff;#39c5cf;#b1bac4;#6e7681;#ffa198;#56d364;#e3b341;#79c0ff;#d2a8ff;#56d4dd;#f0f6fc
EOF

    # ─────────────────────────────────────────────────────────
    # GTK THEME (WhiteSur)
    # ─────────────────────────────────────────────────────────
    if [[ ! -d "$HOME/.themes/WhiteSur-Dark" ]]; then
        echo "▶ WhiteSur theme..."
        git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git \
            /tmp/whitesur-theme --depth=1 --quiet
        /tmp/whitesur-theme/install.sh -c Dark -s standard -N glassy \
            > /dev/null 2>&1
        rm -rf /tmp/whitesur-theme
    else
        echo "▶ WhiteSur theme (exists)"
    fi

    # ─────────────────────────────────────────────────────────
    # ICON THEME (WhiteSur)
    # ─────────────────────────────────────────────────────────
    if [[ ! -d "$HOME/.local/share/icons/WhiteSur" ]]; then
        echo "▶ WhiteSur icons..."
        git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git \
            /tmp/whitesur-icons --depth=1 --quiet
        /tmp/whitesur-icons/install.sh > /dev/null 2>&1
        rm -rf /tmp/whitesur-icons
    else
        echo "▶ WhiteSur icons (exists)"
    fi

    # ─────────────────────────────────────────────────────────
    # APPLY XFCE THEME (if xfconf available)
    # ─────────────────────────────────────────────────────────
    if command -v xfconf-query &> /dev/null; then
        echo "▶ applying theme..."
        xfconf-query -c xsettings -p /Net/ThemeName -s "WhiteSur-Dark" 2>/dev/null || true
        xfconf-query -c xsettings -p /Net/IconThemeName -s "WhiteSur" 2>/dev/null || true
    fi

else
    echo "▶ skipping gui (headless mode)"
fi

# ─────────────────────────────────────────────────────────────
# ASDF
# ─────────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.asdf" ]]; then
    echo "▶ asdf..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf \
        --branch v0.14.0 --quiet
fi

source "$HOME/.asdf/asdf.sh"

# Plugins (idempotent)
echo "▶ asdf plugins..."
asdf plugin add python  2>/dev/null || true
asdf plugin add nodejs  2>/dev/null || true
asdf plugin add ruby    2>/dev/null || true
asdf plugin add golang  2>/dev/null || true
asdf plugin add rust    2>/dev/null || true
asdf plugin add bun     2>/dev/null || true

# ─────────────────────────────────────────────────────────────
# RUNTIMES
# ─────────────────────────────────────────────────────────────
install_runtime() {
    local lang=$1 ver=$2
    if ! asdf list "$lang" 2>/dev/null | grep -q "$ver"; then
        echo "▶ $lang $ver..."
        asdf install "$lang" "$ver"
        asdf global "$lang" "$ver"
    else
        echo "▶ $lang $ver (exists)"
    fi
}

install_runtime python 3.12.4
install_runtime nodejs 22.11.0
install_runtime ruby   3.3.0
install_runtime golang 1.23.4
install_runtime rust   1.83.0
install_runtime bun    1.1.38

# Reshim after installs
asdf reshim

# ─────────────────────────────────────────────────────────────
# PLAYWRIGHT (browser automation)
# ─────────────────────────────────────────────────────────────
if ! command -v playwright &> /dev/null; then
    echo "▶ playwright..."
    npm install -g playwright@latest --silent --no-fund
    asdf reshim nodejs
    npx playwright install --with-deps chromium
else
    echo "▶ playwright (exists)"
fi

# ─────────────────────────────────────────────────────────────
# SSH KEY
# ─────────────────────────────────────────────────────────────
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
    echo "▶ generating ssh key..."
    mkdir -p ~/.ssh
    ssh-keygen -t ed25519 -C "kodeman@kodemachine" -N "" \
        -f ~/.ssh/id_ed25519 -q
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  ADD TO GITHUB:"
    cat ~/.ssh/id_ed25519.pub
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# ─────────────────────────────────────────────────────────────
# GIT CONFIG
# ─────────────────────────────────────────────────────────────
echo "▶ git config..."
git config --global init.defaultBranch main
git config --global core.editor nvim
git config --global pull.rebase true

# ─────────────────────────────────────────────────────────────
# SHELL DEFAULT
# ─────────────────────────────────────────────────────────────
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "▶ setting zsh as default..."
    sudo chsh -s "$(which zsh)" "$USER"
fi

# ─────────────────────────────────────────────────────────────
# ZSHENV (persistent PATH for all shells)
# ─────────────────────────────────────────────────────────────
echo "▶ zshenv..."
cat > ~/.zshenv << 'EOF'
# PATH
export PATH="$HOME/.local/bin:$HOME/.asdf/shims:$PATH"

# Editor
export EDITOR=nvim

# Playwright
export PLAYWRIGHT_BROWSERS_PATH="$HOME/.cache/ms-playwright"
EOF

# ─────────────────────────────────────────────────────────────
# DONE
# ─────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ dependencies installed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  runtimes:"
echo "    python: $(python --version 2>&1 | cut -d' ' -f2)"
echo "    node:   $(node --version 2>&1)"
echo "    ruby:   $(ruby --version 2>&1 | cut -d' ' -f2)"
echo "    go:     $(go version 2>&1 | cut -d' ' -f3)"
echo "    rust:   $(rustc --version 2>&1 | cut -d' ' -f2)"
echo "    bun:    $(bun --version 2>&1)"
echo ""
echo "  cli tools:"
echo "    bat, fd, rg, ag, jq, http, tree, btop"
echo ""
echo "  manual steps remaining:"
echo "    1. logout/login or: exec zsh"
echo "    2. unlock & mount encrypted drive"
echo "    3. link podman storage:"
echo "       mkdir -p ~/Projects/podman-storage"
echo "       rm -rf ~/.local/share/containers"
echo "       ln -s ~/Projects/podman-storage ~/.local/share/containers"
echo ""