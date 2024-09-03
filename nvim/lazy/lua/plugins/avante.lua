return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = vim.fn.has("win32") == 1 and "powershell -ExecutionPolicy Bypass -File Build-LuaTiktoken.ps1" or "make",
    opts = {},
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
