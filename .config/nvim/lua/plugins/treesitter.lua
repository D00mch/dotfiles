-- [nfnl] Compiled from fnl/plugins/treesitter.fnl by https://github.com/Olical/nfnl, do not edit.
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
  return treesitter.setup({ensure_installed = {"java", "yaml", "bash", "kotlin", "clojure", "fennel", "scheme", "racket", "lua", "luadoc", "vimdoc", "vim", "markdown", "markdown_inline", "http", "json", "sql", "dart", "go", "typescript", "css", "rust"}, highlight = {enable = true, additional_vim_regex_highlighting = false}, textobjects = {select = {enable = true, keymaps = {am = "@function.outer", im = "@function.inner"}}}, indent = {enable = true}})
end
return {{"nvim-treesitter/nvim-treesitter", lazy = true, event = "bufread", dependencies = {"HiPhish/nvim-ts-rainbow2", "nvim-treesitter/nvim-treesitter-textobjects", "nvim-treesitter/nvim-treesitter-refactor"}, build = ":TSUpdate", init = _3_, config = _4_}}
