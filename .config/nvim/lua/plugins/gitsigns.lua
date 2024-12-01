-- [nfnl] Compiled from fnl/plugins/gitsigns.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local bkset = _local_2_["bkset"]
local vis_op = _local_2_["vis-op"]
local function _3_()
  local gs = require("gitsigns")
  local gitsigns
  local function gitsigns0()
    gs.toggle_linehl()
    return gs.toggle_word_diff()
  end
  gitsigns = gitsigns0
  local function _4_(b)
    local function _5_()
      return vim.schedule(gs.next_hunk)
    end
    bkset("n", "gn", _5_, {buffer = b, desc = "Gitsigns next"})
    local function _6_()
      return vim.schedule(gs.prev_hunk)
    end
    bkset("n", "gN", _6_, {buffer = b, desc = "Gitsigns prev"})
    bkset("n", "gs", gs.stage_hunk, {buffer = b, desc = "Gitsigns stage hunk"})
    bkset("x", "gs", vis_op(gs.stage_hunk), {buffer = b, desc = "Gitsigns stage hunk"})
    bkset("n", "gus", gs.undo_stage_hunk, {buffer = b, desc = "Gitsigns undo staged"})
    local function _7_()
      return vim.schedule(gs.stage_buffer)
    end
    bkset("n", "<Space>gS", _7_, {buffer = b, desc = "Gitsigns stage buffer"})
    bkset("n", "<Space>gr", gs.reset_hunk, {buffer = b, desc = "Gitsigns reset hunk"})
    bkset("x", "<Space>gr", vis_op(gs.reset_hunk), {buffer = b, desc = "Gitsigns reset hunk"})
    local function _8_()
      return gs.blame_line({full = true})
    end
    bkset("n", "<Space>gm", _8_, {buffer = b, desc = "Gitsigns blame message"})
    local function _9_()
      return gs.toggle_current_line_blame()
    end
    bkset("n", "<Space>gl", _9_, {buffer = b, desc = "Gitsigns blame line"})
    bkset("n", "<Space>gd", gs.diffthis, {buffer = b, desc = "Gitsigns diff"})
    bkset("n", "<Space>tg", gitsigns, "gitsigns")
    return bkset("n", "<Space>gt", gitsigns, "gitsigns")
  end
  return gs.setup({numhl = true, current_line_blame_opts = {overlay = true, delay = 1000}, on_attach = _4_, signcolumn = false})
end
return {{"lewis6991/gitsigns.nvim", lazy = true, event = "VeryLazy", config = _3_}}
