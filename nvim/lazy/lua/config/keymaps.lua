-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- map("n", , ":! rufo % <cr>", )
vim.keymap.set("n", "<leader>r", ":! rufo % <CR>", { desc = "Format Ruby" })
