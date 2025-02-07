(local {: autoload} (require :nfnl.module))
(local {: bkset} (autoload :config.util))

(bkset :i "<D-k>" ":= ")
(bkset :n :<Leader>tc ":GoTestFunc -v -F<Cr>")
(bkset :n :<Leader>tb ":GoTestFile -v -F<Cr>")
(bkset :n :<Leader>ta ":GoTest -v -F<Cr>")
(bkset :n :<Leader>re ":GoIfErr<Cr>g;")

(bkset :n :<Leader>b ":GoRun % -F<Cr>")

(bkset :n :<Leader>k ":GoRun<Cr>")
