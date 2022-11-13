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

;; showing tabs, spaces, end-of-lines
(set vim.o.listchars "eol:¬,space:·,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ")
(toggle "l" "list; invisibele chars" (fn [] (set vim.o.list (not vim.o.list))))

;; modifiable
(toggle "m" "modifiable" (fn [] (set vim.bo.modifiable (not vim.bo.modifiable))))
