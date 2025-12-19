-- [nfnl] ftplugin/rust.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = autoload("config.util")
local bkset = _local_2_.bkset
return bkset("n", "<Leader>k", ":RustLsp run<CR>")
