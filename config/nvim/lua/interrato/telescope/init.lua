require("telescope").setup {
  defaults = {
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    color_devicons = true,
    mappings = {
      i = {
        ["<Esc>"] = require("telescope.actions").close
      },
    },
  }
}

require("telescope").load_extension("fzf")
