-- [nfnl] Compiled from fnl/plugins/cmp.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("nfnl.core")
local merge = _local_2_["merge"]
local telescope = autoload("telescope")
local cmp_src_menu_items = {buffer = "buff", conjure = "conj", path = "path", nvim_lsp = "lsp"}
local cmp_srcs = {{name = "nvim_lsp"}, {name = "conjure"}, {name = "buffer"}, {name = "path"}, {name = "spell"}, {name = "cmp-dbee"}, {name = "codeium"}, {name = "snippy"}}
local function has_words_before()
  local _let_3_ = vim.api.nvim_win_get_cursor(0)
  local line = _let_3_[1]
  local col = _let_3_[2]
  local function _4_()
    local line0 = vim.api.nvim_get_current_line()
    local behind = line0:sub(col, col)
    return (behind:match("%s") == nil)
  end
  return ((col ~= 0) and _4_())
end
local function _5_()
  local cmp = require("cmp")
  local snippy = require("snippy")
  local snippy_tab
  local function _6_(fallback)
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
  snippy_tab = _6_
  local function _8_(entry, item)
    item.menu = (cmp_src_menu_items[entry.source.name] or "")
    return item
  end
  local function _9_(args)
    return snippy.expand_snippet(args.body)
  end
  cmp.setup({formatting = {format = _8_}, preselect = cmp.PreselectMode.None, complete = {completeopt = "menu,menuone"}, mapping = {["<Tab>"] = cmp.mapping(snippy_tab, {"i", "s"}), ["<S-Tab>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), ["<down>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), ["<up>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), ["<left>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {"i", "c"}), ["<right>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {"i", "c"}), ["<C-Space>"] = cmp.mapping.complete(), ["<C-e>"] = cmp.mapping.close(), ["<CR>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false})}, sources = cmp_srcs, confirm_opts = {behavior = cmp.ConfirmBehavior.Replace, select = false}, snippet = {expand = _9_}})
  cmp.setup.cmdline("/", {mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({{name = "buffer", max_item_count = 18}})})
  return cmp.setup.cmdline(":", {mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({{name = "cmdline", max_item_count = 18}, {name = "path", max_item_count = 12}})})
end
return {{"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "f3fora/cmp-spell", "PaterJason/cmp-conjure", "dcampos/cmp-snippy", "dcampos/nvim-snippy", {"MattiasMTS/cmp-dbee", ft = "sql"}}, config = _5_}}
