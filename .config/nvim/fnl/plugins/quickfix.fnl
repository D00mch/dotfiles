(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))

[{1 :kevinhwang91/nvim-bqf
  :lazy true
  :ft [:qf]
  :init (fn []
          (kset :n :<Space>pq :<Cmd>copen<Cr> "Quickfix")
          (kset :n "]q" ":cn<cr>" "Quickfix: next item")
          (kset :n "[q" ":cp<cr>" "Quickfix: prev item"))
  :opts {:func_map {}}
  :config (fn [_ opts]
            ((. (require :bqf) :setup) opts)
            (let [handler (require :bqf.preview.handler)
                  preview (require :bqf.preview.floatwin)
                  resize-preview
                  (fn []
                    ;; bqf caches these dimensions when its preview initializes.
                    (let [height (math.max 1 (math.floor (* vim.o.lines 0.7)))]
                      (set preview.defaultHeight height)
                      (set preview.defaultVHeight height)
                      (when (: preview :validate)
                        (handler.redrawWin preview.qwinid))))]
              (resize-preview)
              (vim.api.nvim_create_autocmd :VimResized
                {:group (vim.api.nvim_create_augroup :QuickfixPreviewHeight {:clear true})
                 :callback resize-preview})))}]
