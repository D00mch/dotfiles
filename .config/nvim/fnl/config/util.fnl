(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: assoc : update : dec : inc : first : second} (autoload :nfnl.core))

(fn println [message]
  (vim.api.nvim_echo [[message :Normal]] true {}))

(fn exists? [path]
  (= (nvim.fn.filereadable path) 1))

(fn lua-file [path]
  (nvim.ex.luafile path))

(local config-path (nvim.fn.stdpath "config"))

(fn +docs [opts to]
  (update opts :desc (fn [desc] (or desc to))))

(fn +buffer [opts buffer]
  (update opts :buffer (fn [b] (or b buffer))))

(fn kset [modes from to opts]
  (let [opts  (if 
                (= (type opts) "table")  opts
                (= (type opts) "string") {:desc opts})]
    (vim.keymap.set modes from to (+docs opts to))))

(fn kdel [modes from opts]
  (vim.keymap.del modes from opts))

;; opts could be options map or just a buffer
(fn bkset [modes from to opts]
  (let [opts  (if 
                (= (type opts) "table")  (+buffer opts 0)
                (= (type opts) "number") {:buffer opts}
                (= (type opts) "string") {:desc opts}
                {:buffer 0})]
    (vim.keymap.set modes from to (+docs opts to))))

(fn bkdel [modes from b]
  (vim.keymap.del modes from {:buffer (or b 0)}))

;; maps operation to visual, rows only
(fn vis-op [op args]
  #(op
     [(vim.fn.line ".") (vim.fn.line "v")]
     args))

;; maps operation to visual
(fn vis-op+ [op args]
  #(op
     [(vim.api.nvim_buf_get_mark 0 "<")
      (vim.api.nvim_buf_get_mark 0 ">")]
     args))

;; words near cursor

;; returns: word, start-row, start-column
(fn get-word-under-cursor []
  (let [cursor-pos (vim.api.nvim_win_get_cursor 0)
        row        (dec (first cursor-pos))
        col        (second cursor-pos) 
        line       (first (vim.api.nvim_buf_get_lines 0 row (+ row 1) false))
        left-part  (: (line:sub 1 (inc col)) :match "[%w_-]*$")
        right-part (: (line:sub (+ col 2)) :match "^[%w_-]*")
        word (.. left-part right-part)]
    [word row col]))

;; returns: word, start-row, start-column, end-row, end-column
(fn get-word-under-selection []
  (let [[sr sc] (vim.api.nvim_buf_get_mark 0 "<")
        [sr sc] [(dec sr) sc]
        [er ec] (vim.api.nvim_buf_get_mark 0 ">")
        [er ec] [(dec er) (inc ec)]
        [word]  (vim.api.nvim_buf_get_text 0 sr sc er ec {})]
    [word sr sc er ec]))

{: config-path
 : lua-file
 : println
 : exists?

 : kset
 : bkset
 : bkdel
 : vis-op
 : vis-op+
 : get-word-under-cursor
 : get-word-under-selection
 }
