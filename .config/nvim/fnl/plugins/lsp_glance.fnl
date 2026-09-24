[{1 :DNLHC/glance.nvim
  :lazy true
  :ft [:clojure :go :dart :markdown :md]
  :cmd [:LspInfo :LspInstall :LspUninstall]
  :init (fn []
          (let [{: kset} (require :config.util)]
            (kset :n :<D-b> "mZg*`Z:Glance references<Cr>" {:desc "Show refs (Idea)"})))
  :config
  (fn []
    (let [glance (require :glance)
          config (require :glance.config)
          resize-preview #(set config.options.height (math.max 1 (math.floor (* vim.o.lines 0.7))))]
      (glance.setup
        {:mappings
         {:list {:gh (glance.actions.enter_win :preview)
                 ;:<D-t> glance.actions.jump_tab
                 :<left> (glance.actions.preview_scroll_win 5)
                 :<right> (glance.actions.preview_scroll_win -5)}
          :preview {:gl (glance.actions.enter_win :list)
                    ;:<D-t> glance.actions.jump_tab
                    }}
         :border {:enable true}})
      (resize-preview)
      (vim.api.nvim_create_autocmd :VimResized
        {:group (vim.api.nvim_create_augroup :GlancePreviewHeight {:clear true})
         :callback resize-preview})))}]
