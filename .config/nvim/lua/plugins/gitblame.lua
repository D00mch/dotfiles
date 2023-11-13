-- [nfnl] Compiled from .config/nvim/fnl/plugins/gitblame.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function _3_()
  return kset({"n", "x"}, "<space>ga", ":ToggleBlame<Cr>")
end
return {"FabijanZulj/blame.nvim", init = _3_, config = {}}
