return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(
        opts.sources,
        nls.builtins.formatting.prettierd.with({
          env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/prettierrc.json"),
          },
        })
      )
    end,
  },
}

-- return {
--   "jose-elias-alvarez/null-ls.nvim",
--   event = "BufReadPre",
--   dependencies = { "mason.nvim" },
--   opts = function(_, opts)
--     local nls = require("null-ls")
--     opts.sources = vim.list_extend(opts.sources, {
--       nls.builtins.formatting.prettierd,
--       nls.builtins.formatting.stylua,
--       nls.builtins.diagnostics.flake8,
--     })
--   end,
-- }
