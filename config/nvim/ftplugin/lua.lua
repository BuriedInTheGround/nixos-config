-- Use two spaces for each step of (auto)indent
vim.opt.shiftwidth = 2

-- Do not insert the current comment leader when creating a newline after
-- hitting 'o' or 'O' in Normal mode
vim.opt.formatoptions:remove("o")
