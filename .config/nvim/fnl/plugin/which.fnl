(module plugin.which
  {autoload {wk which-key}})

(wk.setup 
  {:plugins {:spelling {:enabled false
                        :suggestions 12}}})

(defn toggle [key name cmd buf]
  (wk.register {:t {:name :toggle
                    key [cmd name]}}
               {:prefix :<space>
                :buffer buf}))
