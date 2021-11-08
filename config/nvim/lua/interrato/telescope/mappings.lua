local function noremap(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

local function nnoremap(lhs, rhs)
  noremap("n", lhs, rhs)
end

-- Files
nnoremap("<Leader>ff", "<Cmd>Telescope find_files<CR>")
nnoremap("<Leader>fg", "<Cmd>Telescope live_grep<CR>")

-- Git
nnoremap("<Leader>gc", "<Cmd>Telescope git_commits<CR>")

-- Neovim
nnoremap("<Leader>fb", "<Cmd>Telescope buffers<CR>")
nnoremap("<Leader>fh", "<Cmd>Telescope help_tags<CR>")
nnoremap("<Leader>ts", "<Cmd>Telescope treesitter<CR>")
nnoremap("<Leader>wd", "<Cmd>Telescope lsp_workspace_diagnostics<CR>")
