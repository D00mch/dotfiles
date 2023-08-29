(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))

[{1 :cshuaimin/ssr.nvim
  :init (fn []
          (let [ssr (require :ssr)]
            (kset [:n :x] :<Leader>sr ssr.open "Search/Replace")))
  :opts {:keymaps {:close :<D-w>
                   :next_match :n
                   :prev_match :N
                   :replace_confirm :<CR>
                   :replace_all :<Leader><Cr>}}
  :config true}]
