(local {: autoload} (require :nfnl.module))
(local {: bkset : vis-op} (autoload :config.util))

[{1 :lewis6991/gitsigns.nvim
  :lazy true
  :event :VeryLazy
  :config
  (fn []
    (let [gs (require :gitsigns)
          gitsigns (fn gitsigns []
                     (gs.toggle_linehl)
                     (gs.toggle_word_diff))]
      (gs.setup
        {:signcolumn false
         :numhl      true
         :current_line_blame_opts {:overlay true
                                   :delay 1000}
         :on_attach
         (fn [b]
           (bkset :n :gn #(vim.schedule gs.next_hunk) {:buffer b :desc "Gitsigns next"})
           (bkset :n :gN #(vim.schedule gs.prev_hunk) {:buffer b :desc "Gitsigns prev"})
           (bkset :n :gs gs.stage_hunk {:buffer b :desc "Gitsigns stage hunk"})
           (bkset :x :gs (vis-op gs.stage_hunk) {:buffer b :desc "Gitsigns stage hunk"})
           (bkset :n :gus gs.undo_stage_hunk {:buffer b :desc "Gitsigns undo staged"})

           (bkset :n :<Space>gS #(vim.schedule gs.stage_buffer) {:buffer b :desc "Gitsigns stage buffer"})
           (bkset :n :<Space>gr gs.reset_hunk {:buffer b :desc "Gitsigns reset hunk"})
           (bkset :x :<Space>gr (vis-op gs.reset_hunk) {:buffer b :desc "Gitsigns reset hunk"})
           (bkset :n :<Space>gm #(gs.blame_line {:full true}) {:buffer b :desc "Gitsigns blame message"})
           (bkset :n :<Space>gl #(gs.toggle_current_line_blame) {:buffer b :desc "Gitsigns blame line"})
           (bkset :n :<Space>gd gs.diffthis {:buffer b :desc "Gitsigns diff"})

           ;; toggle
           (bkset :n :<Space>tg gitsigns "gitsigns")
           (bkset :n :<Space>gt gitsigns "gitsigns"))})))}]
