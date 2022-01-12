require 'rubygems'
require 'ap'
require 'json'
require 'irbcp'
require 'open-uri'
require 'rainbow'

# Print methods local to an Object's class
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

# Aliases

#clear the screen
def clear
  system('clear')
end

alias :c :clear
alias q exit

