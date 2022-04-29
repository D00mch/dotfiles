(module lang.clojure
  {require {nvim aniseed.nvim
            u util
            c aniseed.core}})

(set nvim.g.surround_99 "#_\r")

(defn set-up-mappings []
  (u.bm :n :<Leader>c :ysafc {:noremap false})
  (u.bm :n :<Leader>uc "<Cmd>let s=@/<CR>l?\\v(#_)+<CR>dgn:let @/=s<CR>")
  (u.bm :n "<Leader>k" ":RunAppropriateClojureRepl<cr>"))

;;  =============== jack in part ===============

(def- run-lein-cmd "lein repl")
(def- run-deps-cmd 
  (.. "clj -Sdeps"
      " '{:deps {nrepl/nrepl {:mvn/version \"0.7.0\"} cider/cider-nrepl {:mvn/version \"0.25.2\"}}}'"
      " -m nrepl.cmdline --middleware '[\"cider.nrepl/cider-middleware\"]' --interactive"))

;; jack in with Lein or Deps based on root project file
(defn run-appropriate-clojure-repl [args]
  (let [root-files (nvim.fn.readdir (nvim.fn.getcwd))
        has-lein (c.some (fn [s] (= s "project.clj")) root-files)
        has-deps (c.some (fn [s] (= s "deps.edn")) root-files)]
    (if has-lein 
      (do (nvim.echo "found lein")
        (vim.api.nvim_command (.. "terminal " run-lein-cmd)))
      has-deps
      (do (nvim.echo "found deps")
        (vim.api.nvim_command (.. "terminal " run-deps-cmd)))
      (nvim.echo "can't find neither deps.edn nor project.clj in the root"))))

(vim.api.nvim_create_user_command
  :RunAppropriateClojureRepl
  run-appropriate-clojure-repl
  {:nargs :* :desc "Run terminal with clojure repl"})
