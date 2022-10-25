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

(defn kset [modes from to opts]
  (vim.keymap.set modes from to (+docs opts to)))

(defn bkset [modes from to opts]
  (let [opts* (assoc (+docs opts to) :buffer 0)]
    (vim.keymap.set modes from to opts*)))
