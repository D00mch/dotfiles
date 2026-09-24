-- [nfnl] fnl/plugins/neogit.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local function neogit_toggle()
  local current_dir = vim.fn.expand("%")
  local in_git_3f = string.match(current_dir, "NeogitStatus$")
  local diff_view_3f = string.match(current_dir, "^diffview://")
  local function _3_()
    if diff_view_3f then
      return "tabc"
    elseif in_git_3f then
      return "bd"
    else
      return "Neogit"
    end
  end
  return vim.api.nvim_command(_3_())
end
local function describe_status_keys(buf)
  if vim.api.nvim_buf_is_valid(buf) then
    local function _4_()
      local wk = require("which-key")
      local mappings = require("neogit.config").values.mappings
      local labels = {Depth1 = "Fold section", Depth2 = "Show files in section", Depth3 = "Show hunk headers in section", Depth4 = "Show all changes in section", Toggle = "Toggle fold", Command = "Run Git command", VSplitOpen = "Open in vertical split"}
      for key, action in pairs(vim.tbl_extend("force", mappings.popup, mappings.status, {V = "Select lines"})) do
        if (type(action) == "string") then
          for _, mode in ipairs({"n", "x"}) do
            if (vim.fn.maparg(key, mode, false, true).buffer == 1) then
              wk.add({{key, buffer = buf, mode = mode, desc = (labels[action] or action:gsub("(%l)(%u)", "%1 %2"))}})
            else
            end
          end
        else
        end
      end
      return wk.add({{"<nop>", buffer = buf, mode = {"n", "x"}, hidden = true}})
    end
    return vim.api.nvim_buf_call(buf, _4_)
  else
    return nil
  end
end
local function _8_()
  return kset({"n", "x"}, "<Space>o", neogit_toggle, "Toggle NeoGit")
end
local function _9_(_, opts)
  require("neogit").setup(opts)
  local function _11_(_10_)
    local buf = _10_.buf
    local function _12_()
      return describe_status_keys(buf)
    end
    return vim.schedule(_12_)
  end
  return vim.api.nvim_create_autocmd("FileType", {pattern = "NeogitStatus", group = vim.api.nvim_create_augroup("NeogitKeyDescriptions", {clear = true}), callback = _11_})
end
return {{"NeogitOrg/neogit", dependencies = {"nvim-lua/plenary.nvim"}, init = _8_, cmd = "Neogit", lazy = true, opts = {kind = "split", integrations = {diffview = true, telescope = true}, disable_commit_confirmation = true, sections = {untracked = {folded = true}, recent = {folded = true}}, mappings = {status = {o = "Toggle", gr = "Reverse", ["-"] = false, q = false, v = false}, popup = {b = false, j = false, l = false, v = false}, rebase_editor = {b = false, d = false, e = false, f = false, p = false, q = false, r = false, s = false, x = false}}}, config = _9_}}
