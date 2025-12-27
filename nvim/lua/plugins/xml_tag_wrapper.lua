-- XML Tag Wrapper Plugin
-- Keybinding: `gt` to wrap line/selection in XML tags

-- Sanitize string for valid XML tag name
local function sanitize_tag_name(str)
  if not str or str:match("^%s*$") then return nil end
  -- Replace spaces with underscores, remove invalid XML chars
  return str:gsub("%s+", "_"):gsub("[^%w_]", "")
end

-- Normal mode: Wrap current line in XML tags using line content as tag name
local function wrap_line()
  local line = vim.api.nvim_get_current_line()
  local tag = sanitize_tag_name(line)
  if not tag then
    vim.notify("Empty or invalid line", vim.log.levels.ERROR)
    return
  end
  -- Create wrapped content
  local wrapped = string.format("<%s>\n\n</%s>", tag, tag)
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  -- Replace line and adjust cursor
  vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, vim.split(wrapped, "\n"))
  vim.api.nvim_win_set_cursor(0, {lnum + 1, 0})
  vim.cmd("startinsert")
end

-- Visual mode: Prompt for tag name, wrap selected lines, return to normal mode
local function wrap_selection()
  local start_row = vim.fn.line("'<") - 1
  local end_row = vim.fn.line("'>")
  if start_row >= end_row then
    vim.notify("Invalid selection", vim.log.levels.ERROR)
    return
  end
  -- Get selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
  if #lines == 0 then
    vim.notify("Empty selection", vim.log.levels.ERROR)
    return
  end
  -- Prompt for tag name
  vim.ui.input({ prompt = "Enter tag name: " }, function(input)
    local tag = sanitize_tag_name(input)
    if not tag then
      vim.notify("Empty or invalid tag name", vim.log.levels.ERROR)
      return
    end
    -- Wrap with user-provided tag
    local wrapped = {string.format("<%s>", tag)}
    vim.list_extend(wrapped, lines)
    table.insert(wrapped, string.format("</%s>", tag))
    -- Replace selection
    vim.api.nvim_buf_set_lines(0, start_row, end_row, false, wrapped)
    -- Position cursor after start tag, stay in normal mode
    vim.api.nvim_win_set_cursor(0, {start_row + 1, 0})
  end)
end

-- Set keybindings for gt
vim.keymap.set("n", "gt", wrap_line, {noremap = true, silent = true, desc = "Wrap line in XML tags"})
vim.keymap.set("v", "gt", wrap_selection, {noremap = true, silent = true, desc = "Wrap selection in XML tags"})
