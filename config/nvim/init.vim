"     ____             _          ______    ________         ______                           __
"    / __ )__  _______(_)__  ____/ /  _/___/_  __/ /_  ___  / ____/________  __  ______  ____/ /
"   / __  / / / / ___/ / _ \/ __  // // __ \/ / / __ \/ _ \/ / __/ ___/ __ \/ / / / __ \/ __  /
"  / /_/ / /_/ / /  / /  __/ /_/ // // / / / / / / / /  __/ /_/ / /  / /_/ / /_/ / / / / /_/ /
" /_____/\__,_/_/  /_/\___/\__,_/___/_/ /_/_/ /_/ /_/\___/\____/_/   \____/\__,_/_/ /_/\__,_/
"
" Filename: init.vim
" GitHub: https://github.com/BuriedInTheGround/nixos-config
" Maintainer: Simone Ragusa (BuriedInTheGround)

" Colors {{{
" Enable 24-bit RGB, Set Opaque Background
set termguicolors

" Apply Theme
syntax on
let g:airline_theme='nord'
let g:nord_cursor_line_number_background=1
let g:nord_italic=1
let g:nord_italic_comments=1
let $BAT_THEME = 'Nord'
colorscheme nord

" Monokai Mode (Dark)
function! ColorMonokai()
    syntax on
    let g:airline_theme = 'molokai'
    let g:monokai_term_italic=1
    let $BAT_THEME = 'Monokai Extended'
    colorscheme monokai
endfunction

" Nord Mode (Dark)
function! ColorNord()
    syntax on
    let g:airline_theme='nord'
    let g:nord_cursor_line_number_background=1
    let g:nord_italic=1
    let g:nord_italic_comments=1
    let $BAT_THEME = 'Nord'
    colorscheme nord
endfunction

function! ChangeSyntaxHighlighting()
    if exists("g:syntax_on")
        syntax off
    else
        syntax on
    endif
endfunction
" }}}

" Other Configurations {{{
set autowrite
set tabstop=4 softtabstop=0 shiftwidth=4 expandtab smarttab
set encoding=utf-8
set splitright
set inccommand=nosplit
set omnifunc=syntaxcomplete#Complete  " Http://vim.wikia.com/wiki/Omni_completion
set mouse=a  " Enable Mouse Mode for All Modes

" Set the Leader
nnoremap <Space> <Nop>
let mapleader=" "
" }}}

" Neovim Terminal {{{
tmap <Space><Esc> <C-\><C-n>
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
" }}}

" UI {{{
set cursorline
set colorcolumn=80

" Turn Hybrid Line Numbers ON
set number relativenumber
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Dynamically Toggle smartcase
" -> Off when in a : command line
" -> On  when in a / command line
set ignorecase smartcase
augroup dynamic_smartcase
    autocmd!
    autocmd CmdLineEnter * set nosmartcase
    autocmd CmdLineLeave * set smartcase
augroup END

" Show `▸▸` for Tabs & `·` for Trailing Whitespaces
set list listchars=tab:▸▸,trail:·
" }}}

" Section Folding {{{
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax
nnoremap <leader><Space> za
" }}}

" LSP {{{
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <C-x><C-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD',        '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd',        '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K',         '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi',        '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>',     '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<Space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<Space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<Space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<Space>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<Space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<Space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr',        '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<Space>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d',        '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d',        '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<Space>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<Space>fo', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Setup luasnip
local luasnip = require 'luasnip'

-- Setup nvim-cmp
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
            elseif luasnip.expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
            elseif luasnip.jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
            else
                fallback()
            end
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}
EOF
" }}}

" Tree-sitter Configuration {{{
lua << EOF
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true, -- Setting `false` will disable the whole extension
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
        },
    },
    indent = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- Whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
    },
}
EOF
" }}}

" Plugin Configurations {{{
" Telescope
lua << EOF
local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ["<Esc>"] = actions.close
            },
        },
    }
}

require('telescope').load_extension('fzf')
EOF

" Neovim Treesitter Playground
lua << EOF
require('nvim-treesitter.configs').setup {
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<CR>',
            show_help = '?',
        },
    }
}
EOF
" }}}

" Filetype-Specific {{{
"
" Nothing to see here...
"
" }}}

" Custom Mappings {{{
" Change Theme
nnoremap <leader>c1 :call ColorMonokai()<CR>
nnoremap <leader>c2 :call ColorNord()<CR>

" Turn Syntax ON/OFF
nnoremap <leader>sh :call ChangeSyntaxHighlighting()<CR>

" Clear Search Result Highlight
nnoremap ,<Space> :nohlsearch<CR>

" Split Navigation Mappings
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" Avoid Stupid Typos
command! W :w
command! Q :q
command! WQ :wq
command! Wq :wq

" Autocomplete with ctrl-space
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files disable_devicons=true<CR>
nnoremap <leader>fg <cmd>Telescope live_grep disable_devicons=true<CR>
nnoremap <leader>fb <cmd>Telescope buffers disable_devicons=true<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
" }}}

" vim:foldmethod=marker:foldlevel=0
