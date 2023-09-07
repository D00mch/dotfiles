-- [nfnl] Compiled from .config/nvim/fnl/plugins/treesitter.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function _3_()
  nvim.o.foldmethod = "expr"
  nvim.o.foldexpr = "nvim_treesitter#foldexpr()"
  return nil
end
local function _4_()
  local treesitter = require("nvim-treesitter.configs")
  local ts_rainbow = require("ts-rainbow")
  return treesitter.setup({ensure_installed = {"java", "lua", "yaml", "bash", "kotlin", "clojure", "fennel", "scheme", "racket", "markdown", "markdown_inline", "http", "json", "sql", "dart", "vim"}, rainbow = {enable = true, strategy = ts_rainbow.strategy.global}, highlight = {enable = true, additional_vim_regex_highlighting = false}, indent = {enable = true}})
end
return {{"nvim-treesitter/nvim-treesitter", lazy = true, event = "bufread", dependencies = {"HiPhish/nvim-ts-rainbow2", "nvim-treesitter/nvim-treesitter-refactor"}, build = ":TSUpdate", init = _3_, config = _4_}}
