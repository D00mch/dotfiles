(module lang.clojure
  {require {nvim aniseed.nvim
            u util
            {: some} aniseed.core}})

(set nvim.g.surround_99 "#_\r")

;; jack in
(def- run-lein-cmd "lein repl")
(def- run-deps-cmd "clj -M:REPL")
(def- run-flutter-cmd "clj -M -m cljd.build flutter")

;; jack in with Lein or Deps or Flutter based on root project file
(defn run-appropriate-clojure-repl []
  (let [root-files (nvim.fn.readdir (nvim.fn.getcwd))
        has-pubspec (some (fn [s] (= s "pubspec.yaml")) root-files) 
        has-lein (some (fn [s] (= s "project.clj")) root-files)
        has-deps (some (fn [s] (= s "deps.edn")) root-files)]
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

;; setup
(defn set-up-mappings []
  (u.bm :n :<Leader>c :ysafc {:noremap false})
  (u.bm :n :<Leader>uc "<Cmd>let s=@/<CR>l?\\v(#_)+<CR>dgn:let @/=s<CR>")
  (vim.keymap.set :n "<Leader>k" run-appropriate-clojure-repl))
