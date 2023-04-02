(module plugin.lspconfig
  {autoload {nvim aniseed.nvim
             lsp lspconfig
             ;null-ls null-ls
             ltex ltex_extra
             glance glance
             which plugin.which
             {: kset : bkset : vis-op+} util
             telescope  telescope
             {: merge : update : first} aniseed.core
             {: lsp_references : lsp_implementations} telescope.builtin
             flut flutter-tools
             mason mason
             preview goto-preview
             cmplsp cmp_nvim_lsp}})

;preview
(defn close-and-move-focus-on-prev []
  (let [prev-win (vim.fn.winnr)]
    (vim.cmd "wincmd p")
    (vim.cmd (.. prev-win "wincmd q"))))

(preview.setup {:height 25
                :bufhidden :wipe
                :post_open_hook
                (fn [b w]
                  (vim.keymap.set :n :<D-w> close-and-move-focus-on-prev {:buffer b})
                  (nvim.echo (vim.fn.expand "%:p")))})
(kset [:n] :<leader>d "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")

(mason.setup)
; (installer.setup {:ensure_installed [:clojure_lsp :jdtls :kotlin_language_server
;                                      :codespell :alex ;; null-ls
;                                      :ltex-ls]})

(glance.setup
  {:mappings
   {:list {:gh (glance.actions.enter_win :preview)
           ;:<D-t> glance.actions.jump_tab
           :<left> (glance.actions.preview_scroll_win 5)
           :<right> (glance.actions.preview_scroll_win -5)}
    :preview {:gl (glance.actions.enter_win :list)
              ;:<D-t> glance.actions.jump_tab
              }}
   :height 25})

(set vim.o.updatetime 250)

(defn- highlight-line-symbol []
  ;; highlight line number instead of having icons in sigh column
  (vim.cmd "
    highlight! DiagnosticLineNrError guibg=#51202A guifg=#FF0000 gui=bold
    highlight! DiagnosticLineNrWarn guibg=#51412A guifg=#FFA500 gui=bold
    highlight! DiagnosticLineNrInfo guibg=#1E535D guifg=#00FFFF gui=bold
    highlight! DiagnosticLineNrHint guibg=#1E205D guifg=#0000FF gui=bold
    sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
    sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
    sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
    sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint"))

(defn- highlight-symbols [client bufnr]
  (when client.server_capabilities.documentHighlightProvider
    (highlight-line-symbol)
    (vim.api.nvim_create_autocmd
      :ColorScheme
      {:buffer   bufnr
       :group    (vim.api.nvim_create_augroup :HighlightColors {:clear true})
       :callback highlight-line-symbol})
    (vim.cmd "hi! link LspReferenceWrite TSConstMacro")
    (let [group (vim.api.nvim_create_augroup :lsp_document_highlight {})]
      (vim.api.nvim_create_autocmd [:CursorHold :CursorHoldI]
                                   {:group group
                                    :buffer bufnr
                                    :callback vim.lsp.buf.document_highlight})
      (vim.api.nvim_create_autocmd :CursorMoved
                                   {:group group
                                    :buffer bufnr
                                    :callback vim.lsp.buf.clear_references}))))

(def- diagnostics {:severity_sort true
                   :update_in_insert false
                   :underline true
                   :signs true
                   :virtual_text false})

(def- handlers {"textDocument/publishDiagnostics"
                (vim.lsp.with
                  vim.lsp.diagnostic.on_publish_diagnostics
                  diagnostics)
                "textDocument/hover"
                (vim.lsp.with
                  vim.lsp.handlers.hover
                  {:border "single"})
                "textDocument/signatureHelp"
                (vim.lsp.with
                  vim.lsp.handlers.signature_help
                  {:border "single"})})

(defn- on_attach [client b]
  (highlight-symbols client b)
  (set client.server_capabilities.semanticTokensProvider nil)
  (bkset :n :<leader>h (fn [] (vim.lsp.buf.hover) (vim.lsp.buf.hover)) {:buffer b :desc "Show docs"})
  (bkset :n :gd vim.lsp.buf.definition {:buffer b :desc "Go definition"}) ;[
  (bkset :n :gD "<c-w><c-]><c-w>T" {:buffer b :desc "Go definition new tab"})
  (bkset :n :<leader>tD vim.lsp.buf.type_definition {:buffer b :desc "Type definition"})
  (bkset [:i :n] "<M-;>" vim.lsp.buf.signature_help {:buffer b :desc "Signiture help"})
  (bkset [:i :n] "<D-p>" vim.lsp.buf.signature_help {:buffer b :desc "Signiture help"})
  (bkset :n :<leader>rr vim.lsp.buf.rename {:buffer b :desc "Rename"})
  (bkset :n :<leader>p vim.diagnostic.open_float {:buffer b :desc "Preview diagnostics"})
  (bkset :n :<leader>re vim.diagnostic.setloclist {:buffer b :desc "List diagnostics"})
  (bkset :n :<leader>= ":lua vim.lsp.buf.format({async = true})<Cr>" {:buffer b :desc "Apply formatting"}) ;[
  (bkset :x :<leader>= (vis-op+ vim.lsp.buf.format {:async true}) {:buffer b :desc "Apply formatting"})
  (bkset :n "]s" vim.diagnostic.goto_next {:buffer b :desc "Goto next erro"})
  (bkset :n "[s" vim.diagnostic.goto_prev {:buffer b :desc "Goto prev erro"}) ;]
  (bkset :n :<tab> vim.diagnostic.goto_next {:buffer b :desc "Goto next erro"})
  (bkset :n :<S-tab> vim.diagnostic.goto_prev {:buffer b :desc "Goto prev erro"})
  (bkset :n :<D-b> "mZg*`Z:Glance references<Cr>" {:buffer b :desc "Show refs (Idea)"}) ; cmd+b
  ;; TELESCOPE
  (bkset :n :<leader>gr #(lsp_references {:jump_type :never}) {:buffer b :desc "Go to references"})
  (bkset :n :<leader>gi lsp_implementations {:buffer b :desc "Go to implementations"})
  (bkset [:n :x] :<C-r> vim.lsp.buf.code_action {:buffer b :desc "Code actions"})
  (bkset [:n :x] :<leader>ra vim.lsp.buf.code_action {:buffer b :desc "Code actions"}))

(def- default-map {:on_attach on_attach
                   :handlers handlers
                   :capabilities (cmplsp.default_capabilities)})

(lsp.clojure_lsp.setup default-map)
(lsp.jdtls.setup default-map)
(lsp.kotlin_language_server.setup default-map)
(lsp.racket_langserver.setup default-map)
(lsp.tsserver.setup default-map)
(lsp.volar.setup (merge default-map
                        {:filetypes [:vue :javascript :typescript :json]}))
(lsp.eslint.setup default-map)

(lsp.ltex.setup
  (merge default-map
         {:on_attach (fn [client b]
                       (on_attach client b)
                       (ltex.setup
                         {:load_langs [:en-US]
                          :init_check true
                          :path (.. (vim.fn.expand "~") "/.config/nvim/data/ltex")
                          :log_level :debug}))
          :filetypes ["markdown" "NeogitCommitMessage" "gitcommit"]
          :settings {:ltex {}}}))

(flut.setup
  {:lsp
   {:closing_tags {:highlight "ErrorMsg"
                   :prefix ">"
                   :enabled true}
    :handlers handlers
    :capabilities capabilities
    :on_attach
    (fn [client b]
      (on_attach client b)
      (bkset [:n] :<leader>fa (fn [] (telescope.extensions.flutter.commands)) b)
      (telescope.load_extension "flutter"))}})

;;; Null-ls

; (defn- null-toggle [source key]
;   (which.toggle
;     key
;     (.. "Null_ls: " source)
;     #(let [source (null-ls.get_source {:name source})]
;        (if (. (first source) :_disabled)
;          (null-ls.enable source)
;          (null-ls.disable source)))))

; (null-ls.setup
;   (merge default-map
;          {:on_attach (fn [c b]
;                        (on_attach c b)
;                        (highlight-symbols c b)
;                        (null-toggle :alex :a)
;                        (vim.api.nvim_buf_set_option b :formatexpr ""))
;           :sources (let [diagnostics {:diagnostic_config diagnostics
;                                       :diagnostics_format "[#{c}] #{m} (#{s})"}]
;                      [null-ls.builtins.hover.dictionary
;                       (null-ls.builtins.diagnostics.alex.with diagnostics)])}))
