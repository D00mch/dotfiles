[{1 :MeanderingProgrammer/render-markdown.nvim
  :ft [:markdown]
  :dependencies [:nvim-treesitter/nvim-treesitter :nvim-tree/nvim-web-devicons]
  :opts {:anti_conceal {:enabled false}
         :render_modes [:n :c :t]
         :heading {:width :block
                   :sign false
                   :position :inline
                   :icons ["◆ " "◇ " "• " "· " "· " "· "]
                   :backgrounds [:CursorLine]
                   :left_pad 1
                   :right_pad 2}
         :code {:width :block
                :sign false
                :border :thin
                :left_pad 2
                :right_pad 2}
         :pipe_table {:preset :round}}
  :keys [{1 :<Space>tv
          2 "<cmd>RenderMarkdown buf_toggle<cr>"
          :ft :markdown
          :desc "Toggle Markdown view"}]}]
