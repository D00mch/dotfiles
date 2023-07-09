(module lang.clojure
  {require {nvim aniseed.nvim
            {: kset : bkset} util
            {: some} aniseed.core}})

(set nvim.g.surround_99 "#_\r")

;; jack in
(def- run-lein-cmd "lein repl")
(def- run-deps-cmd "clj -M:nrepl:add-libs")
(def- run-flutter-cmd "clj -M -m cljd.build flutter")

;; jack in with Lein or Deps or Flutter based on root project file
(defn run-appropriate-clojure-repl []
  (let [root-files (nvim.fn.readdir (nvim.fn.getcwd))
        has-pubspec (some #(= $1 "pubspec.yaml") root-files) 
        has-lein (some #(= $1 "project.clj") root-files)
        has-deps (some #(= $1 "deps.edn") root-files)]
    (if 
      has-pubspec
      (do (nvim.echo "found flutter")
        (vim.api.nvim_command (.. "terminal " run-flutter-cmd)))
      has-lein 
      (do (nvim.echo "found lein")
        (vim.api.nvim_command (.. "terminal " run-lein-cmd)))
      has-deps
      (do (nvim.echo "found deps")
        (vim.api.nvim_command (.. "terminal " run-deps-cmd)))
      (nvim.echo "can't find neither deps.edn nor project.clj in the root"))))

(defn connect-shadow []
  (println "Connecting to 7002:app")
  (vim.cmd (.. "ConjureConnect " 7002))
  (vim.cmd (.. "ConjureShadowSelect " :app)))

(defn set-up-mappings []
  (bkset :n :<Leader>rs connect-shadow "Shadow REPL:7002:app")
  (bkset :n :<Leader>c :ysafc {:remap true})
  (bkset :n :<Leader>uc "<Cmd>let s=@/<CR>l?\\v(#_)+<CR>dgn:let @/=s<CR>")
  (bkset :n "<Leader>k" run-appropriate-clojure-repl))
