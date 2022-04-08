(module plugin.lspconfig
  {autoload {nvim aniseed.nvim
             lsp lspconfig
             util util
             cmplsp cmp_nvim_lsp}})

(def- map nvim.buf_set_keymap)

;symbols to show for lsp diagnostics
(defn define-signs
  [prefix]
  (let [error (.. prefix "SignError")
        warn  (.. prefix "SignWarn")
        info  (.. prefix "SignInfo")
        hint  (.. prefix "SignHint")]
  (vim.fn.sign_define error {:text "x" :texthl error})
  (vim.fn.sign_define warn  {:text "!" :texthl warn})
  (vim.fn.sign_define info  {:text "i" :texthl info})
  (vim.fn.sign_define hint  {:text "?" :texthl hint})))

(if (= (nvim.fn.has "nvim-0.6") 1)
  (define-signs "Diagnostic")
  (define-signs "LspDiagnostics"))

(let [handlers {"textDocument/publishDiagnostics"
                (vim.lsp.with
                  vim.lsp.diagnostic.on_publish_diagnostics
                  {:severity_sort true
                   :update_in_insert false
                   :underline true
                   :virtual_text false})
                "textDocument/hover"
                (vim.lsp.with
                  vim.lsp.handlers.hover
                  {:border "single"})
                "textDocument/signatureHelp"
                (vim.lsp.with
                  vim.lsp.handlers.signature_help
                  {:border "single"})}
      capabilities (cmplsp.update_capabilities (vim.lsp.protocol.make_client_capabilities))
      on_attach (fn [client bufnr]
                  (do
                    (map bufnr :n :gd "<Cmd>lua vim.lsp.buf.definition()<CR>" {:noremap true})
                    (map bufnr :n :K "<Cmd>lua vim.lsp.buf.hover()<CR>" {:noremap true})
                    (map bufnr :n :<leader>gD "<Cmd>lua vim.lsp.buf.declaration()<CR>" {:noremap true})
                    ; (map bufnr :n :<leader>tD "<cmd>lua vim.lsp.buf.type_definition()<CR>" {:noremap true})
                    ; (map bufnr :n :<leader>hh "<cmd>lua vim.lsp.buf.signature_help()<CR>" {:noremap true})
                    (map bufnr :n :<leader>rr "<cmd>lua vim.lsp.buf.rename()<CR>" {:noremap true})
                    ; (map bufnr :n :<leader>le "<cmd>lua vim.diagnostic.open_float()<CR>" {:noremap true})
                    ; (map bufnr :n :<leader>lq "<cmd>lua vim.diagnostic.setloclist()<CR>" {:noremap true})
                    (map bufnr :n :<leader>r= "<cmd>lua vim.lsp.buf.formatting()<CR>" {:noremap true})
                    ; (map bufnr :n :<leader>lj "<cmd>lua vim.diagnostic.goto_next()<CR>" {:noremap true})
                    ; (map bufnr :n :<leader>lk "<cmd>lua vim.diagnostic.goto_prev()<CR>" {:noremap true})
                    ;telescope
                    (map bufnr :n :<leader>ra
                         ":lua require('telescope.builtin').lsp_code_actions(require('telescope.themes').get_cursor())<cr>"
                         {:noremap true})
                    (map bufnr :v :<leader>ra ":'<,'>:Telescope lsp_range_code_actions theme=cursor<cr>" {:noremap true})
                    (map bufnr :n :<leader>rw ":lua require('telescope.builtin').lsp_workspace_diagnostics()<cr>" {:noremap true})
                    (map bufnr :n :<leader>fr ":lua require('telescope.builtin').lsp_references()<cr>" {:noremap true})
                    (map bufnr :n :<leader>fi ":lua require('telescope.builtin').lsp_implementations()<cr>" {:noremap true})))]
(lsp.clojure_lsp.setup {:on_attach on_attach
                          :handlers handlers
                          :capabilities capabilities}))
