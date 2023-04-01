(module util
  {require {nvim aniseed.nvim
            {: assoc : update : dec : inc : first : second} aniseed.core}})

(defn println [message]
  (vim.api.nvim_echo [[message :Normal]] true {}))

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
  #(op
     [(vim.fn.line ".") (vim.fn.line "v")]
     args))

;; maps operation to visual
(defn vis-op+ [op args]
  #(op
     [(vim.api.nvim_buf_get_mark 0 "<")
      (vim.api.nvim_buf_get_mark 0 ">")]
     args))

;; words near cursor

;; returns: word, start-row, start-column
(defn get-word-under-cursor []
  (let [cursor-pos (vim.api.nvim_win_get_cursor 0)
        row        (dec (first cursor-pos))
        col        (second cursor-pos) 
        line       (first (vim.api.nvim_buf_get_lines 0 row (+ row 1) false))
        left-part  (: (line:sub 1 (inc col)) :match "[%w_-]*$")
        right-part (: (line:sub (+ col 2)) :match "^[%w_-]*")
        word (.. left-part right-part)]
    [word row col]))

;; returns: word, start-row, start-column, end-row, end-column
(defn get-word-under-selection []
  (let [[sr sc] (vim.api.nvim_buf_get_mark 0 "<")
        [sr sc] [(dec sr) sc]
        [er ec] (vim.api.nvim_buf_get_mark 0 ">")
        [er ec] [(dec er) (inc ec)]
        [word]  (vim.api.nvim_buf_get_text 0 sr sc er ec {})]
    [word sr sc er ec]))
