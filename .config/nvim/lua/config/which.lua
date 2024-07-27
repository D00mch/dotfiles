-- [nfnl] Compiled from fnl/config/which.fnl by https://github.com/Olical/nfnl, do not edit.
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
local function _4_()
  return wk.show({global = false})
end
kset("n", "<space>?", _4_)
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
kset("n", "<Space>e", ("<Cmd>" .. set_lang_cmd("en_US") .. "setlocal spell! spelllang=ru_ru,en_us<cr>"), "Set ENG, toggle grammar")
kset("n", "<Space>r", ("<Cmd>" .. set_lang_cmd("ru_RU") .. "setlocal spell! spelllang=ru_ru,en_us<cr>"), "Set RUS, toggle grammar")
wk.add({"<space>t", group = "Toggle"})
wk.add({"<space>ta", group = "Animation"})
wk.add({"<space>f", group = "Format", mode = {"x", "v"}})
wk.add({"<space>fb", group = "Base64", mode = {"x", "v"}})
local function _7_()
  vim.bo.modifiable = not vim.bo.modifiable
  return nil
end
kset("n", "<space>tm", _7_, "Modifiable")
local function _8_()
  vim.o.list = not vim.o.list
  return nil
end
kset("n", "<space>ti", _8_, "List invisible chars")
local function _9_()
  nvim.g.neovide_fullscreen = not nvim.g.neovide_fullscreen
  return nil
end
kset("n", "<space>tf", _9_, "Full screen")
local function _10_()
  vim.o.relativenumber = not vim.o.relativenumber
  return nil
end
kset("n", "<space>tr", _10_, "Relative Numbers")
kset("n", "<space>tR", "mZ:Bd!<cr>`Z", "Refresh file")
kset("n", "<space>ta1", "<cmd>CellularAutomaton make_it_rain<CR>", "Rain")
kset("n", "<space>ta2", "<cmd>CellularAutomaton game_of_life<CR>", "Game")
kset("n", "<space>ta3", "<cmd>CellularAutomaton scramble<CR>", "Scramble")
kset("x", "<space>fj", "!jq<cr>", "Json")
kset("x", "<space>fp", "!pg_format -s 2<cr>", "pSQL")
kset("x", "<space>fc", "<Esc>:ReplaceSelection tocamel<Cr>", "CamelCase")
kset("x", "<space>fs", "<Esc>:ReplaceSelection tosnake<Cr>", "snake_case")
kset("x", "<space>fk", "<Esc>:ReplaceSelection tokebab<Cr>", "kebab-case")
kset("x", "<space>f8", "<Esc>:set tw=80<Cr>gvgq", "80 width")
kset("x", "<space>fbe", "c<c-r>=system('base64', @\")[:-2]<cr><c-\\><c-n>", "Encode")
kset("x", "<space>fbd", "c<c-r>=system('base64 --decode', @\")[:-1]<cr><c-\\><c-n>", "Decode")
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
  local f = _12_["args"]
  local _let_13_ = get_word_under_selection()
  local word = _let_13_[1]
  local sr = _let_13_[2]
  local sc = _let_13_[3]
  local er = _let_13_[4]
  local ec = _let_13_[5]
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
return vim.api.nvim_create_user_command("ReplaceSelection", replace_selection, {nargs = 1, desc = "Replace selected word with result function"})
