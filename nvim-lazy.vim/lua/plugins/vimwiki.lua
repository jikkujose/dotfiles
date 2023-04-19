return {
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_list = {
        { path = "~/vimwiki", syntax = "markdown", ext = ".md", links_space_char = "-" },
      }
      vim.g.vimwiki_ext2syntax = { [".md"] = "markdown", [".markdown"] = "markdown", [".mdown"] = "markdown" }
      vim.g.vimwiki_use_mouse = 0
      vim.g.vimwiki_markdown_link_ext = 1
    end,
  },
}
