# Mac-specific fish configuration

# Homebrew
if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
end

# asdf via homebrew
if type -q brew
    source (brew --prefix asdf)/libexec/asdf.fish 2>/dev/null
end

# z directory jumping
if type -q brew
    source (brew --prefix)/share/zsh-site-functions/_z 2>/dev/null
end
