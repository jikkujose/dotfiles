#!/usr/bin/env zsh

mkdir -p ~/.config
rm -rf ~/.config/nvim

ln -sf ~/dotfiles/zshrc.zsh ~/.zshrc
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/nvim/fresh ~/.config/nvim
ln -sf ~/dotfiles/tool-versions ~/.tool-versions

if [[ "$IS_CONTAINER" == "yes"* ]]; then
  ln -sf ~/dotfiles/starship/container.toml ~/.config/starship.toml
else
  ln -sf ~/dotfiles/starship/linux.toml ~/.config/starship.toml
fi
