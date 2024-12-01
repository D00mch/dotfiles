-- [nfnl] Compiled from fnl/plugins/lsp_preview.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local bkset = _local_2_["bkset"]
local function _3_()
  local preview = require("goto-preview")
  local close_and_move_focus_on_prev
  local function _4_()
    local prev_win = vim.fn.winnr()
    vim.cmd("wincmd p")
    return vim.cmd((prev_win .. "wincmd q"))
  end
  close_and_move_focus_on_prev = _4_
  local function _5_(b, _)
    bkset("n", "<D-w>", close_and_move_focus_on_prev, {buffer = b})
    return nvim.echo(vim.fn.expand("%:p"))
  end
  preview.setup({height = 25, bufhidden = "wipe", post_open_hook = _5_})
  return kset({"n"}, "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
end
return {{"rmagatti/goto-preview", lazy = true, ft = {"clojure", "go", "dart", "markdown", "md"}, cmd = {"LspInfo", "LspInstall", "LspUninstall"}, config = _3_}}
