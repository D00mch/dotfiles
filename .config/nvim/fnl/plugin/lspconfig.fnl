(module plugin.lspconfig
  {autoload {nvim aniseed.nvim
             lsp lspconfig
             util util
             tel  telescope
             flut flutter-tools
             cmplsp cmp_nvim_lsp}})

(def- map nvim.buf_set_keymap)

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

(defn- highlight-symbols [client]
  (if client.resolved_capabilities.document_highlight
    (do 
      (highlight-line-symbol)
      (vim.api.nvim_create_autocmd :ColorScheme {:buffer 0 :callback highlight-line-symbol})
      (vim.cmd "hi! link LspReferenceWrite TSConstMacro")
      (vim.api.nvim_create_augroup :lsp_document_highlight {})
      (vim.api.nvim_create_autocmd [:CursorHold :CursorHoldI]
                                   {:group :lsp_document_highlight
                                    :buffer 0
                                    :callback vim.lsp.buf.document_highlight})
      (vim.api.nvim_create_autocmd :CursorMoved
                                   {:group :lsp_document_highlight
                                    :buffer 0
                                    :callback vim.lsp.buf.clear_references}))))

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
      capabilities (cmplsp.update_capabilities
                     (vim.lsp.protocol.make_client_capabilities))
      on_attach
      (fn [client bufnr]
        (highlight-symbols client)
        (map bufnr :n :gd "<Cmd>lua vim.lsp.buf.definition()<CR>" {:noremap true})
        (map bufnr :n :<leader>hh "<Cmd>lua vim.lsp.buf.hover()<CR>" {:noremap true})
        (map bufnr :n :<leader>gD "<Cmd>lua vim.lsp.buf.declaration()<CR>" {:noremap true})
        ;(map bufnr :n :<leader>tD "<cmd>lua vim.lsp.buf.type_definition()<CR>" {:noremap true})
        (map bufnr :n :<leader>hs "<cmd>lua vim.lsp.buf.signature_help()<CR>" {:noremap true})
        (map bufnr :n :<leader>rr "<cmd>lua vim.lsp.buf.rename()<CR>" {:noremap true})
        (map bufnr :n :<leader>rs "<cmd>lua vim.diagnostic.open_float()<CR>" {:noremap true})
        (map bufnr :n :<leader>re "<cmd>lua vim.diagnostic.setloclist()<CR>" {:noremap true})
        (map bufnr :n :<leader>r= "<cmd>lua vim.lsp.buf.formatting()<CR>" {:noremap true})
        (map bufnr :n "]s" "<cmd>lua vim.diagnostic.goto_next()<CR>" {:noremap true})
        (map bufnr :n "[s" "<cmd>lua vim.diagnostic.goto_prev()<CR>" {:noremap true})
        ;telescope
        (map bufnr :n :<leader>ra "<cmd>lua vim.lsp.buf.code_action()<CR>" {:noremap true})
        (map bufnr :n :® :<leader>ra {:noremap false})
        (map bufnr :v :<leader>ra "<cmd>lua vim.lsp.buf.range_code_action()<CR>" {:noremap true})
        (map bufnr :n :<leader>fu ":lua require('telescope.builtin').lsp_references()<cr>" {:noremap true})
        (map bufnr :n :∫ :<leader>fu {:noremap false}))]

  (lsp.clojure_lsp.setup
    {:on_attach on_attach
     :handlers handlers
     :capabilities capabilities})

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
        (map b :n :<leader>fa
             ":lua require('telescope').extensions.flutter.commands()<cr>"
             {:noremap true})
        (tel.load_extension "flutter"))}}))
