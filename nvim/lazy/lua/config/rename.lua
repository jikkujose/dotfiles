-- Define the rename_file function
function _G.rename_file()
  local old_name = vim.fn.expand("%")
  local prompt = string.format("New file name [default: %s]: ", old_name)
  local new_name = vim.fn.input(prompt)

  if new_name == "" then
    new_name = old_name
  end

  if new_name ~= old_name then
    vim.cmd(":saveas " .. new_name)
    vim.cmd(":silent !rm " .. old_name)
    vim.cmd("redraw!")
  end
end

-- Set the key mapping
vim.api.nvim_set_keymap("n", "gmv", ":lua _G.rename_file()<cr>", { noremap = true, silent = true })
