-- [nfnl] Compiled from .config/nvim/fnl/plugins/tabs.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local _local_3_ = autoload("nfnl.core")
local map = _local_3_["map"]
local _local_4_ = autoload("nfnl.string")
local join = _local_4_["join"]
local function _5_()
  kset({"n", "x"}, "<D-.>", ":BufferLineCycleNext<Cr>")
  kset({"i", "c"}, "<D-.>", "<Esc><D-.>", {remap = true})
  kset("t", "<D-.>", "<C-\\><C-n><D-.>", {remap = true})
  kset({"n", "x"}, "<D-,>", ":BufferLineCyclePrev<Cr>")
  kset({"i", "c"}, "<D-,>", "<Esc><D-,>", {remap = true})
  kset("t", "<D-,>", "<C-\\><C-n><D-,>", {remap = true})
  kset({"n"}, ">>", ":BufferLineMoveNext<cr>")
  kset({"n"}, "<<", ":BufferLineMovePrev<cr>")
  kset({"n", "t", "x"}, "<D-t>", "<Leader><Space>", {remap = true})
  local bufferline = require("bufferline")
  for i = 1, 8 do
    local function _6_()
      return bufferline.go_to_buffer(i, true)
    end
    kset("n", ("<D-" .. i .. ">"), _6_)
  end
  local function _7_()
    return bufferline.go_to_buffer(-1, true)
  end
  return kset("n", "<D-9>", _7_)
end
local function _8_()
  local bufferline = require("bufferline")
  local split_name
  local function _9_(name)
    local subwords = {}
    local current_subword = ""
    for i = 1, #name do
      local char = name:sub(i, i)
      local is_delimiter = char:match("[%.%-%_]")
      local is_uppercase = char:match("[A-Z]")
      if (is_delimiter or ((is_uppercase and (i > 1)) and (current_subword ~= ""))) then
        if (#current_subword > 0) then
          table.insert(subwords, current_subword)
        else
        end
        current_subword = ""
      else
      end
      if not is_delimiter then
        current_subword = (current_subword .. char)
      else
      end
    end
    if (current_subword ~= "") then
      table.insert(subwords, current_subword)
    else
    end
    return subwords
  end
  split_name = _9_
  local function _14_(_241)
    local name = vim.fn.fnamemodify(_241.name, ":t:r")
    local subwords = split_name(name)
    if (#name <= 8) then
      return name
    elseif (#subwords < 2) then
      return name
    else
      local function _15_(two_letters)
        return two_letters:gsub("^%l", string.upper)
      end
      local function _16_(subword)
        return subword:sub(1, 3)
      end
      return join(map(_15_, map(_16_, subwords)))
    end
  end
  return bufferline.setup({options = {separator_style = "slant", show_duplicate_prefix = true, tab_size = 12, name_formatter = _14_, always_show_bufferline = false}, highlights = {numbers_selected = {italic = false}, buffer_selected = {bold = true, italic = false}}})
end
return {{"akinsho/bufferline.nvim", init = _5_, config = _8_}}
