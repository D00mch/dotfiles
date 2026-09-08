-- [nfnl] fnl/plugins/rust.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = autoload("config.util")
local on_attach = _local_2_["on-attach"]
local function _3_()
  return vim.lsp.config("rust-analyzer", {on_attach = on_attach})
end
return {{"mrcjkb/rustaceanvim", version = "^7", tag = "v7.0.6", cond = true, init = _3_, lazy = false}}
