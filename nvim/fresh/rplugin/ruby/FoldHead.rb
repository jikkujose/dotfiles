Neovim.plugin do |plug|
  plug.autocmd(:BufEnter, pattern: "*.html") do |nvim|
    nvim.command('execute "normal! /<head>\\<CR>vatzf"')
  end
end
