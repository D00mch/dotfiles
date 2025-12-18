(local {: autoload} (require :nfnl.module))
(local {: bkset : vis-op+} (autoload :config.util))
(local {: merge} (autoload :nfnl.core))
(local telescope (autoload :telescope))

(local diagnostics
  {:severity_sort true
   :update_in_insert false
   :underline true
   :signs true
   :virtual_text false
   :virtual_lines false ; {:current_line true}
   })

(local handlers
  {"textDocument/hover"
   (vim.lsp.with
     vim.lsp.handlers.hover
     {:border "single"})
   "textDocument/signatureHelp"
   (vim.lsp.with
     vim.lsp.handlers.signature_help
     {:border "single"})})

(fn highlight-line-symbol []
  ;; highlight line number instead of having icons in sigh column
  (vim.cmd 
    "highlight! DiagnosticLineNrError guibg=#51202A guifg=#FF0000 gui=bold
    highlight! DiagnosticLineNrWarn guibg=#51412A guifg=#FFA500 gui=bold
    highlight! DiagnosticLineNrInfo guibg=#1E535D guifg=#00FFFF gui=bold
    highlight! DiagnosticLineNrHint guibg=#1E205D guifg=#0000FF gui=bold
    sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
    sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
    sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
    sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint"))

(fn highlight-symbols [client bufnr]
  (when client.server_capabilities.documentHighlightProvider
    (highlight-line-symbol)
    (vim.api.nvim_create_autocmd
      :ColorScheme
      {:buffer   bufnr
       :group    (vim.api.nvim_create_augroup :HighlightColors {:clear true})
       :callback highlight-line-symbol})
    (vim.cmd "hi! link LspReferenceWrite TSConstMacro")))

[{1 :neovim/nvim-lspconfig
  :lazy true
  :ft [:clojure :go :dart :markdown :md]
  :cmd [:LspInfo :LspInstall :LspUninstall]
  :dependencies [:williamboman/mason.nvim
                 :barreiroleo/ltex-extra.nvim
                 :RRethy/vim-illuminate
                 :nvim-lua/plenary.nvim]
  :init (fn []
          (set vim.o.updatetime 250))
  :config (fn []
            (let [lsp vim.lsp.config
                  lsp-util (require :lspconfig.util)
                  cmplsp (require :cmp_nvim_lsp)
                  {: lsp_references : lsp_implementations} (require :telescope.builtin)
                  mason (require :mason)
                  illuminate (require :illuminate)
                  ltex (require :ltex_extra)

                  on-attach 
                  (fn [client b]
                    (highlight-symbols client b)
                    (set client.server_capabilities.semanticTokensProvider nil)
                    (bkset :n :<leader>h (fn [] (vim.lsp.buf.hover) (vim.lsp.buf.hover)) {:buffer b :desc "Show docs"})
                    (bkset :n :gd vim.lsp.buf.definition {:buffer b :desc "Go definition"}) ;[
                                                                                              (bkset :n :gD "<c-w><c-]><c-w>T" {:buffer b :desc "Go definition new tab"})
                    (bkset :n :<leader>tD vim.lsp.buf.type_definition {:buffer b :desc "Type definition"})
                    (bkset [:i :n] "<M-;>" vim.lsp.buf.signature_help {:buffer b :desc "Signiture help"})
                    (bkset [:i :n] "<D-p>" vim.lsp.buf.signature_help {:buffer b :desc "Signiture help"})
                    (bkset :n :<leader>rr vim.lsp.buf.rename {:buffer b :desc "Rename"})
                    (bkset :n :<leader>p vim.diagnostic.open_float {:buffer b :desc "Preview diagnostics"})
                    ;(bkset :n :<leader>re vim.diagnostic.setloclist {:buffer b :desc "List diagnostics"})

                    (when (not (string.find (vim.api.nvim_buf_get_name b) ".*.fnl$"))
                      (bkset :n := ":lua vim.lsp.buf.format({async = true})<Cr>" {:buffer b :desc "Apply formatting"}) ;[
                      (bkset :x := (vis-op+ vim.lsp.buf.format {:async true}) {:buffer b :desc "Apply formatting"}))

                    (bkset :n "[s" vim.diagnostic.goto_prev {:buffer b :desc "Goto prev erro"}) ;]
                    (bkset :n "]s" vim.diagnostic.goto_next {:buffer b :desc "Goto next erro"}) ;]
                    ;; TELESCOPE
                    (bkset :n :<leader>gr #(lsp_references {:jump_type :never}) {:buffer b :desc "Go to references"})
                    (bkset :n :<leader>gi lsp_implementations {:buffer b :desc "Go to implementations"})
                    (bkset [:i :n :x] :<C-r> vim.lsp.buf.code_action {:buffer b :desc "Code actions"})
                    (bkset [:n :x] :<leader>ra vim.lsp.buf.code_action {:buffer b :desc "Code actions"}))

                  capabilities
                  (cmplsp.default_capabilities)

                  before-init
                  (fn [params]
                    (set params.workDoneToken :1))

                  default-map
                  {:on_attach on-attach
                   :before_init before-init
                   :handlers handlers
                   :capabilities (cmplsp.default_capabilities)}]

              (vim.diagnostic.config diagnostics)

              (set capabilities.textDocument.foldingRange
                   {:dynamicRegistration false
                    :lineFoldingOnly true})

              (mason.setup)

              (illuminate.configure)

              (lsp :fennel_language_server
                (merge 
                  default-map
                  {:settings
                   {:fennel
                    {:workspace {:library (vim.api.nvim_list_runtime_paths)}
                     :diagnostics {:globals [:vim :comment]}}}
                   :filetypes [:fennel]
                   :single_file_support true
                   :root_dir (lsp-util.root_pattern :fnl)
                   :on_attach (fn [client b]
                                (on-attach client b)
                                (highlight-line-symbol))}))

              (lsp :clojure_lsp default-map)
              (lsp :jdtls default-map)
              (lsp :kotlin_language_server
                (merge default-map {:autostart false}))
              (lsp :vtsls default-map)
              (lsp :rust_analyzer default-map)

              ;; div completions
              (lsp :emmet_language_server
                (merge
                  
                  {:filetypes [:css :html :javascript :typescript :typescriptreact :javascriptreact
                               :svelte :vue :vue-html :less :scss :sass :sas]}))

              (lsp :ltex
                (merge default-map
                       {:on_attach (fn [client b]
                                     (on-attach client b)
                                     (ltex.setup
                                       {:load_langs [:en-US]
                                        :init_check true
                                        :path (.. (vim.fn.expand "~") "/.config/nvim/data/ltex")
                                        :log_level :debug})
                                     (highlight-line-symbol))
                        :filetypes ["markdown" "NeogitCommitMessage" "gitcommit"]
                        :settings {:ltex {}}}))

              (vim.lsp.enable [:fennel_language_server
                               :clojure_lsp
                               :jdtls
                               :kotlin_language_server
                               :vtsls
                               :emmet_language_server
                               :ltex
                               :rust_analyzer
                               ])
              ))}]
