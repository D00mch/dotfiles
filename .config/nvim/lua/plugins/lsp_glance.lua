-- [nfnl] fnl/plugins/lsp_glance.fnl
local function _1_()
  local _let_2_ = require("config.util")
  local kset = _let_2_.kset
  return kset("n", "<D-b>", "mZg*`Z:Glance references<Cr>", {desc = "Show refs (Idea)"})
end
local function _3_()
  local glance = require("glance")
  local config = require("glance.config")
  local resize_preview
  local function _4_()
    config.options.height = math.max(1, math.floor((vim.o.lines * 0.7)))
    return nil
  end
  resize_preview = _4_
  glance.setup({mappings = {list = {gh = glance.actions.enter_win("preview"), ["<left>"] = glance.actions.preview_scroll_win(5), ["<right>"] = glance.actions.preview_scroll_win(-5)}, preview = {gl = glance.actions.enter_win("list")}}, border = {enable = true}})
  resize_preview()
  return vim.api.nvim_create_autocmd("VimResized", {group = vim.api.nvim_create_augroup("GlancePreviewHeight", {clear = true}), callback = resize_preview})
end
return {{"DNLHC/glance.nvim", lazy = true, ft = {"clojure", "go", "dart", "markdown", "md"}, cmd = {"LspInfo", "LspInstall", "LspUninstall"}, init = _1_, config = _3_}}
