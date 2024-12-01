(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))

{1 :FabijanZulj/blame.nvim
 :cmd :BlameToggle
 :lazy true
 :init (fn []
         (kset [:n :x] :<space>ga ::BlameToggle<Cr>))
 :config {}}
