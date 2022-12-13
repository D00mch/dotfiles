(module plugin.which
  {autoload {wk which-key
             {: assoc} aniseed.core}})

(set vim.o.timeoutlen 250)

(wk.setup
  {:plugins        {:spelling    {:enabled false
                                  :suggestions 12}}
   :popup_mappings {:scroll_down :<right>
                    :scroll_up   :<left>}})

(defn toggle [key name cmd opts]
  ; `opts` could be a tables with :buf and :mode keys, mode string, or buf number
  (let [opts  (if 
                (= (type opts) "table")  opts
                (= (type opts) "number") {:buffer opts}
                (= (type opts) "string") {:mode opts}
                {})]
    (wk.register {:t {:name :toggle
                      key [cmd name]}}
                 (assoc opts :prefix :<Space>))))

;; showing tabs, spaces, end-of-lines
(set vim.o.listchars "eol:¬,space:·,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ")
(toggle "l" "list; invisibele chars" #(set vim.o.list (not vim.o.list)))

;; modifiable
(toggle "m" "modifiable" #(set vim.bo.modifiable (not vim.bo.modifiable)))

;; fan
(toggle "a" "Animation")
(toggle "1" "Rain" "<cmd>CellularAutomaton make_it_rain<CR>")
(toggle "2" "Game" "<cmd>CellularAutomaton game_of_life<CR>")
