-- [nfnl] Compiled from .config/nvim/fnl/config/which.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local wk = autoload("which-key")
local _local_2_ = autoload("nfnl.core")
local assoc = _local_2_["assoc"]
local update = _local_2_["update"]
local dec = _local_2_["dec"]
local inc = _local_2_["inc"]
local first = _local_2_["first"]
local second = _local_2_["second"]
local _local_3_ = autoload("config.util")
local kset = _local_3_["kset"]
local bkset = _local_3_["bkset"]
local bkdel = _local_3_["bkdel"]
local get_word_under_selection = _local_3_["get-word-under-selection"]
vim.o.timeoutlen = 250
local function toggle(key, name, cmd, opts)
  local opts0
  if (type(opts) == "table") then
    opts0 = opts
  elseif (type(opts) == "number") then
    opts0 = {buffer = opts}
  elseif (type(opts) == "string") then
    opts0 = {mode = opts}
  else
    opts0 = {}
  end
  return wk.register({t = {name = "toggle", [key] = {cmd, name}}}, assoc(opts0, "prefix", "<Space>"))
end
vim.api.nvim_command("set keymap=russian-jcukenwin")
nvim.o.iminsert = 0
nvim.o.imsearch = 0
local function set_lang_cmd(lang_name)
  local n
  if (lang_name == "en_US") then
    n = 0
  else
    n = 1
  end
  return ("set iminsert=" .. n .. " imsearch=" .. n .. "|" .. "lang " .. lang_name .. ".UTF-8|")
end
local function toggle_keyboard()
  local function _6_()
    if (nvim.o.iminsert == 0) then
      return "ru_RU"
    else
      return "en_US"
    end
  end
  return vim.cmd(set_lang_cmd(_6_()))
end
kset({"x", "n"}, "<C-6>", toggle_keyboard, {remap = true})
local function _7_()
  vim.bo.modifiable = not vim.bo.modifiable
  return nil
end
local function _8_()
  vim.o.list = not vim.o.list
  return nil
end
local function _9_()
  nvim.g.neovide_fullscreen = not nvim.g.neovide_fullscreen
  return nil
end
local function _10_()
  vim.o.relativenumber = not vim.o.relativenumber
  return nil
end
wk.register({["<Space>"] = {r = {("<Cmd>" .. set_lang_cmd("ru_RU") .. "setlocal spell! spelllang=ru_ru,en_us<cr>"), "Set RUS, toggle grammar"}, e = {("<Cmd>" .. set_lang_cmd("en_US") .. "setlocal spell! spelllang=ru_ru,en_us<cr>"), "Set ENG, toggle grammar"}, t = {name = "toggle", m = {_7_, "Modifiable"}, i = {_8_, "List invisible chars"}, f = {_9_, "Full Screen"}, r = {_10_, "Relative Numbers"}, R = {"mZ:Bd!<cr>`Z", "Refresh file"}, a = {name = "Animation", ["1"] = {"<cmd>CellularAutomaton make_it_rain<CR>", "Rain"}, ["2"] = {"<cmd>CellularAutomaton game_of_life<CR>", "Game"}}}}})
wk.register({["<Space>"] = {f = {{j = {"!jq<cr>", "Json"}, p = {"!pg_format -s 2<cr>", "pSQL"}, c = {"<Esc>:ReplaceSelection tocamel<Cr>", "CamelCase"}, s = {"<Esc>:ReplaceSelection tosnake<Cr>", "snake_case"}, k = {"<Esc>:ReplaceSelection tokebab<Cr>", "kebab-case"}, ["8"] = {"<Esc>:set tw=80<Cr>gvgq", "80 width"}}, "Format"}}}, {mode = "x"})
vim.o.listchars = "eol:\194\172,space:\194\183,tab:\226\134\146-,extends:\226\150\184,precedes:\226\151\130,multispace:\194\183\194\183\194\183\226\172\157,leadmultispace:\226\148\130   "
local function tocamel(s)
  local function _11_(part)
    local before, after = part:sub(1, 1), part:sub(2)
    return (before:upper() .. after)
  end
  return s:gsub("[_|-](%w+)", _11_)
end
local function tosnake(s)
  return s:gsub("%f[^%l]%u", "_%1"):gsub("%f[^%a]%d", "_%1"):gsub("%f[^%d]%a", "_%1"):gsub("(%u)(%u%l)", "%1_%2"):lower():gsub("-", "_")
end
local function tokebab(s)
  return s:gsub("%f[^%l]%u", "-%1"):gsub("%f[^%a]%d", "_%1"):gsub("%f[^%d]%a", "-%1"):gsub("(%u)(%u%l)", "%1-%2"):lower():gsub("_", "-")
end
local function replace_selection(_12_)
  local _arg_13_ = _12_
  local f = _arg_13_["args"]
  local _let_14_ = get_word_under_selection()
  local word = _let_14_[1]
  local sr = _let_14_[2]
  local sc = _let_14_[3]
  local er = _let_14_[4]
  local ec = _let_14_[5]
  local f0
  if (f == "tokebab") then
    f0 = tokebab
  elseif (f == "tosnake") then
    f0 = tosnake
  elseif (f == "tocamel") then
    f0 = tocamel
  else
    f0 = nil
  end
  local result = f0(word)
  return vim.api.nvim_buf_set_text(0, sr, sc, er, ec, {result})
end
vim.api.nvim_create_user_command("ReplaceSelection", replace_selection, {nargs = 1, desc = "Replace selected word with result function"})
return {toggle = toggle}
