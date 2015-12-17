require 'fileutils'
require 'yaml'
require 'open-uri'

home = ENV['HOME']
VIM_PLUG_URL = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
VIM_AUTOLOAD_DIRECTORY = "#{home}/.vim/autoload"
file_map = File.read("./file_map.yml")

files = YAML::load(file_map)
offset = File.expand_path('~').length
field_width = files.map { |hash| hash[:source].length }.max + offset + 1

desc "Link dotfiles"
task :link_dotfiles => [:setup_directories, :setup_vim, :clone_dependencies] do
  puts "Symlinked:"
  files.each do |hash|
    s = hash[:source]
    d = hash[:destination]

    source = File.expand_path(s)
    destination = File.expand_path(d)

    FileUtils.ln_sf source, destination

    source_name = source
    puts source_name.ljust(field_width, " ") + " -> " + destination
  end

  FileUtils.rm './UltiSnipsSnippets/UltiSnipsSnippets'
end

desc 'Setup directories'
task :setup_directories do
  mkdir_p "#{home}/.peco"
  mkdir_p "#{home}/.bundle"
  mkdir_p "#{home}/.config"
end

desc 'Setup Vim'
task :setup_vim do
  %w[
    undo
    spell
    colors
    bundle
    backup
    autoload
  ].each do |directory|
    mkdir_p "#{home}/.vim/#{directory}"
  end

  FileUtils.ln_sf "#{home}/.vim", "#{home}/.vim"
end

desc 'Download required projects'
task :clone_dependencies => [:setup_vim] do
  system("git clone git@github.com:zsh-users/antigen.git --depth 1 ~/antigen")
  system("git clone git@github.com:JikkuJose/themes.git --depth 1 ~/themes")
  system("git clone git@bitbucket.org:jikkujose/commands.git --depth 1 ~/commands")
  File.open("#{VIM_AUTOLOAD_DIRECTORY}/plug.vim", 'w') { |f| f.write open(VIM_PLUG_URL).read }
end

task default: :link_dotfiles
