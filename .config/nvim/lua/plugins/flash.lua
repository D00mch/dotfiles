-- [nfnl] fnl/plugins/flash.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local english = "asdfghjklqwertyuiopzxcvbnm"
local function _3_()
  local flash = require("flash")
  return kset({"n", "x", "o"}, "q", flash.jump)
end
local function _4_(_, opts)
  require("flash").setup(opts)
  local function _5_()
    return vim.schedule(vim.cmd.redraw)
  end
  return vim.api.nvim_create_autocmd("CmdlineChanged", {group = vim.api.nvim_create_augroup("FlashSearchRedraw", {clear = true}), pattern = {"/", "?"}, callback = _5_})
end
return {{"folke/flash.nvim", lazy = true, init = _3_, opts = {labels = english, modes = {char = {enabled = false}, search = {enabled = true}, treesitter = {enabled = false}}, label = {rainbow = {shade = 5, enabled = false}, before = true, style = "inline", after = false, uppercase = false}}, config = _4_}}
