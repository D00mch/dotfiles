(module plugin.leap
  {require {nvim aniseed.nvim
            leap leap
            {:m map :map remap} util}})

(vim.api.nvim_set_hl 0 :LeapBackdrop { :fg :#707070 })

(leap.setup
  {:case_sensitive false
   :safe_labels [:q :f :n :j :k :l :h :o :d :w :e :m :b :u :y :v :r :g :t :c :x :/ :z
                 :S :F :N :J :K :L :H :O :D :W :E :M :B :U :Y :V :R :G :T :C :X :? :Z]
   :labels      [:q :f :n :j :k :l :h :o :d :w :e :m :b :u :y :v :r :g :t :c :x :/ :z
                 :S :F :N :J :K :L :H :O :D :W :E :M :B :U :Y :V :R :G :T :C :X :? :Z]
   :special_keys {:repeat_search :<tab>
                  :next_target    :<tab>
                  :prev_target    :<s-tab>
                  :next_group    :<space>}})

(map "" :q "<Plug>(leap-forward)" {:noremap false})
(map "" :Q "<Plug>(leap-backward)" {:noremap false})
(map "" :gq "<Plug>(leap-cross-window)" {:noremap false})