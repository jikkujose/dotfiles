#!/usr/bin/env ruby
# Generate zsh and fish aliases from aliases.yml

require 'yaml'

DOTFILES = File.dirname(__FILE__)
CONFIG = YAML.load_file(File.join(DOTFILES, 'aliases.yml'))

# Escape for zsh double-quoted strings
def escape_zsh(cmd)
  cmd.to_s
     .gsub('\\', '\\\\\\\\')  # Escape backslashes first
     .gsub('"', '\\"')         # Escape double quotes
     .gsub('$', '\\$')         # Escape dollar signs
     .gsub('`', '\\\\`')       # Escape backticks
end

# Escape for fish single-quoted strings
def escape_fish(cmd)
  # Fish single quotes: only escape single quotes with \'
  cmd.to_s.gsub("'", "\\\\'")
end

def generate_zsh_aliases(aliases, file)
  return unless aliases
  aliases.each do |name, cmd|
    file.puts %(alias #{name}="#{escape_zsh(cmd)}")
  end
end

def generate_fish_aliases(aliases, file)
  return unless aliases
  aliases.each do |name, cmd|
    file.puts %(abbr -a #{name} '#{escape_fish(cmd)}')
  end
end

# Generate Zsh files
puts "Generating Zsh aliases..."

File.open(File.join(DOTFILES, 'generated', 'aliases.zsh'), 'w') do |f|
  f.puts "# Auto-generated from aliases.yml - do not edit directly"
  f.puts "# Run: ruby generate-aliases.rb"
  f.puts
  generate_zsh_aliases(CONFIG['shared'], f)
  f.puts
  f.puts "# Zsh-only"
  generate_zsh_aliases(CONFIG['zsh_only'], f)
end

File.open(File.join(DOTFILES, 'generated', 'aliases-linux.zsh'), 'w') do |f|
  f.puts "# Auto-generated Linux aliases"
  generate_zsh_aliases(CONFIG['linux'], f)
end

File.open(File.join(DOTFILES, 'generated', 'aliases-mac.zsh'), 'w') do |f|
  f.puts "# Auto-generated Mac aliases"
  generate_zsh_aliases(CONFIG['mac'], f)
end

File.open(File.join(DOTFILES, 'generated', 'aliases-wsl.zsh'), 'w') do |f|
  f.puts "# Auto-generated WSL aliases"
  generate_zsh_aliases(CONFIG['wsl'], f)
end

# Generate Fish files
puts "Generating Fish abbreviations..."

File.open(File.join(DOTFILES, 'generated', 'aliases.fish'), 'w') do |f|
  f.puts "# Auto-generated from aliases.yml - do not edit directly"
  f.puts "# Run: ruby generate-aliases.rb"
  f.puts
  generate_fish_aliases(CONFIG['shared'], f)
  f.puts
  f.puts "# Fish-only"
  generate_fish_aliases(CONFIG['fish_only'], f)
end

File.open(File.join(DOTFILES, 'generated', 'aliases-linux.fish'), 'w') do |f|
  f.puts "# Auto-generated Linux abbreviations"
  generate_fish_aliases(CONFIG['linux'], f)
end

File.open(File.join(DOTFILES, 'generated', 'aliases-mac.fish'), 'w') do |f|
  f.puts "# Auto-generated Mac abbreviations"
  generate_fish_aliases(CONFIG['mac'], f)
end

puts "Done! Generated files in #{File.join(DOTFILES, 'generated')}/"
puts
puts "To use:"
puts "  Zsh:  source ~/dotfiles/generated/aliases.zsh"
puts "  Fish: source ~/dotfiles/generated/aliases.fish"
