(module util
  {require {nvim aniseed.nvim
            {: assoc} aniseed.core}})

(defn exists? [path]
  (= (nvim.fn.filereadable path) 1))

(defn lua-file [path]
  (nvim.ex.luafile path))

(def config-path (nvim.fn.stdpath "config"))

(defn kset [modes from to opts]
  (vim.keymap.set modes from to (or opts {})))

(defn bkset [modes from to opts]
  (vim.keymap.set modes from to (assoc opts :buffer 0)))
