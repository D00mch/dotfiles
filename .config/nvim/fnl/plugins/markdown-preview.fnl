(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: toggle} (autoload :config.which))

{1 :iamcco/markdown-preview.nvim
  :build "cd app && npm install"
  :config (fn []
            (toggle "p" "MarkdownPreview" ":MarkdownPreviewToggle<Cr>"))
  :init (fn []
          (set nvim.g.mkdp_auto_close 0)
          (set vim.g.mkdp_filetypes [:markdown]))}
