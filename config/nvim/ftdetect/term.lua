vim.cmd [[
  augroup TermDetect
    autocmd!
    autocmd TermOpen term://* set ft=term
  augroup END
]]
