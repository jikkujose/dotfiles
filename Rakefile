require 'fileutils'
require 'yaml'
require 'open-uri'

home = ENV['HOME']
VIM_PLUG_URL = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
VIM_AUTOLOAD_DIRECTORY = "#{home}/.vim/autoload"
DIRECTORY_REGEX = /\/(?<directory>\w+)(?:\.git)?$/
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
end

desc 'Download required projects'
task :clone_dependencies => [:setup_vim] do
  %w[
    git@github.com:zsh-users/antigen.git
    git@github.com:JikkuJose/themes.git
    git@bitbucket.org:jikkujose/commands.git
  ].each do |link|
    clone_git_project(link: link)
  end

  install_vim_plug
end

def clone_git_project(link:, directory: nil)
  if directory.nil?
    directory = "~/#{link.match(DIRECTORY_REGEX)[:directory]}"
  end

  system("git clone #{link} --depth 1 #{directory}")
end

def install_vim_plug
  plug_vim = "#{VIM_AUTOLOAD_DIRECTORY}/plug.vim"

  unless File.exist?(plug_vim)
    File.open(plug_vim, 'w') { |f| f.write open(VIM_PLUG_URL).read }
  end
end

task default: :link_dotfiles
