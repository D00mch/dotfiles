(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))
(local {: map} (autoload :nfnl.core))
(local {: join} (autoload :nfnl.string))


[{1 :akinsho/bufferline.nvim

  :init
  (fn []
    (kset [:n :x] "<D-.>" ":BufferLineCycleNext<Cr>") ;; karabiner: cmd <
    (kset [:i :c] "<D-.>" "<Esc><D-.>" {:remap true})
    (kset :t "<D-.>" "<C-\\><C-n><D-.>" {:remap true})

    (kset [:n :x] "<D-,>" ":BufferLineCyclePrev<Cr>") ;; karabiner: cmd >
    (kset [:i :c] "<D-,>" "<Esc><D-,>" {:remap true})
    (kset :t "<D-,>" "<C-\\><C-n><D-,>" {:remap true})

    (kset [:n] ">>" ":BufferLineMoveNext<cr>")
    (kset [:n] "<<" ":BufferLineMovePrev<cr>")
    ; (kset [:n] ">>" ":tabmove +1<cr>")
    ; (kset [:n] "<<" ":tabmove -1<cr>")

    ;(kset [:n :t :x] :<M-t> #(vim.cmd "tabnew\nAlpha"))
    (kset [:n :t :x] :<D-t> :<Leader><Space> {:remap true})
    ;(kset [:n :t :x] :<D-t> :† {:remap true})

    (let [bufferline (require :bufferline)]
      (for [i 1 8]
        ;(kset :n (.. "<D-" i ">") (.. i :gt))
        (kset :n (.. "<D-" i ">") #(bufferline.go_to_buffer i true)))

      (kset :n :<D-9> #(bufferline.go_to_buffer -1 true))))

  :config
  (fn []
    (let [bufferline (require :bufferline)
          split-name 
          (fn [name]
            (let [subwords {}]
              (var current-subword "")
              (for [i 1 (length name)]
                (local char (name:sub i i))
                (local is-delimiter (char:match "[%.%-%_]"))
                (local is-uppercase (char:match "[A-Z]"))
                (when (or is-delimiter
                          (and (and is-uppercase (> i 1)) (not= current-subword "")))
                  (when (> (length current-subword) 0)
                    (table.insert subwords current-subword))
                  (set current-subword ""))
                (when (not is-delimiter) (set current-subword (.. current-subword char))))
              (when (not= current-subword "") (table.insert subwords current-subword))
              subwords))
          ]

      (bufferline.setup
        {:options {:mode :tabs
                   :numbers  :ordinal
                   :separator_style :slant
                   :always_show_bufferline false
                   :show_duplicate_prefix true
                   :tab_size 12
                   :name_formatter
                   #(let [name     (vim.fn.fnamemodify $.name ":t:r")
                          subwords (split-name name)]
                      (if 
                        (<= (length name) 8) name
                        (< (length subwords) 2) name
                        (->> subwords
                             (map (fn [subword] (subword:sub 1 3)))
                             (map (fn [two-letters] (two-letters:gsub "^%l" string.upper)))
                             join))) }
         :highlights {:numbers_selected {:italic false}
                      :buffer_selected {:bold true
                                        :italic false}}})))}]
