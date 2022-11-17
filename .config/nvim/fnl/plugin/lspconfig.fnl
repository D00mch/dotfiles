(module plugin.lspconfig
  {autoload {nvim aniseed.nvim
             lsp lspconfig
             refs nice-reference
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
        (bkset :n
               :<leader>h
               (fn [] (vim.lsp.buf.hover) (vim.lsp.buf.hover))
               {:buffer b :desc "Show docs"})
        (bkset :n :gd vim.lsp.buf.definition {:buffer b :desc "Go definition"})
        (bkset :n :gD "<c-w><c-]><c-w>T" {:buffer b :desc "Go definition new tab"})
        (bkset :n :<leader>tD vim.lsp.buf.type_definition {:buffer b :desc "Type definition"})
        (bkset [:i :n] :… vim.lsp.buf.signature_help {:buffer b :desc "Signiture help"}) ; alt+;
        (bkset :n :<leader>rr vim.lsp.buf.rename {:buffer b :desc "Rename"})
        (bkset :n :<leader>a vim.diagnostic.open_float {:buffer b :desc "Show diantostics"})
        (bkset :n :<leader>re vim.diagnostic.setloclist {:buffer b :desc "List diagnostics"})
        (bkset :n :<leader>r= vim.lsp.buf.formatting {:buffer b :desc "Apply formatting"})
        (bkset :n "]s" vim.diagnostic.goto_next {:buffer b :desc "Goto next erro"})
        (bkset :n "[s" vim.diagnostic.goto_prev {:buffer b :desc "Goto prev erro"})
        (bkset :n :<tab> vim.diagnostic.goto_next {:buffer b :desc "Goto next erro"})
        (bkset :n :<S-tab> vim.diagnostic.goto_prev {:buffer b :desc "Goto prev erro"})
        (bkset :n :∫ refs.references {:buffer b :desc "Show refs (Idea)"}) ; alt+b
        ;; TELESCOPE
        (bkset :n :<leader>gr lsp_references {:buffer b :desc "Go to references"}) ; alt+b
        (bkset :n :ˆ lsp_implementations {:buffer b :desc "Go to implementations"}) ; alt+i
        (bkset [:n :x] :<C-r> vim.lsp.buf.code_action {:buffer b :desc "Code actions"})
        (bkset [:n :x] :<leader>ra vim.lsp.buf.code_action {:buffer b :desc "Code actions"}))
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
