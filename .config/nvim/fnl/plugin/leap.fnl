(module plugin.leap
  {require {nvim aniseed.nvim
            leap leap
            {:m map :map remap} util}})

(leap.setup
  {:case_sensitive false
   :safe_labels [:f :j :k :l :o :d :w :e :h :m :v :g :u :t
                 :c :. :z :/ :A :F :L :N :H :G :M :U :T :? :Z]
   :labels      [:f :j :k :l :o :d :w :e :h :m :v :g :u :t
                 :c :. :z :/ :A :F :L :N :H :G :M :U :T :? :Z]
   :special_keys {
     :repeat_search :n
     :next_match    :n
     :prev_match    :p
     :next_group    :<space>}})


(map "" :q "<Plug>(leap-forward)" {:noremap false})
(map "" :Q "<Plug>(leap-backward)" {:noremap false})
(map "" :gq "<Plug>(leap-cross-window)" {:noremap false})

(vim.api.nvim_set_hl 0 :LeapBackdrop { :fg :#707070 })
