-- [nfnl] fnl/plugins/treesitter.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local langs = {"java", "yaml", "bash", "kotlin", "clojure", "fennel", "scheme", "racket", "lua", "luadoc", "vimdoc", "vim", "markdown", "markdown_inline", "http", "json", "sql", "dart", "go", "typescript", "css", "rust"}
local function _3_()
  local ts_objects = require("nvim-treesitter-textobjects")
  local ts_select = require("nvim-treesitter-textobjects.select")
  local tskset
  local function _4_(ks, obj)
    local function _5_()
      return ts_select.select_textobject(obj, "textobjects")
    end
    return kset({"x", "o"}, ks, _5_)
  end
  tskset = _4_
  local parsers = langs
  ts_objects.setup({select = {lookahead = true}})
  tskset("am", "@function.outer")
  tskset("im", "@inner")
  tskset("ac", "@class.inner")
  tskset("ic", "@class.inner")
  tskset("ar", "@parameter.inner")
  tskset("ir", "@parameter.inner")
  tskset("ak", "@block.inner")
  tskset("ik", "@block.inner")
  nvim.o.foldmethod = "expr"
  nvim.o.foldexpr = "nvim_treesitter#foldexpr()"
  do
    local treesitter = require("nvim-treesitter")
    treesitter.install(parsers)
    treesitter.setup()
  end
  local function _6_()
    return vim.treesitter.start()
  end
  return vim.api.nvim_create_autocmd("FileType", {callback = _6_, pattern = langs})
end
return {{"nvim-treesitter/nvim-treesitter", dependencies = {{"nvim-treesitter/nvim-treesitter-textobjects", branch = "main"}}, branch = "main", build = ":TSUpdate", ft = langs, init = _3_, config = true, lazy = false}}
