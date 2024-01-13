-- [nfnl] Compiled from .config/nvim/fnl/plugins/csv.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local bkset = _local_2_["bkset"]
local function setup_csv()
  return bkset("n", "=", ":RainbowAlign<Cr>")
end
vim.api.nvim_create_autocmd("BufEnter", {pattern = "*.csv", group = vim.api.nvim_create_augroup("CSVSetup", {clear = true}), callback = setup_csv})
return {{"cameron-wags/rainbow_csv.nvim", lazy = true, config = true, ft = {"csv", "csv_semicolon", "csv_whitespace", "csv_pipe", "tsv", "rfc_csv", "rfc_semicolon"}, cmd = {"RainbowDelim", "RainbowDelimSimple", "RainbowDelimQuoted", "RainbowMultiDelim"}}}
