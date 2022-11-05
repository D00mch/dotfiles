(module plugin.lspconfig
  {autoload {nvim aniseed.nvim
             lsp lspconfig
             {: kset : bkset} util
             telescope  telescope
             {: assoc : update} aniseed.core
             {: lsp_references : lsp_implementations} telescope.builtin
             flut flutter-tools
             mason mason
             preview goto-preview
             cmplsp cmp_nvim_lsp}})

(def- map nvim.buf_set_keymap)

;preview
(preview.setup {:height 25
                :bufhidden :wipe
                :post_open_hook (fn [] (nvim.echo (vim.fn.expand "%:p")))})
(kset [:n] :<leader>d "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")

(mason.setup)
;(installer.setup {:ensure_installed [:clojure_lsp :jdtls :kotlin_language_server]})

(vim.diagnostic.config {:float {:source true}})

(set vim.o.updatetime 250)

(defn highlight-line-symbol []
  ;; highlight line number instead of having icons in sigh column
  (vim.cmd "
    highlight! DiagnosticLineNrError guibg=#51202A guifg=#FF0000 gui=bold
    highlight! DiagnosticLineNrWarn guibg=#51412A guifg=#FFA500 gui=bold
    highlight! DiagnosticLineNrInfo guibg=#1E535D guifg=#00FFFF gui=bold
    highlight! DiagnosticLineNrHint guibg=#1E205D guifg=#0000FF gui=bold
    sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
    sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
    sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
    sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint"))

(defn- highlight-symbols [client bufnr]
  (when client.server_capabilities.documentHighlightProvider
    (highlight-line-symbol)
    (vim.api.nvim_create_autocmd :ColorScheme {:buffer bufnr :callback highlight-line-symbol})
    (vim.cmd "hi! link LspReferenceWrite TSConstMacro")
    (vim.api.nvim_create_augroup :lsp_document_highlight {})
    (vim.api.nvim_create_autocmd [:CursorHold :CursorHoldI]
                                 {:group :lsp_document_highlight
                                  :buffer bufnr
                                  :callback vim.lsp.buf.document_highlight})
    (vim.api.nvim_create_autocmd :CursorMoved
                                 {:group :lsp_document_highlight
                                  :buffer bufnr
                                  :callback vim.lsp.buf.clear_references})))

(let [handlers {"textDocument/publishDiagnostics"
                (vim.lsp.with
                  vim.lsp.diagnostic.on_publish_diagnostics
                  {:severity_sort true
                   :update_in_insert false
                   :underline true
                   :signs true
                   :virtual_text false})
                "textDocument/hover"
                (vim.lsp.with
                  vim.lsp.handlers.hover
                  {:border "single"})
                "textDocument/signatureHelp"
                (vim.lsp.with
                  vim.lsp.handlers.signature_help
                  {:border "single"})}
      on_attach
      (fn [client b]
        (highlight-symbols client b)
        (bkset :n :gd (fn  [] (vim.lsp.buf.definition)) b)
        (bkset :n
               :<leader>h
               (fn [] (vim.lsp.buf.hover) (vim.lsp.buf.hover))
               b)
        (bkset :n :<leader>gD (fn [] (vim.lsp.buf.declaration)) b)
        (bkset :n :<leader>tD (fn [] (vim.lsp.buf.type_definition)) b)
        (bkset [:i :n] :… (fn [] (vim.lsp.buf.signature_help)) b) ; alt+;
        (bkset :n :<leader>rr (fn [] (vim.lsp.buf.rename)) b)
        (bkset :n :<leader>a (fn [] (vim.diagnostic.open_float)))
        (bkset :n :<leader>re (fn [] (vim.diagnostic.setloclist)))
        (bkset :n :<leader>r= (fn [] (vim.lsp.buf.formatting)) b)
        (bkset :n "]s" (fn [] (vim.diagnostic.goto_next)) b)
        (bkset :n "[s" (fn [] (vim.diagnostic.goto_prev)) b)
        (bkset :n :<tab> (fn [] (vim.diagnostic.goto_next)) b)
        (bkset :n :<S-tab> (fn [] (vim.diagnostic.goto_prev)) b)
        ;; TELESCOPE
        (bkset :n :∫ (fn [] (lsp_references))) ; alt+b
        (bkset :n :ˆ (fn [] (lsp_implementations))) ; alt+i
        (bkset [:n :x] :® (fn [] (vim.lsp.buf.code_action)) b) ;; alt+r
        (bkset [:n :x] :<leader>ra (fn [] (vim.lsp.buf.code_action)) b))
      default-map {:on_attach on_attach
                   :handlers handlers
                   :capabilities (cmplsp.default_capabilities)}]

  (lsp.clojure_lsp.setup default-map)
  (lsp.jdtls.setup default-map)
  (lsp.kotlin_language_server.setup default-map)
  (lsp.racket_langserver.setup default-map)
  (lsp.ltex.setup (assoc default-map
                         :filetypes ["markdown" "NeogitCommitMessage"]))

  (flut.setup
    {:lsp
     {:closing_tags {:highlight "ErrorMsg"
                     :prefix ">"
                     :enabled true}
      :handlers handlers
      :capabilities capabilities
      :on_attach
      (fn [client b]
        (on_attach client b)
        (bkset [:n] :<leader>fa (fn [] (telescope.extensions.flutter.commands)) b)
        (telescope.load_extension "flutter"))}}))
