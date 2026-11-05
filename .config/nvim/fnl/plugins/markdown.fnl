(fn heading-backgrounds []
  (let [normal (vim.api.nvim_get_hl 0 {:name :Normal :link false})
        background (or normal.bg (if (= vim.o.background :dark) 0x202020 0xffffff))
        accent (or (. (vim.api.nvim_get_hl 0 {:name :Title :link false}) :fg)
                   normal.fg 0x808080)]
    ;; Fade the theme's heading color into its normal background.
    (each [level alpha (ipairs [0.32 0.25 0.19 0.14 0.09 0.05])]
      (var color 0)
      (each [_ shift (ipairs [16 8 0])]
        (let [fg (% (math.floor (/ accent (^ 2 shift))) 256)
              bg (% (math.floor (/ background (^ 2 shift))) 256)]
          (set color (+ color (* (math.floor (+ (* fg alpha) (* bg (- 1 alpha)) 0.5))
                                (^ 2 shift))))))
      (vim.api.nvim_set_hl 0 (.. :RenderMarkdownH level :Bg) {:bg color}))))

[{1 :MeanderingProgrammer/render-markdown.nvim
  :ft [:markdown]
  :dependencies [:nvim-treesitter/nvim-treesitter :nvim-tree/nvim-web-devicons]
  :init (fn []
          (heading-backgrounds)
          (vim.api.nvim_create_autocmd :ColorScheme
            {:group (vim.api.nvim_create_augroup :MarkdownHeadingBackgrounds {:clear true})
             :callback heading-backgrounds}))
  :opts {:anti_conceal {:enabled false}
         :render_modes [:n :c :t]
         :heading {:width :full
                   :sign false
                   :position :inline
                   :icons ["H₁ " "H₂ " "H₃ " "H₄ " "H₅ " "H₆ "]
                   :left_pad 1
                   :right_pad 2}
         :code {:width :block
                :sign false
                :disable_background false
                :border :thick
                :highlight :CursorLine
                :highlight_border :CursorLine
                :background_inset 0
                :language_border " "
                :language_icon false
                :language_pad 1
                :language_left " "
                :language_right " "
                :left_pad 2
                :right_pad 2}
         :bullet {:icons ["▸" "›" "·"]}
         :checkbox {:left_pad 1}
         :pipe_table {:preset :round}}
  :keys [{1 :<Space>tv
          2 "<cmd>RenderMarkdown buf_toggle<cr>"
          :ft :markdown
          :desc "Toggle Markdown view"}]}]
