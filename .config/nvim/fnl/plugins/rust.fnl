;; fnl/plugins/rust.fnl
(local {: autoload} (require :nfnl.module))
(local {: on-attach} (autoload :config.util))

[{1 :mrcjkb/rustaceanvim
  :version :^7
  :lazy false ;; already lazy
  :tag :v7.0.6
  :cond true
  :init (fn []
          ;; Keep Rust semantic tokens.
          (vim.lsp.config :rust-analyzer
                          {:on_attach on-attach}))}]
