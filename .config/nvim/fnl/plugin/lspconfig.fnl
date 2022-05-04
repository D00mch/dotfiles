(module plugin.lspconfig
  {autoload {nvim aniseed.nvim
             lsp lspconfig
             util util
             tel  telescope
             flut flutter-tools
             cmplsp cmp_nvim_lsp}})

(def- map nvim.buf_set_keymap)

(vim.diagnostic.config {:float {:source true}})

(let [handlers {"textDocument/publishDiagnostics"
                (vim.lsp.with
                  vim.lsp.diagnostic.on_publish_diagnostics
                  {:severity_sort true
                   :update_in_insert false
                   :underline true
                   :signs false
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
