-- [nfnl] fnl/plugins/treesitter.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local _local_3_ = autoload("nfnl.core")
local contains_3f = _local_3_["contains?"]
local function _4_()
  local ts_objects = require("nvim-treesitter-textobjects")
  local ts_select = require("nvim-treesitter-textobjects.select")
  local tskset
  local function _5_(ks, obj)
    local function _6_()
      return ts_select.select_textobject(obj, "textobjects")
    end
    return kset({"x", "o"}, ks, _6_)
  end
  tskset = _5_
  local parsers = {"java", "yaml", "bash", "sh", "kotlin", "clojure", "fennel", "scheme", "racket", "lua", "luadoc", "vimdoc", "vim", "markdown", "markdown_inline", "http", "json", "sql", "dart", "go", "typescript", "css", "rust"}
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
  local function _7_(ev)
    local ft = nvim.bo[ev.buf].filetype
    local lang = (vim.treesitter.language.get_lang(ft) or ft)
    if contains_3f(parsers, lang) then
      return pcall(vim.treesitter.start, ev.buf, lang)
    else
      return nil
    end
  end
  return vim.api.nvim_create_autocmd("FileType", {pattern = "*", callback = _7_})
end
return {{"nvim-treesitter/nvim-treesitter", dependencies = {{"nvim-treesitter/nvim-treesitter-textobjects", branch = "main"}}, branch = "main", build = ":TSUpdate", init = _4_, config = true, lazy = false}}
