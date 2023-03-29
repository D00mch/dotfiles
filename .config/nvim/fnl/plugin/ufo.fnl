(module plugin.ufo
  {require {nvim aniseed.nvim
            lsp-util lspconfig.util
            lspconfig lspconfig
            ufo ufo
            {: kset} util}})

;; Common

(kset :n :zR ufo.openAllFolds)
(kset :n :zM ufo.closeAllFolds)

(set vim.o.foldcolumn :1)
(set vim.o.foldlevel 99)
(set vim.o.foldlevelstart 99)
(set vim.o.foldenable true)

;; LSP
(def language-servers (lsp-util.available_servers))
(def capabilities (vim.lsp.protocol.make_client_capabilities))

(set capabilities.textDocument.foldingRange
     {:dynamicRegistration false
      :lineFoldingOnly true})

(each [_ ls (ipairs language-servers)]
  ((. (. lspconfig ls) :setup)
   {: capabilities}))

(ufo.setup)

;; Treesitter
; (ufo.setup
;   {:provider_selector (fn [bufnr filetype buftype]
;                         [:treesitter :indent])})
