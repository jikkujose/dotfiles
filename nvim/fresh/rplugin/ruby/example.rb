Neovim.plugin do |plug|
  plug.command(:SetLine, nargs: 1) do |nvim, str|
    nvim.current.line = str
  end

  plug.function(:Sum, nargs: 2, sync: true) do |nvim, x, y|
    x + y
  end

  plug.autocmd(:BufEnter, pattern: "*.rb") do |nvim|
    nvim.command("echom 'Ruby file, eh?'")
  end
end
