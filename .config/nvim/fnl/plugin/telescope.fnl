(module plugin.telescope
  {autoload {nvim aniseed.nvim
             builtin telescope.builtin
             telescope telescope
             harpoon harpoon
             hmark harpoon.mark
             themes telescope.themes
             actions telescope.actions
             fb_actions telescope._extensions.file_browser.actions
             undo_actions telescope-undo.actions
             prj project_nvim
             state telescope.actions.state
             mt telescope.actions.mt
             {: kset : get-word-under-cursor : get-word-under-selection} util}})

(harpoon.setup)
(kset :n :<Space>am hmark.add_file "Add mark")

(prj.setup
  {:patterns [".git" "package.json" "deps.edn" "project.clj"]})

;; visually select a file path
;; source: https://github.com/drybalka/dotfiles/blob/main/.config/nvim/lua/common/telescope.lua#L173-L202
(defn generate-offset [str tabsize]
  (let [offset (% (- tabsize (% (vim.fn.strdisplaywidth str) tabsize)) tabsize)]
    (string.rep " " offset)))

(defn generate-display [pieces]
  (var res-text "")
  (local res-highlight {})
  (each [_ piece (ipairs pieces)]
    (local (text highlight) (unpack piece))
    (when (not= highlight nil)
      (table.insert res-highlight [[(length res-text)
                                    (+ (length res-text) (length text))]
                                   highlight]))
    (set res-text (.. res-text text)))
  (values res-text res-highlight))

(defn refine-filename [filename cwd]
  (when (not= cwd nil) (set-forcibly! cwd (vim.loop.cwd)))
  (local relative-filename (: (: (require :plenary.path) :new filename)
                              :make_relative cwd))
  (local name (relative-filename:match "[^/]*$"))
  (local dir (or (relative-filename:match "^.*/") ""))
  (var (icon hl-icon)
    ((. (require :telescope.utils) :transform_devicons) filename))
  (set icon (.. icon (generate-offset icon 3)))
  (values [icon hl-icon] [dir :TelescopeResultsSpecialComment] [name]))

(defn lsp-entry-maker [entry]
  (let [res (((. (require :telescope.make_entry) :gen_from_quickfix)) entry)]
    (set res.display
         (fn [entry-tbl]
           (let [(icon dir name) (refine-filename entry-tbl.filename)
                 pos (.. " " entry-tbl.lnum ":" entry-tbl.col)
                 offset (generate-offset (.. (. icon 1) (. dir 1) (. name 1)
                                             pos "  ")
                                         10)
                 trimmed-text (entry-tbl.text:gsub "^%s*(.-)%s*$" "%1")]
             (generate-display [icon
                                dir
                                name
                                [pos :TelescopeResultsLineNr]
                                [(.. offset trimmed-text)]]))))
    res))

(defn files-entry-maker [entry]
  (let [res (((. (require :telescope.make_entry) :gen_from_file)) entry)]
    (set res.display
         (fn [entry-tbl]
           (generate-display [(refine-filename (. entry-tbl 1))])))
    res))

(defn grep-entry-maker [entry]
  (let [res (((. (require :telescope.make_entry) :gen_from_vimgrep)) entry)]
    (set res.display
         (fn [entry-tbl]
           (let [(_ _ filename pos text) (string.find (. entry-tbl 1)
                                                      "^(.*):(%d+:%d+):(.*)$")
                 (icon dir name) (refine-filename filename)
                 offset (generate-offset (.. (. icon 1) (. dir 1) (. name 1)
                                             " " pos "  ")
                                         10)]
             (generate-display [icon
                                dir
                                name
                                [(.. " " pos) :TelescopeResultsLineNr]
                                [(.. offset text)]]))))
    res))

(defn buffers-entry-maker [entry]
  (let [res (((. (require :telescope.make_entry) :gen_from_buffer)) entry)]
    (set res.display
         (fn [entry-tbl]
           (let [(icon dir name) (refine-filename entry-tbl.filename)
                 offset (generate-offset (tostring entry-tbl.bufnr) 4)]
             (generate-display [[(.. (tostring entry-tbl.bufnr) offset)
                                 :TelescopeResultsNumber]
                                [entry-tbl.indicator :TelescopeResultsComment]
                                icon
                                dir
                                name
                                [(.. " " (tostring entry-tbl.lnum))
                                 :TelescopeResultsLineNr]]))))
    res))

(def- M (mt.transform_mod
          {:yank-entry
           (fn [prompt_bufnr]
             (let [entry (state.get_selected_entry prompt_bufnr)]
               (vim.fn.setreg "*" entry.value)
               (actions.close prompt_bufnr)))}))

(telescope.setup
  {:defaults
   {:vimgrep_arguments ["rg" "--color=never" "--no-heading"
                        "--with-filename" "--line-number" "--column"
                        "--smart-case" "--hidden" "--follow"
                        "-g" "!.git/" "-g" "!.clj-kondo/"]
    :cache_picker {:num_pickers 5}
    :layout_config {:height 0.9
                    :width 0.9}
    :layout_strategy :vertical ; cursor horizontal bottom_pane
    :wrap_results true
    :mappings {:n {:y       M.yank-entry
                   :<Esc>   false
                   :<D-w>   actions.close
                   :<Right> actions.preview_scrolling_down
                   :<Left>  actions.preview_scrolling_up
                   :t       actions.select_tab
                   ;:<D-t>   actions.select_tab
                   :q       (+ actions.smart_send_to_qflist actions.open_qflist)}
               :i {:<M-x>   actions.close
                   :<C-q>   (+ actions.smart_send_to_qflist actions.open_qflist)
                   :?       actions.which_key
                   :<Right> actions.preview_scrolling_down
                   :<Left>  actions.preview_scrolling_up
                   :<M-d>   actions.delete_buffer
                   :<M-t>   actions.select_tab
                   ;:<D-t>   actions.select_tab
                   :<M-?>   actions.which_key}}}
   :pickers {:git_branches        {:mappings
                                   {:n {:<Cr>  actions.git_switch_branch
                                        :ga    actions.git_create_branch
                                        :gh    actions.git_reset_hard
                                        :gs    actions.git_reset_soft
                                        :<D-m> actions.git_merge_branch
                                        :gd    actions.git_delete_branch
                                        :gr    actions.git_rebase_branch}
                                    :i {:<Cr>  actions.git_switch_branch
                                        :<M-d> actions.git_delete_branch
                                        :<C-a> actions.git_create_branch
                                        :<M-a> actions.git_create_branch
                                        :<D-a> actions.git_create_branch
                                        :<C-h> actions.git_reset_hard
                                        :<C-s> actions.git_reset_soft
                                        :<C-m> actions.git_merge_branch
                                        :<C-b> actions.git_rebase_branch
                                        :<D-b> actions.git_rebase_branch
                                        :<C-r> actions.git_rebase_branch}}}
             :git_commits         {:mappings
                                   {:n {:h     actions.git_reset_hard
                                        :<Esc> false}
                                    :i {:<Cr> actions.git_checkout_current_buffer}}}
             :find_files          {:entry_maker files-entry-maker}
             :buffers             {:entry_maker buffers-entry-maker
                                   :sort_mru true}
             :lsp_references      {:entry_maker lsp-entry-maker}
             :lsp_implementations {:entry_maker lsp-entry-maker}
             :live_grep           {:only_sort_text  true
                                   :additional_args ["--trim"]
                                   :entry_maker     grep-entry-maker}}
   :extensions {:undo {:mappings {:n {:y undo_actions.yank_additions
                                      :Y undo_actions.yank_deletions}}}
                :file_browser {:theme :ivy
                               :mappings {:n
                                          {:u fb_actions.goto_parent_dir
                                           :f fb_actions.open
                                           :a fb_actions.create
                                           :o actions.select_default
                                           :r fb_actions.rename
                                           :m fb_actions.move ;; several items
                                           :c fb_actions.copy
                                           :d fb_actions.remove
                                           :h fb_actions.toggle_hidden
                                           :H fb_actions.goto_cwd
                                           :<Esc> false
                                           :<M-w> actions.close}}}
                :ui-select [(themes.get_cursor {})]}})

;; after telescope setup
(telescope.load_extension :ui-select)
(telescope.load_extension :file_browser)
(telescope.load_extension :projects)
(telescope.load_extension :harpoon)
(telescope.load_extension :undo)

(kset :n :<space>pf ":Telescope find_files hidden=true no_ignore=false<cr>")
(kset :n :<space>pr ":Telescope pickers<cr>")
(kset :n :<space>bb ":Telescope buffers sort_lastused=true show_all_buffers=false<cr>")
(kset :n :<space>pa ":Telescope live_grep<cr>")
(kset :n :<space>pp ":Telescope projects<cr>" "Projects")
(kset :n :<space>ph ":Telescope harpoon marks<cr>" "Harpoon")
(kset :n :<space>pu ":Telescope undo<Cr>" "Undo")
;(kset :n :<space>pq ":Telescope quickfix<cr>" "QuickFix")

(kset :n :<space>vk ":Telescope keymaps<cr>")
(kset :n :<space>vc ":Telescope colorscheme<cr>")
(kset :n :<space>v: ":Telescope commands<cr>")
(kset :n :<space>vo ":Telescope vim_options<cr>")
(kset :n :<space>vm ":Telescope marks<cr>")
(kset :n :<space>vr ":Telescope registers<cr>")

(kset :n :z= ":Telescope spell_suggest<cr>")

;; git
(kset :n :<space>gc ":Telescope git_commits<cr>")
(kset :n :<space>gs ":Telescope git_stash<cr>")
(kset :n :<space>gb ":Telescope git_branches<cr>")

;; search for a word under cursor
(defn search-word-under-cursor []
  (let [[word] (get-word-under-cursor)]
    (builtin.live_grep {:default_text word})))

(defn search-word-under-selection []
  (let [[word] (get-word-under-selection)]
    (builtin.live_grep {:default_text word})))

(kset :n :<D-b> search-word-under-cursor)
(kset :x :<D-b> search-word-under-selection)
(kset :n :<Leader>gr search-word-under-cursor)
