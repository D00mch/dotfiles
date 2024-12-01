-- [nfnl] Compiled from fnl/plugins/lsp_glance.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local _let_2_ = require("config.util")
  local kset = _let_2_["kset"]
  return kset("n", "<D-b>", "mZg*`Z:Glance references<Cr>", {desc = "Show refs (Idea)"})
end
local function _3_()
  local glance = require("glance")
  return glance.setup({mappings = {list = {gh = glance.actions.enter_win("preview"), ["<left>"] = glance.actions.preview_scroll_win(5), ["<right>"] = glance.actions.preview_scroll_win(-5)}, preview = {gl = glance.actions.enter_win("list")}}, border = {enable = true}, height = 25})
end
return {{"DNLHC/glance.nvim", lazy = true, ft = {"clojure", "go", "dart", "markdown", "md"}, cmd = {"LspInfo", "LspInstall", "LspUninstall"}, init = _1_, config = _3_}}
