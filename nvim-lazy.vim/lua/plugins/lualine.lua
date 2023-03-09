return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = function()
      return {
        options = { section_separators = "", component_separators = "" },
      }
    end,
  },
}
