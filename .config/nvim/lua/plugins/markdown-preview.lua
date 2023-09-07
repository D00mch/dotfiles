-- [nfnl] Compiled from .config/nvim/fnl/plugins/markdown-preview.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("config.which")
local toggle = _local_2_["toggle"]
local function _3_()
  return toggle("p", "MarkdownPreview", ":MarkdownPreviewToggle<Cr>")
end
local function _4_()
  nvim.g.mkdp_auto_close = 0
  vim.g.mkdp_filetypes = {"markdown"}
  return nil
end
return {"iamcco/markdown-preview.nvim", lazy = true, ft = {"markdown"}, build = "cd app && npm install", config = _3_, init = _4_}
