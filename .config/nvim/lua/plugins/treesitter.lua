-- [nfnl] fnl/plugins/treesitter.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local function _3_()
  nvim.o.foldmethod = "expr"
  nvim.o.foldexpr = "nvim_treesitter#foldexpr()"
  local treesitter = require("nvim-treesitter")
  return treesitter.install({"java", "yaml", "bash", "kotlin", "clojure", "fennel", "scheme", "racket", "lua", "luadoc", "vimdoc", "vim", "markdown", "markdown_inline", "http", "json", "sql", "dart", "go", "typescript", "css", "rust"})
end
return {{"nvim-treesitter/nvim-treesitter", dependencies = {}, build = ":TSUpdate", init = _3_, config = true, lazy = false}}
