;; fnl/plugins/rust.fnl
(local {: autoload} (require :nfnl.module))
(local {: bkset : vis-op+ : on-attach} (autoload :config.util))
(local cmplsp (autoload "cmp_nvim_lsp"))

[{1 :mrcjkb/rustaceanvim
  :version :^7
  :lazy false ;; already lazy
  :tag :v7.0.6
  :cond true
  :init (fn []
          (set vim.g.rustaceanvim
               {:server {:on_attach on-attach
                         :capabilities (cmplsp.default_capabilities)}}))}]
