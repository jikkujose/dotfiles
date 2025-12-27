#!/usr/bin/env zsh
# Install fish shell configuration

mkdir -p ~/.config/fish/functions
mkdir -p ~/.config/fish/conf.d

# Generate aliases from YAML
ruby ~/dotfiles/generate-aliases.rb

# Symlink fish config
ln -sf ~/dotfiles/fish/config.fish ~/.config/fish/config.fish

# Symlink fish functions
for f in ~/dotfiles/fish/functions/*.fish; do
  ln -sf "$f" ~/.config/fish/functions/
done

# Symlink conf.d files
for f in ~/dotfiles/fish/conf.d/*.fish; do
  ln -sf "$f" ~/.config/fish/conf.d/
done

echo "Fish configuration installed!"
echo "Run 'fish' to start using fish shell"
echo "Run 'chsh -s /usr/bin/fish' to make it your default shell"
