-- Enable 24-bit RGB, set opaque background
vim.opt.termguicolors = true

-- Let vim-airline use powerline icons
vim.g.airline_powerline_fonts = 1

-- Apply initial theme
require("interrato.colors").nord()
