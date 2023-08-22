(module plugin.csv
  {require {nvim aniseed.nvim
            edgy edgy
            {: kset : bkset} util}})

(defn- match-conjure-log [buf win ext]
  (and (= (. (vim.api.nvim_win_get_config win) :relative) "")
       (string.find (vim.api.nvim_buf_get_name buf)
                    (.. "[%a|%/]conjure.log.%d.*%." ext))))

(defn- conjure-view-ops [ft ext]
  {:filter (fn [buf win]
             (match-conjure-log buf win ext))
   :ft ft
   :size {:width 0.4}
   :title :Neo-Tree})

(edgy.setup
  {:bottom
   [{:filter (fn [buf win]
               (= (. (vim.api.nvim_win_get_config win) :relative) ""))
     :ft :toggleterm
     :size {:height 0.4}}
    {:filter (fn [buf win]
               (= (. (vim.api.nvim_win_get_config win) :relative) ""))
     :ft :fugitive
     :size {:height 0.4}}
    {:filter (fn [buf]
               (= (. (. vim.bo buf) :buftype) :help))
     :ft :help
     :size {:height 0.4}}]

   :right
   [(conjure-view-ops "fennel" "fnl")
    (conjure-view-ops "clojure" "clj")]

   :wo {:winbar false
        :winhighlight ""}

   :keys {:<M-<> (fn [win] (win:resize :height 2))
          :<M->> (fn [win] (win:resize :height (- 2)))
          :<M-.> (fn [win] (win:resize :width 2))
          "<M-,>" (fn [win] (win:resize :width (- 2)))}	

   :animate {:enable true
             :fps 12
             :cps 1000}})	
