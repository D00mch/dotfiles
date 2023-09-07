(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))

[{1 :kevinhwang91/nvim-ufo
  :lazy true
  :dependencies [:kevinhwang91/promise-async]
  :init (fn []
          (let [ufo (require :ufo)]
            (kset :n :zR ufo.openAllFolds)
            (kset :n :zM ufo.closeAllFolds))

          (kset :n :zr :zMzv {:remap true})

          (set vim.o.foldcolumn :0)
          (set vim.o.fillchars "eob: ,fold: ,foldopen:,foldsep: ,foldclose:")

          (set vim.o.foldlevel 99)
          (set vim.o.foldlevelstart 99)
          (set vim.o.foldenable true))
  :config (fn []
            (let [ufo (require :ufo)

                  handler
                  (fn [virt-text lnum end-lnum width truncate]
                    (let [new-virt-text {}]
                      (var suffix (: "  %d " :format (- end-lnum lnum)))
                      (local suf-width (vim.fn.strdisplaywidth suffix))
                      (local target-width (- width suf-width))
                      (var cur-width 0)
                      (each [_ chunk (ipairs virt-text)]
                        (var chunk-text (. chunk 1))
                        (var chunk-width (vim.fn.strdisplaywidth chunk-text))
                        (if (> target-width (+ cur-width chunk-width))
                          (table.insert new-virt-text chunk)
                          (do
                            (set chunk-text (truncate chunk-text (- target-width cur-width)))
                            (local hl-group (. chunk 2))
                            (table.insert new-virt-text [chunk-text hl-group])
                            (set chunk-width (vim.fn.strdisplaywidth chunk-text))
                            (when (< (+ cur-width chunk-width) target-width)
                              (set suffix
                                   (.. suffix
                                       (: " " :rep (- (- target-width cur-width) chunk-width)))))
                            (lua :break)))
                        (set cur-width (+ cur-width chunk-width)))
                      (table.insert new-virt-text [suffix :MoreMsg])
                      new-virt-text))

                  get-comment-folds
                  (fn [bufnr]
                    (let [comment-folds {}
                          line-count (vim.api.nvim_buf_line_count bufnr)]
                      (var is-in-comment false)
                      (var comment-start 0)
                      (for [i 0 (- line-count 1)]
                        (local line (. (vim.api.nvim_buf_get_lines bufnr i (+ i 1) false) 1))
                        (if (and (not is-in-comment)
                                 (line:match (.. "^%s*" (vim.o.commentstring:sub 1 1))))
                          (do
                            (set is-in-comment true) (set comment-start i))
                          (and is-in-comment
                               (not (line:match (.. "^%s*" (vim.o.commentstring:sub 1 1)))))
                          (do
                            (set is-in-comment false)
                            (table.insert comment-folds
                                          {:endLine (- i 1) :startLine comment-start}))))
                      (when is-in-comment
                        (table.insert comment-folds
                                      {:endLine (- line-count 1) :startLine comment-start}))
                      comment-folds))

                  with-comment-folds 
                  (fn [bufnr default]
                    (let [comment-folds (get-comment-folds bufnr)
                          default-folds (ufo.getFolds bufnr default)]
                      (each [_ fold (ipairs comment-folds)]
                        (table.insert default-folds fold))
                      default-folds))
                  
                  ft-map
                  {:clojure #(with-comment-folds $ :indent)
                   :markdown :treesitter
                   :fennel #(with-comment-folds $ :indent)}]
              (ufo.setup
                {:fold_virt_text_handler handler
                 :provider_selector (fn [bufnr filetype buftype]
                                      (. ft-map filetype))})))}]
