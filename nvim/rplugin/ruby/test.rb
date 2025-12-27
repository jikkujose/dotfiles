# :UpdateRemotePlugins needs to be run after every edit

Neovim.plugin do |plug|
  plug.command(:ReplaceWithRuby, nargs: 0, range: "%", sync: true) do |nvim|
    # Get the starting and ending positions of the current visual selection
    start_pos = nvim.eval("getpos(\"'<\")")
    end_pos = nvim.eval("getpos(\"'>\")")

    # Extract line and column positions
    start_line, start_col = start_pos[1] - 1, start_pos[2] - 1
    end_line, end_col = end_pos[1] - 1, end_pos[2]

    # Create a buffer and replace the selected text
    buffer = nvim.get_current_buf
    if start_line == end_line
      # If the selection is within a single line
      line_content = buffer.get_lines(start_line, start_line + 1, true).first
      new_content = line_content[0...start_col] + "__RUBY__" + line_content[end_col..-1]
      buffer.set_lines(start_line, start_line + 1, true, [new_content])
    else
      # If the selection spans multiple lines
      lines = buffer.get_lines(start_line, end_line + 1, true)
      # Modify the first and last lines of the selection
      lines[0] = lines[0][0...start_col] + "__RUBY__"
      lines[-1] = "" + lines[-1][end_col..-1]
      buffer.set_lines(start_line, end_line + 1, true, lines)
    end
  end

  plug.autocmd(:VimEnter, pattern: "*") do |nvim|
    nvim.command("vnoremap <C-t> :'<,'>ReplaceWithRuby<CR>")
  end
end
