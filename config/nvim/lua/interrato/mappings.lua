local function noremap(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

local function nnoremap(lhs, rhs)
  noremap("n", lhs, rhs)
end

local function inoremap(lhs, rhs)
  noremap("i", lhs, rhs)
end

local function tnoremap(lhs, rhs)
  noremap("t", lhs, rhs)
end

-- Change colorscheme
nnoremap("<Leader>c1", "<Cmd>lua require('interrato.colors').monokai()<CR>")
nnoremap("<Leader>c2", "<Cmd>lua require('interrato.colors').nord()<CR>")

-- Clear search result highlighting
nnoremap(",<Space>", "<Cmd>nohlsearch<CR>")

-- Split navigation
nnoremap("<C-j>", "<C-w><C-j>")
nnoremap("<C-k>", "<C-w><C-k>")
nnoremap("<C-l>", "<C-w><C-l>")
nnoremap("<C-h>", "<C-w><C-h>")

-- Exit terminal-mode with <Space><Esc>
tnoremap("<Space><Esc>", "<C-\\><C-n>")

-- Make terminal window small
nnoremap("<Leader>tt", "<Cmd>lua require('interrato.terminal').make_small()<CR>")

-- Toggle section folding with <CR>
nnoremap("<Space><Space>", "za")

-- Avoid stupid typos
vim.cmd [[
  command! W :w
  command! Q :q
  command! WQ :wq
  command! Wq :wq
]]

-- Autocomplete with Ctrl-Space
inoremap("<C-Space>", "<C-x><C-o>")
inoremap("<C-@>", "<C-Space>")
