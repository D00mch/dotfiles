(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset} (autoload :config.util))

{1 :iamcco/markdown-preview.nvim
 :lazy true
 :ft [:markdown]
 :build "cd app && npm install"
 :config (fn []
           (kset :n :<Space>tp ":MarkdownPreviewToggle<Cr>" "MarkdownPreview"))
 :init (fn []
         (set nvim.g.mkdp_auto_close 0)
         (set vim.g.mkdp_filetypes [:markdown]))}
