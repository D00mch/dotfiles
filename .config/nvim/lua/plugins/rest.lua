-- [nfnl] Compiled from .config/nvim/fnl/plugins/rest.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local bkset = _local_2_["bkset"]
local function setup_rest()
  bkset("n", "<Leader>a", "<Plug>RestNvimPreview")
  bkset("n", "<Leader>e", "<Plug>RestNvim")
  return bkset("n", "<Leader>q", "<Plug>RestNvim")
end
local function _3_()
  return vim.api.nvim_create_autocmd("BufWinEnter", {pattern = "*.http", group = vim.api.nvim_create_augroup("HttpMappings", {clear = true}), callback = setup_rest})
end
return {{"rest-nvim/rest.nvim", lazy = true, ft = {"http"}, init = _3_, opts = {result_split_in_place = true, jump_to_request = true}, config = true}}
