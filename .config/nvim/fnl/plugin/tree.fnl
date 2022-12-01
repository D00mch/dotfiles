(module plugin.tree
  {require {tree nvim-tree
            lib nvim-tree.lib
            api nvim-tree.api
            openfile nvim-tree.actions.node.open-file
            actions telescope.actions
            action-state telescope.actions.state
            builtin telescope.builtin
            {: merge} aniseed.core
            {: kset} util}})

(kset :n "<space>pt" ":NvimTreeFindFileToggle<cr>")

(kset :n :<Space>1 ":NvimTreeFindFile<cr>")

(defn view-selection [prompt-funr map]
  (actions.select_default:replace
    (fn []
      (actions.close prompt-funr)
      (let [selection (action-state.get_selected_entry)
            filename  (or selection.filename (. selection 1))]
        (openfile.fn :preview filename))))
  true)

(defn launch-telescope [fun-name node]
  ;; see https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#find-file-from-node-in-telescope
  (let [folder? (and node.fs_stat (= node.fs_stat.type :directory))
        basedir (or (and folder? node.absolute_path)
                    (vim.fn.fnamemodify node.absolute_path ":h"))
        basedir (if (and (= node.name "..") (not= TreeExplorer nil))
                  TreeExplorer.cwd
                  basedir)
        f (. builtin fun-name)]
    (f {:cwd basedir
        :search_dirs [basedir]
        :attach_mappings view-selection})))

(defn swap-then-open-tab []
  (let [node (lib.get_node_at_cursor)]
    (vim.cmd "wincmd l")
    (api.node.open.tab node)))

(tree.setup
  {:sync_root_with_cwd true
   :respect_buf_cwd true
   :update_focused_file {:enable true
                         :update_root true}
   :git {:enable false}
   :view
   {:adaptive_size true
    :mappings
    {:list [{:key :t
             :action "swap-then-open-tab"
             :action_cb swap-then-open-tab}
            {:key :<D-t>
             :action "swap-then-open-tab"
             :action_cb swap-then-open-tab}
            {:key       [:S] 
             :action    "`live-grep` the node"
             :action_cb (fn [opts] (launch-telescope "live_grep" opts))}
            {:key       [:F :<D-f>] 
             :action    "`find-files` the node"
             :action_cb (fn [opts] (launch-telescope "find_files" opts))}
            {:key :D :action :cd}
            {:key :M :action :bulk_move}
            {:key :q :action ""} ;; unmap
            {:key :s :action :split}
            {:key :v :action :vsplit}
            {:key :f :action :system_open}
            {:key :i :action :toggle_file_info}
            {:key :u :action :dir_up}]}}})
