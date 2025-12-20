(local {: autoload} (require :nfnl.module))
(local {:on-attach on-attach-util : highlight-line-symbol} (autoload :config.util))
(local {: merge} (autoload :nfnl.core))

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

[{1 :neovim/nvim-lspconfig
  :lazy false
  :ft [:clojure :go :dart :markdown :md :fennel]
  :cmd [:LspInfo :LspInstall :LspUninstall :LspStart]
  :dependencies [:mason-org/mason.nvim
                 :barreiroleo/ltex-extra.nvim
                 :RRethy/vim-illuminate
                 :nvim-lua/plenary.nvim]
  :init (fn []
          (set vim.o.updatetime 250))
  :config (fn []
            (let [lsp vim.lsp.config
                  cmplsp (require :cmp_nvim_lsp)
                  mason (require :mason)
                  illuminate (require :illuminate)
                  ltex (require :ltex_extra)

                  on-attach 
                  (fn [client b]
                    (set client.server_capabilities.semanticTokensProvider nil)
                    (on-attach-util client b))

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
                     :diagnostics {:globals [:vim :jit :comment]}}}
                   :filetypes [:fennel]
                   :cmd [(.. (vim.fn.stdpath "data") "/mason/bin/fennel-language-server")]
                   :single_file_support true
                   :root_markers [:.git :fnl :lua]
                   :on_attach (fn [client b]
                                (on-attach client b)
                                (highlight-line-symbol))}))

              (lsp :clojure_lsp default-map)
              (lsp :jdtls default-map)
              (lsp :kotlin_language_server
                (merge default-map {:autostart false}))
              (lsp :vtsls default-map)
              
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
                               ])
              ))}]
