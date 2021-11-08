--[[
     ____             _          ______    ________         ______                           __
    / __ )__  _______(_)__  ____/ /  _/___/_  __/ /_  ___  / ____/________  __  ______  ____/ /
   / __  / / / / ___/ / _ \/ __  // // __ \/ / / __ \/ _ \/ / __/ ___/ __ \/ / / / __ \/ __  /
  / /_/ / /_/ / /  / /  __/ /_/ // // / / / / / / / /  __/ /_/ / /  / /_/ / /_/ / / / / /_/ /
 /_____/\__,_/_/  /_/\___/\__,_/___/_/ /_/_/ /_/ /_/\___/\____/_/   \____/\__,_/_/ /_/\__,_/

 Filename: init.lua
 GitHub: https://github.com/BuriedInTheGround/nixos-config
 Maintainer: Simone Ragusa (BuriedInTheGround)

]]

-- Set the <Leader>
vim.api.nvim_set_keymap("n", "<Space>", "<Nop>", {
  noremap = true, silent = true
})
vim.g.mapleader = " "

-- Vim/Neovim options
require "interrato.settings"

-- Mappings
require "interrato.mappings"

-- Neovim builtin LSP configuration
require "interrato.lsp"

-- Telescope configuration
require "interrato.telescope"
require "interrato.telescope.mappings"
