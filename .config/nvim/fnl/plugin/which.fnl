(module plugin.which
  {autoload {wk which-key}})

(wk.setup 
  {:plugins        {:spelling    {:enabled false
                                  :suggestions 12}}
   :popup_mappings {:scroll_down :<right>
                    :scroll_up   :<left>}})

(defn toggle [key name cmd buf]
  (wk.register {:t {:name :toggle
                    key [cmd name]}}
               {:prefix :<space>
                :buffer buf}))
