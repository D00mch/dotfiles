(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset : bkset} (autoload :config.util))

[{1 :rmagatti/goto-preview
  :config 
  (fn []
    (let [preview (require :goto-preview)

          close-and-move-focus-on-prev
          (fn []
            (let [prev-win (vim.fn.winnr)]
              (vim.cmd "wincmd p")
              (vim.cmd (.. prev-win "wincmd q"))))]
      (preview.setup
        {:height 25
         :bufhidden :wipe
         :post_open_hook
         (fn [b _]
           (bkset :n :<D-w> close-and-move-focus-on-prev {:buffer b })
           (nvim.echo (vim.fn.expand "%:p")))})

      (kset [:n] :gp "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")))
  }]
