local M = {}

function M.make_small()
  vim.cmd [[
    new
    wincmd J
  ]]
  vim.api.nvim_win_set_height(0, 12)
  vim.opt.winfixheight = true
  vim.cmd [[ term ]]
end

return M
