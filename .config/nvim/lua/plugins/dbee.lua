-- [nfnl] Compiled from fnl/plugins/dbee.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function _3_()
  local dbee = require("dbee")
  return dbee.install()
end
local function _4_()
  return kset("n", "<Space>td", ":Dbee toggle<CR>", "Dbee")
end
local function _5_()
  local dbee = require("dbee")
  return dbee.setup({result = {mappings = {{key = "gn", mode = "n", action = "page_next"}, {key = "gp", mode = "n", action = "page_prev"}, {key = "g0", mode = "n", action = "page_first"}, {key = "g9", mode = "n", action = "page_last"}}}, editor = {mappings = {{key = "<D-CR>", mode = "v", action = "run_selection"}, {key = "<D-CR>", mode = "n", action = "run_file"}}}})
end
return {{"kndndrj/nvim-dbee", lazy = true, cmd = "Dbee", cond = os.getenv("OPENAI_API_KEY"), dependencies = {"MunifTanjim/nui.nvim"}, build = _3_, init = _4_, config = _5_}}
