(module plugin.nvim-tree
  {require {tree nvim-tree
            lib nvim-tree.lib
            api nvim-tree.api
            openfile nvim-tree.actions.node.open-file
            actions telescope.actions
            action-state telescope.actions.state
            builtin telescope.builtin
            {: merge} aniseed.core
            {: kset : bkset : kdel : bkdel} util}})

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

(defn launch-telescope [fun-name]
  ;; see https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#find-file-from-node-in-telescope
  (let [node    (api.tree.get_node_under_cursor)
        folder? (and node.fs_stat (= node.fs_stat.type :directory))
        basedir (or (and folder? node.absolute_path)
                    (vim.fn.fnamemodify node.absolute_path ":h"))
        basedir (if (and (= node.name "..") (not= TreeExplorer nil))
                  TreeExplorer.cwd
                  basedir)
        f (. builtin fun-name)]
    (f {:cwd basedir
        :search_dirs [basedir]
        :attach_mappings view-selection})))

(tree.setup
  {:sync_root_with_cwd false
   :respect_buf_cwd false
   :update_focused_file {:enable true
                         :update_root false}
   :git {:enable false}
   :on_attach (fn [b]
                (api.config.mappings.default_on_attach b)
                (bkdel :n :q b)

                (bkset :n :S #(launch-telescope "live_grep") b)
                (bkset :n :<D-S-f> #(launch-telescope "find_files") b)

                (bkset :n "<D-,>" #(vim.cmd (.. "wincmd l" "|" "BufferLineCyclePrev")) b)
                (bkset :n "<D-.>" #(vim.cmd (.. "wincmd l" "|" "BufferLineCycleNext")) b)
                (bkset :n "<M-.>" #(vim.cmd "NvimTreeResize +5") b)
                (bkset :n "<M-,>" #(vim.cmd "NvimTreeResize -5") b)

                (bkset :n :gal api.node.open.vertical b)
                (bkset :n :gak api.node.open.horizontal b)
                (bkset :n :gaj api.node.open.horizontal b)

                (bkset :n :sd api.tree.change_root_to_node b)
                (bkset :n :gf api.node.run.system b)
                (bkset :n :i api.node.show_info_popup b))

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
