#!/usr/bin/env ruby
# Generate zsh and fish aliases from aliases.yml

require 'yaml'

DOTFILES = File.dirname(__FILE__)
CONFIG = YAML.load_file(File.join(DOTFILES, 'aliases.yml'))

def escape_for_shell(cmd)
  # Don't double-escape already quoted strings
  cmd.to_s
end

def generate_zsh_aliases(aliases, file)
  aliases.each do |name, cmd|
    file.puts %(alias #{name}="#{escape_for_shell(cmd)}")
  end
end

def generate_fish_aliases(aliases, file)
  aliases.each do |name, cmd|
    # Fish uses abbr for better UX (expands inline) or alias
    file.puts %(abbr -a #{name} '#{escape_for_shell(cmd)}')
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
