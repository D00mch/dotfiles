(local {: autoload} (require :nfnl.module))
(local {: bkset} (autoload :config.util))

(bkset :i :<D-e> ":=")
(bkset :n :<Leader>tc ":GoTestFunc -v -F<Cr>")
(bkset :n :<Leader>ta ":GoTest -v -F<Cr>")
(bkset :n :<Leader>re ":GoIfErr<Cr>g;")
