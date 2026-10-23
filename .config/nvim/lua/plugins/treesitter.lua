-- [nfnl] fnl/plugins/treesitter.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local parsers = {"java", "yaml", "bash", "kotlin", "clojure", "fennel", "scheme", "racket", "lua", "luadoc", "vimdoc", "vim", "markdown", "markdown_inline", "http", "json", "sql", "dart", "go", "typescript", "tsx", "css", "rust", "python"}
local function _4_(_, _3_)
  local parsers0 = _3_.parsers
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
  ts_objects.setup({select = {lookahead = true}})
  tskset("am", "@function.outer")
  tskset("im", "@function.inner")
  tskset("ac", "@class.outer")
  tskset("ic", "@class.inner")
  tskset("ar", "@parameter.outer")
  tskset("ir", "@parameter.inner")
  tskset("ak", "@block.outer")
  tskset("ik", "@block.inner")
  do
    local treesitter = require("nvim-treesitter")
    treesitter.setup()
    treesitter.install(parsers0)
  end
  local function _7_()
    if vim.tbl_contains(parsers0, vim.treesitter.language.get_lang(vim.bo.filetype)) then
      return vim.treesitter.start()
    else
      return nil
    end
  end
  return vim.api.nvim_create_autocmd("FileType", {group = vim.api.nvim_create_augroup("TreesitterHighlight", {clear = true}), callback = _7_})
end
return {{"nvim-treesitter/nvim-treesitter", dependencies = {{"nvim-treesitter/nvim-treesitter-textobjects", branch = "main"}}, branch = "main", build = ":TSUpdate", opts = {parsers = parsers}, config = _4_, lazy = false}}
