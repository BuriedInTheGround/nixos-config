-- General
vim.opt.autowrite = true
vim.opt.updatetime = 100 -- Faster updates, better UX
vim.opt.hidden = true -- Don't unload buffers when abandoned
vim.opt.encoding = "utf-8"
vim.opt.inccommand = "nosplit"
vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.opt.mouse = "nv" -- Enable mouse support only for Normal and Visual modes

-- Dynamically toggle smartcase
--  ➤ Off when in a : command line
--  ➤ On  when in a / command line
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.cmd [[
augroup DynamicSmartcase
  autocmd!
  autocmd CmdLineEnter * set nosmartcase
  autocmd CmdLineLeave * set smartcase
augroup END
]]

-- Tabs & Indentation
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of indent
vim.opt.softtabstop = 4 -- Number of spaces that an inserted <Tab> counts for
vim.opt.expandtab = true -- Insert spaces when inserting a <Tab>
vim.opt.smarttab = true -- A <Tab> in front inserts according to 'shiftwidth'

vim.opt.autoindent = true -- Copy indent from current line on newline
vim.opt.cindent = true -- Automatic C program indenting
vim.opt.wrap = true -- Wrap long lines

vim.opt.breakindent = true -- Wrapped lines will be visually indented
vim.opt.showbreak = "…" .. string.rep(" ", 3)
vim.opt.linebreak = true -- Wrap lines on word boundaries (see :h breakat)

-- Splits {{{
vim.opt.splitright = true -- Splitting puts the new window on the right

-- Neovim Terminal
vim.cmd [[
  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert
]]

-- UI
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 8 -- Keep at least 8 lines above and below the cursor

vim.opt.pumblend = 17 -- Pseudo-transparency for the popup-menu

-- Hybrid line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd [[
augroup HybridLinenumber
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
]]

-- Highlight after yank
vim.cmd [[
augroup HighlightYank
  autocmd!
  autocmd TextYankPost * silent! lua require("vim.highlight").on_yank()
augroup END
]]

-- List mode symbols
--  ➤ Use `⇥ ` for tabs
--  ➤ Use `·` for trailing whitespaces
--  ➤ Use `⍽` for non-breaking spaces
--  ➤ Use `↵` for EOLs
vim.opt.list = true
vim.opt.listchars = { tab = "⇥ ", trail = "·", nbsp = "⍽", eol = "↵" }

-- Section Folding
vim.opt.foldenable = true
vim.opt.foldlevelstart = 10
vim.opt.foldnestmax = 10
vim.opt.foldmethod = "syntax"

-- Wildmenu
-- Ignore compiled files
vim.opt.wildignore = "__pycache__"
vim.opt.wildignore = vim.opt.wildignore + { "*.o", "*~", "*.pyc", "*pycache*" }

vim.opt.wildmode = "longest:full"
vim.opt.wildoptions = "pum"

-- Use the 'tex' filetype by default instead of 'plaintex'
vim.g.tex_flavor = "latex"
