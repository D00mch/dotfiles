-- [nfnl] fnl/plugins/gitblame.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local function _3_()
  return kset({"n", "x"}, "<space>ga", ":BlameToggle<Cr>")
end
return {"FabijanZulj/blame.nvim", cmd = "BlameToggle", lazy = true, init = _3_, opts = {}}
