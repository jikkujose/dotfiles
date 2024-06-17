Neovim.plugin do |plug|
  plug.autocmd(:BufEnter, pattern: "*.html") do |nvim|
    head_line = nvim.evaluate('search("<head>", "nw")')

    if nvim.evaluate("foldclosed(#{head_line})") == -1
      nvim.command('execute "normal! /<head>\\<CR>vatzf"')
    end
  end
end
