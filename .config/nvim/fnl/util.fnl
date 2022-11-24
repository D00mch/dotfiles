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
  (let [opts  (if 
                (= (type opts) "table")  opts
                (= (type opts) "string") {:desc opts})]
    (vim.keymap.set modes from to (+docs opts to))))

;; opts could be options map or just a buffer
(defn bkset [modes from to opts]
  (let [opts  (if 
                (= (type opts) "table")  (+buffer opts 0)
                (= (type opts) "number") {:buffer opts}
                (= (type opts) "string") {:desc opts}
                {:buffer 0})]
    (vim.keymap.set modes from to (+docs opts to))))

;; maps operation to visual, rows only
(defn vis-op [op args]
  (fn []
    (op
     [(vim.fn.line ".") (vim.fn.line "v")]
     args)))

;; maps operation to visual
(defn vis-op+ [op args]
  (fn []
    (op
     [(vim.api.nvim_buf_get_mark 0 "<")
      (vim.api.nvim_buf_get_mark 0 ">")]
     args)))
