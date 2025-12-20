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
  (update opts :desc (fn [desc] 
                       (if 
                         (= (type to) "function") desc
                         (= desc nil) to
                         (.. desc " " to)))))

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
                (= (type opts) "string") (+buffer {:desc opts})
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

;; to share slp with mrcjkb/rustaceanvim
(local {: lsp_references : lsp_implementations : lsp_definitions} (autoload :telescope.builtin)) 

(fn on-attach [_ b]

  (bkset :n :<space>th
         (fn []
           (vim.lsp.inlay_hint.enable 
             (not (vim.lsp.inlay_hint.is_enabled [0])) [0]))
         {:buffer b :desc "Inlay hints"})	

  (bkset :n :<leader>h (fn [] (vim.lsp.buf.hover) (vim.lsp.buf.hover)) {:buffer b :desc "Show docs"})
  (bkset :n :gd #(lsp_definitions {:initial_mode :normal}) {:buffer b :desc "Go definition"})

  (bkset :n :gD "<c-w><c-]><c-w>T" {:buffer b :desc "Go definition new tab"})
  (bkset :n :<leader>tD vim.lsp.buf.type_definition {:buffer b :desc "Type definition"})
  (bkset [:i :n] "<M-;>" vim.lsp.buf.signature_help {:buffer b :desc "Signiture help"})
  (bkset [:i :n] "<D-p>" vim.lsp.buf.signature_help {:buffer b :desc "Signiture help"})
  (bkset :n :<leader>rr vim.lsp.buf.rename {:buffer b :desc "Rename"})
  (bkset :n :<leader>p vim.diagnostic.open_float {:buffer b :desc "Preview diagnostics"})
  ;(bkset :n :<leader>re vim.diagnostic.setloclist {:buffer b :desc "List diagnostics"})

  (when (not (string.find (vim.api.nvim_buf_get_name b) ".*.fnl$"))
    (bkset :n := ":lua vim.lsp.buf.format({async = true})<Cr>" {:buffer b :desc "Apply formatting"}) ;[
    (bkset :x := (vis-op+ vim.lsp.buf.format {:async true}) {:buffer b :desc "Apply formatting"}))

  (bkset :n "[s" vim.diagnostic.goto_prev {:buffer b :desc "Goto prev erro"}) ;]
  (bkset :n "]s" vim.diagnostic.goto_next {:buffer b :desc "Goto next erro"}) ;]
  ;; TELESCOPE
  (bkset :n :<leader>gr #(lsp_references {:jump_type :never}) {:buffer b :desc "Go to references"})
  (bkset :n :<leader>gi lsp_implementations {:buffer b :desc "Go to implementations"})
  (bkset [:i :n :x] :<C-r> vim.lsp.buf.code_action {:buffer b :desc "Code actions"})
  (bkset [:n :x] :<leader>ra vim.lsp.buf.code_action {:buffer b :desc "Code actions"}))

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

 : on-attach
 }
