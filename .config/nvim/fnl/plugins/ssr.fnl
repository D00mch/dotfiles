[{1 :cshuaimin/ssr.nvim
  :lazy true
  :init (fn []
          (let [ssr (require :ssr)
                {: kset} (require :config.util)]
            (kset [:n :x] :<Leader>sr ssr.open "Search/Replace")))
  :opts {:keymaps {:close :<D-w>
                   :next_match :n
                   :prev_match :N
                   :replace_confirm :<CR>
                   :replace_all :<Leader><Cr>}}
  :config true}]
