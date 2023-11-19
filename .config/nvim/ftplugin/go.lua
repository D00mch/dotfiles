-- [nfnl] Compiled from .config/nvim/ftplugin/go.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local bkset = _local_2_["bkset"]
bkset("i", "<D-e>", ":=")
bkset("n", "<Leader>tc", ":GoTestFunc -v -F<Cr>")
bkset("n", "<Leader>ta", ":GoTest -v -F<Cr>")
bkset("n", "<Leader>re", ":GoIfErr<Cr>g;")
return bkset("n", "<Leader>b", ":GoRun % -F -v<Cr>")
