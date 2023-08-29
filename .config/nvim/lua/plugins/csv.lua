-- [nfnl] Compiled from fnl/plugins/csv.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local bkset = _local_2_["bkset"]
local vis_op_2b = _local_2_["vis-op+"]
local _local_3_ = autoload("nfnl.core")
local merge = _local_3_["merge"]
local function setup_csv()
  bkset("x", "=", ":ArrangeColumn<Cr>")
  return bkset("n", "<Leader>=", ":%ArrangeColumn<Cr>")
end
vim.api.nvim_create_autocmd("BufEnter", {pattern = "*.csv", group = vim.api.nvim_create_augroup("CSVSetup", {clear = true}), callback = setup_csv})
return {{"chrisbra/csv.vim", lazy = true, ft = {"csv", "csv_semicolon", "csv_whitespace", "csv_pipe", "tsv", "rfc_csv", "rfc_semicolon"}}}
