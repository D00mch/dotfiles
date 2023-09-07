-- [nfnl] Compiled from .config/nvim/fnl/plugins/toggleterm.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("config.util")
local kset = _local_1_["kset"]
local function _2_()
  return (require("toggleterm")).toggle()
end
kset("n", "<Space>8", _2_)
local function _3_()
  local _let_4_ = require("config.util")
  local kset0 = _let_4_["kset"]
  kset0("x", "<leader>q", ":ToggleTermSendVisualSelection<cr>")
  kset0("x", "\226\136\154", "<leader>v", {remap = true})
  kset0("n", "<leader>e", "vip<leader>q", {remap = true})
  kset0("t", "<D-w>", "<C-\\><C-n>:hide<Cr>", {remap = true})
  kset0("t", "<D-v>", "<Esc>pa")
  kset0("t", "<D-Esc>", "<C-\\><C-n>")
  return kset0("t", "<D-c>", "<C-c>")
end
local function _5_()
  local term = require("toggleterm")
  local function _6_(t)
    if (vim.fn.mode() == "n") then
      return vim.cmd("startinsert!")
    else
      return nil
    end
  end
  return term.setup({size = 30, on_open = _6_, open_mapping = "<space>8", hide_numbers = true, shading_factor = 2, start_in_insert = true, direction = "horizontal", persist_size = true, terminal_mappings = false, insert_mappings = false, shade_terminals = false})
end
return {{"akinsho/toggleterm.nvim", lazy = true, cmd = {"ToggleTerm", "ToggleTermSendVisualSelection"}, init = _3_, config = _5_}}
