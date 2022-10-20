(module plugin.tree
  {require {tree nvim-tree
            lib nvim-tree.lib
            openfile nvim-tree.actions.node.open-file
            actions telescope.actions
            action-state telescope.actions.state
            {: merge} aniseed.core
            {: nmap :m map} util}})

(nmap "<space>pt" ":NvimTreeFindFileToggle<cr>")

(nmap "¡" ":NvimTreeFindFileToggle<cr>") ; alt+1
(map :i "¡" "<Esc>¡" {:noremap false})

(defn view-selection [prompt-funr map]
  (actions.select_default:replace 
    (fn []
      (actions.close prompt-funr)
      (let [selection (action-state.get_selected_entry)
            filename  (or selection.filename (. selection 1))]
        (openfile.fn :preview filename))))
  true)

(defn launch-telescope [fun-name opts]
  ;; see https://github.com/kyazdani42/nvim-tree.lua/wiki/Find-file-from-node-in-telescope
  (let [node (lib.get_node_at_cursor)
        folder? (and node.fs_stat (= node.fs_stat.type :directory))
        basedir (and folder? (or node.absolute_path 
                                 (vim.fn.fnamemodify node.absolute_path ":h")))
        basedir (if (and (= node.name "..") (not= TreeExplorer nil))
                  TreeExplorer.cwd
                  basedir)
        f (. (require "telescope.builtin") fun-name)]
    (f (merge {:cwd basedir
               :search_dirs [basedir]
               :attach_mappings view-selection}
              opts))))

(tree.setup 
  {:update_cwd true
   :git {:enable false}
   :view 
   {:mappings
    {:list [{:key :t :action :tabnew}
            {:key :S :cb (fn [opts] (launch-telescope "live_grep" opts)) }
            {:key :q :action ""} ;; unmap
            {:key :s :action :split}
            {:key :v :action :vplit}
            {:key :f :action :system_open}
            {:key :i :action :toggle_file_info}
            {:key :u :action :dir_up}]}}})
