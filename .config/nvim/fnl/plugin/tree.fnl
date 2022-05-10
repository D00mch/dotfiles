(module plugin.tree
  {require {tree nvim-tree
            {: nmap :m map} util}})

(nmap "<space>pt" ":NvimTreeFindFileToggle<cr>")

(nmap "¡" ":NvimTreeFindFileToggle<cr>") ; alt+1
(map :i "¡" "<Esc>¡" {:noremap false})

(tree.setup 
  {:update_cwd true
   :git {:enable false}
   :view 
   {:mappings 
    {:list [{:key :t :action :tabnew}
            {:key :q :action ""} ;; unmap
            {:key :s :action :split}
            {:key :v :action :vplit}
            {:key :f :action :system_open}
            {:key :i :action :toggle_file_info}
            {:key :u :action :dir_up}]}}})
