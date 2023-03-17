(module plugin.nvim-tree
  {require {tree nvim-tree
            lib nvim-tree.lib
            api nvim-tree.api
            openfile nvim-tree.actions.node.open-file
            actions telescope.actions
            action-state telescope.actions.state
            builtin telescope.builtin
            {: merge} aniseed.core
            {: kset} util}})

(kset :n "<space>pt" #(api.tree.toggle false true) "Tree Toggle")

(kset :n :<Space>1 #(vim.cmd "NvimTreeCollapse|NvimTreeToggle") "Collapse and show")

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

; (defn swap-then-open-tab []
;   (let [node (lib.get_node_at_cursor)]
;     (vim.cmd "wincmd l")
;     (api.node.open.tab node)))

(tree.setup
  {:sync_root_with_cwd false
   :respect_buf_cwd false
   :update_focused_file {:enable true
                         :update_root true}
   :git {:enable false}
   :view
   {;:adaptive_size true
    :mappings
    {:list [;{:key :t
            ; :action "swap-then-open-tab"
            ; :action_cb swap-then-open-tab}
            ; {:key :<D-t>
            ;  :action "swap-then-open-tab"
            ;  :action_cb swap-then-open-tab}
            {:key       [:S] 
             :action    "`live-grep` the node"
             :action_cb #(launch-telescope "live_grep" $1)}
            {:key       [:F :<D-f>] 
             :action    "`find-files` the node"
             :action_cb #(launch-telescope "find_files" $1)}
            {:key      "<D-,>"
             :action   "BufferLineCyclePrev"
             :action_cb #(vim.cmd (.. "wincmd l" "|" "BufferLineCyclePrev"))}
            {:key       "<D-.>"
             :action    "BufferLineCycleNext"
             :action_cb #(vim.cmd (.. "wincmd l" "|" "BufferLineCycleNext"))}
            {:key       :<M-.>
             :action    :resizeRight
             :action_cb #(vim.cmd "NvimTreeResize +5")}
            {:key       "<M-,>"
             :action    :resizeLeft
             :action_cb #(vim.cmd "NvimTreeResize -5")}
            {:key :D :action :cd}
            {:key :M :action :bulk_move}
            {:key :q :action ""} ;; unmap
            {:key :s :action :split}
            {:key :v :action :vsplit}
            {:key :f :action :system_open}
            {:key :i :action :toggle_file_info}
            {:key :u :action :dir_up}]}}
   :renderer {:symlink_destination false
              :indent_markers {:enable true}}
   :filters {:custom [:^.git$]}})

;; Autoclose when nvim-tree is the last buffer
(vim.api.nvim_create_autocmd
  :BufEnter
  {:group (vim.api.nvim_create_augroup :NvimTreeClose {:clear true})
   :pattern :NvimTree_*
   :callback (fn []
               (local layout
                 (vim.api.nvim_call_function :winlayout {}))
               (when (and (= (. layout 1) :leaf)
                          (= (vim.api.nvim_buf_get_option
                               (vim.api.nvim_win_get_buf (. layout 2))
                               :filetype)
                             :NvimTree)
                          (= (. layout 3) nil))
                 (vim.cmd "bd")))})	
