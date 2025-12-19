-- [nfnl] fnl/plugins/rust.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local bkset = _local_2_.bkset
return {{"mrcjkb/rustaceanvim", version = "^6", tag = "v7.0.6", lazy = false}}
