[{1 :ray-x/go.nvim
  :dependencies [:ray-x/guihua.lua ;; floating window support
                 ]
  :lazy true
  :ft [:go :gomod]
  :config true 
  :event [:CmdlineEnter]
  :build ":lua require(\"go.install\").update_all_sync()"}]
