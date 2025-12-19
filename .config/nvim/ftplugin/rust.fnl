(local {: autoload} (require :nfnl.module))
(local {: bkset} (autoload :config.util))

(bkset :n :<Leader>k ":RustLsp run<CR>")
