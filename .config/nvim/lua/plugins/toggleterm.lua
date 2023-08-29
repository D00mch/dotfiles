-- [nfnl] Compiled from fnl/plugins/toggleterm.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local _let_2_ = require("config.util")
  local kset = _let_2_["kset"]
  kset("x", "<leader>q", ":ToggleTermSendVisualSelection<cr>")
  kset("x", "\226\136\154", "<leader>v", {remap = true})
  kset("n", "<leader>e", "vip<leader>q", {remap = true})
  kset("t", "<D-w>", "<C-\\><C-n>:hide<Cr>", {remap = true})
  kset("t", "<D-v>", "<Esc>pa")
  kset("t", "<D-Esc>", "<C-\\><C-n>")
  return kset("t", "<D-c>", "<C-c>")
end
local function _3_()
  local term = require("toggleterm")
  local function _4_(t)
    if (vim.fn.mode() == "n") then
      return vim.cmd("startinsert!")
    else
      return nil
    end
  end
  return term.setup({size = 30, on_open = _4_, open_mapping = "<space>8", hide_numbers = true, shading_factor = 2, start_in_insert = true, direction = "horizontal", persist_size = true, terminal_mappings = false, insert_mappings = false, shade_terminals = false})
end
return {{"akinsho/toggleterm.nvim", init = _1_, config = _3_}}
