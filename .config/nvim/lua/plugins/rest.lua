-- [nfnl] fnl/plugins/rest.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = autoload("config.util")
local bkset = _local_2_.bkset
local function setup_rest()
  bkset("n", "<Leader>a", "<Cmd>Rest open<CR>", "Open HTTP results")
  bkset("n", "<Leader>e", "<Cmd>Rest run<CR>", "Run HTTP request")
  return bkset("n", "<Leader>q", "<Cmd>Rest run<CR>", "Run HTTP request")
end
local function _3_()
  return vim.api.nvim_create_autocmd("BufWinEnter", {pattern = "*.http", group = vim.api.nvim_create_augroup("HttpMappings", {clear = true}), callback = setup_rest})
end
return {{"rest-nvim/rest.nvim", main = "rest-nvim", lazy = true, ft = {"http"}, init = _3_, opts = {}}}
