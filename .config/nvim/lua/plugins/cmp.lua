-- [nfnl] Compiled from fnl/plugins/cmp.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("nfnl.core")
local merge = _local_2_["merge"]
local telescope = autoload("telescope")
local cmp_src_menu_items = {buffer = "buff", conjure = "conj", path = "path", nvim_lsp = "lsp"}
local cmp_srcs = {{name = "nvim_lsp"}, {name = "conjure"}, {name = "buffer"}, {name = "path"}, {name = "spell"}, {name = "cmp-dbee"}, {name = "codeium"}, {name = "snippy"}}
local kind_icons = {Class = "\243\176\160\177", Color = "\243\176\143\152", Constant = "\243\176\143\191", Constructor = "\239\144\163", Enum = "\239\133\157", EnumMember = "\239\133\157", Event = "\239\131\167", Field = "\243\176\135\189", File = "\243\176\136\153", Folder = "\243\176\137\139", Function = "\243\176\138\149", Interface = "\239\131\168", Keyword = "\243\176\140\139", Method = "\243\176\134\167", Module = "\239\146\135", Operator = "\243\176\134\149", Property = "\243\176\156\162", Reference = "\239\146\129", Snippet = "\239\145\143", Struct = "\239\134\179", Text = "\243\176\173\183", TypeParameter = "\243\176\133\178", Unit = "\238\136\159", Value = "\243\176\142\160", Variable = "\243\176\130\161", Conj = "\238\154\176", Codeium = "\239\131\144"}
local function has_words_before()
  local _let_3_ = vim.api.nvim_win_get_cursor(0)
  local line = _let_3_[1]
  local col = _let_3_[2]
  local and_4_ = (col ~= 0)
  if and_4_ then
    local line0 = vim.api.nvim_get_current_line()
    local behind = line0:sub(col, col)
    and_4_ = (behind:match("%s") == nil)
  end
  return and_4_
end
local function _6_()
  local cmp = require("cmp")
  local snippy = require("snippy")
  local snippy_tab
  local function _7_(fallback)
    if cmp.visible() then
      return cmp.select_next_item()
    elseif snippy.can_expand_or_advance() then
      return snippy.expand_or_advance()
    elseif has_words_before() then
      return cmp.complete()
    else
      return fallback()
    end
  end
  snippy_tab = _7_
  local function _9_(entry, item)
    item.kind = string.format("%s %s", kind_icons[item.kind], item.kind)
    item.menu = (cmp_src_menu_items[entry.source.name] or "")
    return item
  end
  local function _10_(args)
    return snippy.expand_snippet(args.body)
  end
  cmp.setup({formatting = {format = _9_}, preselect = cmp.PreselectMode.None, complete = {completeopt = "menu,menuone"}, mapping = {["<Tab>"] = cmp.mapping(snippy_tab, {"i", "s"}), ["<S-Tab>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), ["<down>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), ["<up>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), ["<left>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {"i", "c"}), ["<right>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {"i", "c"}), ["<C-Space>"] = cmp.mapping.complete(), ["<C-e>"] = cmp.mapping.close(), ["<CR>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false})}, sources = cmp.config.sources(cmp_srcs), confirm_opts = {behavior = cmp.ConfirmBehavior.Replace, select = false}, snippet = {expand = _10_}})
  cmp.setup.filetype("oil", {sources = cmp.config.sources({{name = "buffer"}, {name = "path"}})})
  cmp.setup.cmdline("/", {mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({{name = "buffer", max_item_count = 18}})})
  return cmp.setup.cmdline(":", {mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({{name = "cmdline", max_item_count = 18}, {name = "path", max_item_count = 12}})})
end
return {{"hrsh7th/nvim-cmp", event = "InsertEnter", lazy = true, dependencies = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "f3fora/cmp-spell", "PaterJason/cmp-conjure", "dcampos/cmp-snippy", "dcampos/nvim-snippy", {"MattiasMTS/cmp-dbee", ft = "sql"}}, config = _6_}}
