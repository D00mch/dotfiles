(local {: autoload} (require :nfnl.module))
(local actions (autoload :telescope.actions))
(local action-state (autoload :telescope.actions.state))
(local builtin (autoload :telescope.builtin))
(local
  {: kset : bkset : bkdel}
  (autoload :config.util))

[{1 :nvim-tree/nvim-tree.lua
  :lazy true
  :dependencies [:nvim-tree/nvim-web-devicons]  
  :init (fn []
          (let [
                tree-view (require :nvim-tree.view)
                api (require :nvim-tree.api)]

            (kset :n "<space>pt" #(api.tree.toggle false true) "Tree Toggle")
            (kset :n :<Space>1
                  (fn []
                    (api.tree.toggle)
                    (if (tree-view.is_visible)
                      (api.tree.collapse_all true)))
                  "Collapse and show")))
  :config (fn []
            (let [tree (require :nvim-tree)
                  api (require :nvim-tree.api)
                  openfile (require :nvim-tree.actions.node.open-file)

                  view-selection
                  (fn  [prompt-funr _]
                    (actions.select_default:replace
                      (fn []
                        (actions.close prompt-funr)
                        (let [selection (action-state.get_selected_entry)
                              filename  (or selection.filename (. selection 1))]
                          (openfile.fn :preview filename))))
                    true)

                  launch-telescope 
                  (fn [fun-name]
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
                          :attach_mappings view-selection})))]

              (tree.setup
                {:sync_root_with_cwd true
                 :respect_buf_cwd false
                 :update_focused_file {:enable true
                                       :update_root true}
                 :git {:enable false}
                 :actions {:open_file {:resize_window false}}
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

                              (bkset :n "(" api.node.navigate.parent b) ;)

                              (bkset :n :sd        api.tree.change_root_to_node {:buffer b :desc "Set root"})
                              (bkset :n :<Space>sd api.tree.change_root_to_node {:buffer b :desc "Set root"})
                              (bkset :n :gf api.node.run.system b)
                              (bkset :n :i api.node.show_info_popup b))

                 :renderer {:symlink_destination false
                            :indent_markers {:enable true}}
                 :filters {:custom [:^.git$]}})))}]
