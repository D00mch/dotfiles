-- [nfnl] fnl/plugins/quickfix.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local function _3_()
  kset("n", "<Space>pq", "<Cmd>copen<Cr>", "Quickfix")
  kset("n", "]q", ":cn<cr>", "Quickfix: next item")
  return kset("n", "[q", ":cp<cr>", "Quickfix: prev item")
end
local function _4_(_, opts)
  require("bqf").setup(opts)
  local handler = require("bqf.preview.handler")
  local preview = require("bqf.preview.floatwin")
  local resize_preview
  local function _5_()
    local height = math.max(1, math.floor((vim.o.lines * 0.7)))
    preview.defaultHeight = height
    preview.defaultVHeight = height
    if preview:validate() then
      return handler.redrawWin(preview.qwinid)
    else
      return nil
    end
  end
  resize_preview = _5_
  resize_preview()
  return vim.api.nvim_create_autocmd("VimResized", {group = vim.api.nvim_create_augroup("QuickfixPreviewHeight", {clear = true}), callback = resize_preview})
end
return {{"kevinhwang91/nvim-bqf", lazy = true, ft = {"qf"}, init = _3_, opts = {func_map = {}}, config = _4_}}
