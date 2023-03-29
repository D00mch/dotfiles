(module plugin.ufo
  {require {nvim aniseed.nvim
            lsp-util lspconfig.util
            lspconfig lspconfig
            ufo ufo
            {: kset} util}})

;; Common

(kset :n :zR ufo.openAllFolds)
(kset :n :zM ufo.closeAllFolds)

(set vim.o.foldcolumn :0)
(set vim.o.fillchars "eob: ,fold: ,foldopen:,foldsep: ,foldclose:")

(set vim.o.foldlevel 99)
(set vim.o.foldlevelstart 99)
(set vim.o.foldenable true)

(defn handler [virt-text lnum end-lnum width truncate]
  (let [new-virt-text {}]
    (var suffix (: "  %d " :format (- end-lnum lnum)))
    (local suf-width (vim.fn.strdisplaywidth suffix))
    (local target-width (- width suf-width))
    (var cur-width 0)
    (each [_ chunk (ipairs virt-text)]
      (var chunk-text (. chunk 1))
      (var chunk-width (vim.fn.strdisplaywidth chunk-text))
      (if (> target-width (+ cur-width chunk-width))
        (table.insert new-virt-text chunk)
        (do
          (set chunk-text (truncate chunk-text (- target-width cur-width)))
          (local hl-group (. chunk 2))
          (table.insert new-virt-text [chunk-text hl-group])
          (set chunk-width (vim.fn.strdisplaywidth chunk-text))
          (when (< (+ cur-width chunk-width) target-width)
            (set suffix
                 (.. suffix
                     (: " " :rep (- (- target-width cur-width) chunk-width)))))
          (lua :break)))
      (set cur-width (+ cur-width chunk-width)))
    (table.insert new-virt-text [suffix :MoreMsg])
    new-virt-text))	

;; LSP
(def language-servers (lsp-util.available_servers))
(def capabilities (vim.lsp.protocol.make_client_capabilities))

(set capabilities.textDocument.foldingRange
     {:dynamicRegistration false
      :lineFoldingOnly true})

(ufo.setup
  {:fold_virt_text_handler handler})

;; Treesitter
; (ufo.setup
;   {:provider_selector (fn [bufnr filetype buftype]
;                         [:treesitter :indent])})
