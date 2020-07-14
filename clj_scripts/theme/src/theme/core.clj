(ns theme.core
  (:gen-class)
  (:require [clojure.string :as str]
            [clojure.java.shell :use [sh]]
            [robot.core :as r]))

(def system-osx?
  (= "Mac OS X" (System/getProperty "os.name")))

(defn open-app! [app-name]
  (sh "sh" "-c" (str "open -a " app-name)))

;; robot
;; file help functions

(defn expand-home [s]
  (if (.startsWith ^String s "~")
    (clojure.string/replace-first s "~" (System/getProperty "user.home"))
    s))

(defn file-by-lines [f-name]
  (str/split (slurp f-name) #"\n"))

(defn write-lines [f-name lines]
  (->> (str/join "\n" lines) (spit f-name)))

;; zathura

(def zathura (expand-home "~/dotfiles/.config/zathura/zathurarc"))

(defn zathura-change-colors-with! [f path]
  (let [lines           (file-by-lines path)
       [s title colors] (partition-by #(.contains ^String % "Colours") lines)
       colors'          (map f colors)]
    (->> (concat s title colors')
         (write-lines path))))

(defn zathura-comment-colors! []
  (zathura-change-colors-with! #(if (= "set" (re-find #"\w+" %))
                                 (str "#" %)
                                 %)
                              zathura))

(defn zathura-uncomment-colors! []
  (zathura-change-colors-with! #(if (= "#set" (re-find #"#\w+" %))
                                 (subs % 1)
                                 %)
                              zathura))

;; spacemacs

(def spacemacs (expand-home "~/dotfiles/.spacemacs"))
(def spacemacs-light "doom-one-light")
(def spacemacs-dark  "doom-tomorrow-night")

(defn spacemacs-opened? []
  (let [shell-oputput (sh "sh" "-c" "ps ax | grep emacs")
        shell-res     (:out shell-oputput)]
    (.contains ^String shell-res "/Emacs.app")))

(defn spacemacs-set-theme! [theme]
  (do
    (->> (file-by-lines spacemacs)
           (map (fn [line]
                  (if (.contains ^String line "dotspacemacs-themes ")
                    (str "   dotspacemacs-themes '(" theme)
                    line)))
           (write-lines spacemacs))
    (when (and system-osx? (spacemacs-opened?))
      (do
        (open-app! "emacs")
        (r/sleep 100)
        (r/type! :esc)
        (r/sleep 150)
        (r/type! :space)
        (r/sleep 150)
        (r/type! :space)
        (r/sleep 150)
        (r/type-text! (str "load-theme\n"))
        (r/sleep 150)
        (r/type-text! (str theme "\n"))
        (r/sleep 150)
        (r/type! :enter)))))

;; vim

(def vim (expand-home "~/dotfiles/.vimrc"))

(defn vim-bg [light?] (if light? "light" "dark"))
(defn vim-theme [light?] (if light? "one" "xoria256"))

(defn vim-set-theme! [light?]
  (->> (file-by-lines vim)
       (map (fn [line]
              (cond (.contains ^String line "colorscheme")
                    (str "colorscheme " (vim-theme light?)),
                    (.contains ^String line "set background")
                    (str "set background=" (vim-bg light?)),
                    :else line)))
       (write-lines vim)))

;; desktop theme

(defn desktop-xfce-set-theme [& {:keys [property theme]}]
  {:pre [(#{"ThemeName" "IconThemeName"} property)]}
  (clojure.java.shell/sh
   "sh"
   "-c"
   (format "xfconf-query -c xsettings -p /Net/%s -s %s" property theme)))

(defn desktop-set-theme! "run after the chrome" [input]
  (if system-osx?
    (clojure.java.shell/sh
     "sh" "-c"
     (str "/usr/bin/automator "
          (expand-home "~/Library/Services/DarkMode.workflow")))
    (if (= input "b")
      (do
        (desktop-xfce-set-theme :property "ThemeName" :theme "Arc-Maia-Dark")
        (desktop-xfce-set-theme :property "IconThemeName" :theme "Paper"))
      (do
        (desktop-xfce-set-theme :property "ThemeName" :theme "Mist")
        (desktop-xfce-set-theme :property "IconThemeName"
                                :theme "Paper-Mono-Dark")))))

;; chrome dark-mode plugin

(defn chrome-toggle-dark-mode-plugin! []
  (let [runtime          (Runtime/getRuntime)
        keys-dark-toggle [:alt :shift :d]
        keys-exit-chrome [:ctrl :q]]
    (if system-osx?
      (do (open-app! "Google\\ Chrome.app")
          (r/sleep 1200)
          (r/hot-keys! keys-dark-toggle))
      (do
        (.exec runtime "google-chrome-stable")
        (r/sleep 700)
        (r/hot-keys! keys-dark-toggle)
        (r/sleep 1000)
        (r/hot-keys! keys-exit-chrome)))))

;; telegram

;; TODO: parse pixel patterns or find api
(defn telegram-toggle-dark-mode! []
  (open-app! "telegram")
  (r/sleep 200)
  (r/mouse-move! 26 70)
  (r/sleep 350)
  (r/mouse-click!)
  (r/sleep 400)
  (r/mouse-move! 238 433)
  (r/mouse-click!))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]

  (let [input (first args)]
    (cond (= input "b")
         (do (zathura-uncomment-colors!)
             (spacemacs-set-theme! spacemacs-dark)
             (vim-set-theme! false)
             (desktop-set-theme! input))

         (= input "w")
         (do (zathura-comment-colors!)
             (spacemacs-set-theme! spacemacs-light)
             (vim-set-theme! true)
             (desktop-set-theme! input))

         :else
         (throw (IllegalArgumentException.
                 (str "unknown input " input ", expected: (b)lack or (w)hite")))))

  (chrome-toggle-dark-mode-plugin!)
  (telegram-toggle-dark-mode!)

  (System/exit 0) (comment due to https://dev.clojure.org/jira/browse/CLJ-959))

