Neovim.plugin do |plug|
  plug.command(:EvalRuby, range: true) do |nvim, range_start, range_end|
    # If no range is explicitly selected, default to the current line
    current_line = nvim.eval('line(".")') # Get current line number
    range_start ||= current_line
    range_end ||= current_line

    buffer = nvim.get_current_buf
    ruby_code = buffer.get_lines(range_start - 1, range_end, false).join("\n")

    result = begin
        eval ruby_code
      rescue => e
        "! #{e.message} (#{e.class})"
      end

    # Append the result to the last line of the range
    last_line_content = buffer.get_lines(range_end - 1, range_end, false).first
    new_content = "#{last_line_content} # => #{result.inspect}"
    buffer.set_lines(range_end - 1, range_end, false, [new_content])
  end

  plug.autocmd(:VimEnter, pattern: "*") do |nvim|
    nvim.command("nnoremap <leader>r :EvalRuby<CR>")
  end
end
