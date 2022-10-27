(module plugin.leap
  {require {nvim aniseed.nvim
            leap leap
            {: kset} util}})

(leap.setup
  {:case_sensitive false
   :safe_labels [:q :f :n :j :k :l :h :o :d :w :e :m :b :u :y :v :r :g :t :c :x :/ :z
                 :S :F :N :J :K :L :H :O :D :W :E :M :B :U :Y :V :R :G :T :C :X :? :Z]
   :labels      [:q :f :n :j :k :l :h :o :d :w :e :m :b :u :y :v :r :g :t :c :x :/ :z
                 :S :F :N :J :K :L :H :O :D :W :E :M :B :U :Y :V :R :G :T :C :X :? :Z]
   :special_keys {:repeat_search ";"
                  :next_target   ";"
                  :prev_target   :<tab>
                  :next_group    :<space>}})

(kset [:n :x] :q "<Plug>(leap-forward)" {:noremap false})
(kset [:n :x] :Q "<Plug>(leap-backward)" {:noremap false})
(kset [:n :x] :gq "<Plug>(leap-cross-window)" {:noremap false})

(defn greying-out []
  (vim.api.nvim_set_hl 0 :LeapBackdrop { :link :Comment }))

(greying-out)

(vim.api.nvim_create_autocmd
  :ColorScheme
  {:pattern :*
   :callback greying-out})
