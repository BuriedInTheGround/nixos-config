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
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob", "!.git",
      "--trim"
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--strip-cwd-prefix", "--hidden", "--exclude", ".git", "--type", "file" }
    },
  }
}

require("telescope").load_extension("fzf")
