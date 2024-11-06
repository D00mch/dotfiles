-- [nfnl] Compiled from fnl/plugins/basic.fnl by https://github.com/Olical/nfnl, do not edit.
local pc_with_rights_3f = os.getenv("OPENAI_API_KEY")
local function _1_()
  local fundo = require("fundo")
  return fundo.install()
end
return {{"bakpakin/fennel.vim", lazy = true, ft = {"fennel"}}, {"nvim-tree/nvim-web-devicons", config = true}, {"windwp/nvim-autopairs", opts = {disable_filetype = {"clojure", "scheme", "lisp", "timl", "fennel", "janet", "racket"}}, config = true}, {"tpope/vim-repeat"}, {"jghauser/follow-md-links.nvim", lazy = true, ft = {"markdown"}}, {"vim-scripts/ReplaceWithRegister"}, {"tpope/vim-sleuth"}, {"eandrju/cellular-automaton.nvim"}, {"famiu/bufdelete.nvim"}, {"kwkarlwang/bufresize.nvim", config = true}, {"tpope/vim-commentary"}, {"kevinhwang91/nvim-fundo", dependencies = {"kevinhwang91/promise-async"}, build = _1_, opts = {}, config = true}, {"folke/which-key.nvim", lazy = true, opts = {plugins = {spelling = {suggestions = 12, enabled = false}}, keys = {scroll_down = "<right>", scroll_up = "<left>"}}, config = true}, {"Exafunction/codeium.nvim", lazy = not pc_with_rights_3f, config = true}}
