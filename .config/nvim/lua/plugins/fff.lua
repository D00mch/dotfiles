-- [nfnl] fnl/plugins/fff.fnl
local function _1_()
  return require("fff.download").download_or_build_binary()
end
local function _2_()
  return require("fff").find_in_git_root()
end
return {"dmtrKovalenko/fff.nvim", build = _1_, keys = {{"ff", _2_, desc = "FFFind files"}}, opts = {debug = {enabled = true, show_scores = true}}, lazy = false}
