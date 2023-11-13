(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))

{1 :FabijanZulj/blame.nvim
 :init (fn []
         (kset [:n :x] :<space>ga ::ToggleBlame<Cr>))
 :config {}}
