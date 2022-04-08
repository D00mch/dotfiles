(module util
  {require {nvim aniseed.nvim
            a aniseed.core}})

(defn expand [path]
  (nvim.fn.expand path))

(defn glob [path]
  (nvim.fn.glob path true true true))

(defn add-glob [n f]
  (tset _G n f))

(defn exists? [path]
  (= (nvim.fn.filereadable path) 1))

(defn lua-file [path]
  (nvim.ex.luafile path))

(def config-path (nvim.fn.stdpath "config"))

(defn m [mode from to opts]
  (nvim.set_keymap mode from to (if opts opts {:noremap true})))

(defn nmap [from to]
  (m :n from to))

(def nnoremap nmap)

(defn map [from to]
  (m :n from to {:noremap false}))
