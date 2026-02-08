-- [nfnl] fnl/plugins/lsp_config.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = autoload("config.util")
local on_attach_util = _local_2_["on-attach"]
local highlight_line_symbol = _local_2_["highlight-line-symbol"]
local _local_3_ = autoload("nfnl.core")
local merge = _local_3_.merge
local diagnostics = {severity_sort = true, underline = true, signs = true, update_in_insert = false, virtual_lines = false, virtual_text = false}
local handlers = {["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "single"}), ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "single"})}
local function _4_()
  vim.o.updatetime = 250
  return nil
end
local function _5_()
  local lsp = vim.lsp.config
  local cmplsp = require("cmp_nvim_lsp")
  local mason = require("mason")
  local illuminate = require("illuminate")
  local ltex = require("ltex_extra")
  local on_attach
  local function _6_(client, b)
    client.server_capabilities.semanticTokensProvider = nil
    return on_attach_util(client, b)
  end
  on_attach = _6_
  local capabilities = cmplsp.default_capabilities()
  local before_init
  local function _7_(params)
    params.workDoneToken = "1"
    return nil
  end
  before_init = _7_
  local default_map = {on_attach = on_attach, before_init = before_init, handlers = handlers, capabilities = cmplsp.default_capabilities()}
  vim.diagnostic.config(diagnostics)
  capabilities.textDocument.foldingRange = {lineFoldingOnly = true, dynamicRegistration = false}
  mason.setup()
  illuminate.configure()
  local function _8_(client, b)
    on_attach(client, b)
    return highlight_line_symbol()
  end
  lsp("fennel_language_server", merge(default_map, {settings = {fennel = {workspace = {library = vim.api.nvim_list_runtime_paths()}, diagnostics = {globals = {"vim", "jit", "comment"}}}}, filetypes = {"fennel"}, cmd = {(vim.fn.stdpath("data") .. "/mason/bin/fennel-language-server")}, single_file_support = true, root_markers = {".git", "fnl", "lua"}, on_attach = _8_}))
  lsp("clojure_lsp", default_map)
  lsp("jdtls", default_map)
  lsp("kotlin_lsp", merge(default_map, {autostart = false}))
  lsp("vtsls", default_map)
  lsp("emmet_language_server", merge({filetypes = {"css", "html", "javascript", "typescript", "typescriptreact", "javascriptreact", "svelte", "vue", "vue-html", "less", "scss", "sass", "sas"}}))
  local function _9_(client, b)
    on_attach(client, b)
    ltex.setup({load_langs = {"en-US"}, init_check = true, path = (vim.fn.expand("~") .. "/.config/nvim/data/ltex"), log_level = "debug"})
    return highlight_line_symbol()
  end
  lsp("ltex", merge(default_map, {on_attach = _9_, filetypes = {"markdown", "NeogitCommitMessage", "gitcommit"}, settings = {ltex = {}}}))
  return vim.lsp.enable({"fennel_language_server", "clojure_lsp", "jdtls", "kotlin_lsp", "vtsls", "emmet_language_server", "ltex"})
end
return {{"neovim/nvim-lspconfig", ft = {"clojure", "go", "dart", "markdown", "md", "fennel"}, cmd = {"LspInfo", "LspInstall", "LspUninstall", "LspStart"}, dependencies = {"mason-org/mason.nvim", "barreiroleo/ltex-extra.nvim", "RRethy/vim-illuminate", "nvim-lua/plenary.nvim"}, init = _4_, config = _5_, lazy = false}}
