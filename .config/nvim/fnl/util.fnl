(module util
  {require {nvim aniseed.nvim
            {: assoc : update} aniseed.core}})

(defn exists? [path]
  (= (nvim.fn.filereadable path) 1))

(defn lua-file [path]
  (nvim.ex.luafile path))

(def config-path (nvim.fn.stdpath "config"))

(defn +docs [opts to]
  (update opts :desc (fn [desc] (or desc to))))

(defn +buffer [opts buffer]
  (update opts :buffer (fn [b] (or b buffer))))

(defn kset [modes from to opts]
  (vim.keymap.set modes from to (+docs opts to)))

;; opts could be options map or just a buffer
(defn bkset [modes from to opts]
  (let [opts  (if 
                (= (type opts) "table")  (+buffer opts 0)
                (= (type opts) "number") {:buffer opts}
                {:buffer 0})]
    (vim.keymap.set modes from to (+docs opts to))))
