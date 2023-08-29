[{1 :DNLHC/glance.nvim
  :init (fn []
          (let [{: kset} (require :config.util)]
            (kset :n :<D-b> "mZg*`Z:Glance references<Cr>" {:desc "Show refs (Idea)"})))
  :config
  (fn []
    (let [glance (require :glance)]
      (glance.setup
        {:mappings
         {:list {:gh (glance.actions.enter_win :preview)
                 ;:<D-t> glance.actions.jump_tab
                 :<left> (glance.actions.preview_scroll_win 5)
                 :<right> (glance.actions.preview_scroll_win -5)}
          :preview {:gl (glance.actions.enter_win :list)
                    ;:<D-t> glance.actions.jump_tab
                    }}
         :border {:enable true}
         :height 25})))}]
