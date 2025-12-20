-- [nfnl] fnl/plugins/rust.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = autoload("config.util")
local bkset = _local_2_.bkset
local vis_op_2b = _local_2_["vis-op+"]
local on_attach = _local_2_["on-attach"]
local cmplsp = autoload("cmp_nvim_lsp")
local function _3_()
  vim.g.rustaceanvim = {server = {on_attach = on_attach, capabilities = cmplsp.default_capabilities()}}
  return nil
end
return {{"mrcjkb/rustaceanvim", version = "^7", tag = "v7.0.6", cond = true, init = _3_, lazy = false}}
