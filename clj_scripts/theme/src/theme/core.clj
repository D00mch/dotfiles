(ns theme.core
  (:gen-class)
  (:require [clojure.string :as str]
            [clojure.java.shell :refer [sh]]
            [robot.core :as r]))

(def system-osx?
  (= "Mac OS X" (System/getProperty "os.name")))

(defn open-app! [app-name]
  (sh "sh" "-c" (str "open -a " app-name)))

(defn app-opened? [app-name app-path]
  (if system-osx?
    (let [shell-oputput (sh "sh" "-c" (str "ps ax | grep " app-name))
          shell-res     (str/replace (:out shell-oputput) #"sh -c ps ax.*" "")]
      #_(prn (str "having text as " shell-res))
      (.contains ^String shell-res app-path))
    (throw (UnsupportedOperationException.))))

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

(def zathura (expand-home "~/.config/zathura/zathurarc"))

(defn zathura-change-colors-with! [f path]
  (let [lines (file-by-lines path)
        [s title colors] (partition-by #(.contains ^String % "Colours") lines)
        colors' (map f colors)]
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

;; ideas
(defn studio-opened? []
  (app-opened? "'Android Studio'" "Studio.app/Contents/MacOS/"))

(defn idea-opened? []
  (app-opened? "IntelliJ" "Contents/MacOS/idea"))

(defn idea-set-theme! [idea-name theme-num]
    (open-app! idea-name)
    (r/sleep 220)
    (r/hot-keys! [:cmd :shift :a])
    (r/sleep 320)
    (r/type-text! "Theme")
    (r/sleep 400)
    (r/type! :enter)
    (r/sleep 200)
    (r/type-text! theme-num))

(defn intellij-set-theme! [is-black?]
  (when (idea-opened?)
    (idea-set-theme! "IntelliJ\\ IDEA\\ CE" (if is-black? "3" "1"))))

(defn android-set-theme! [is-black?]
  (when (studio-opened?)
    (idea-set-theme! "Android\\ Studio" (if is-black? "2" "1"))))

;; spacemacs

(def spacemacs (expand-home "~/dotfiles/.spacemacs"))
(def spacemacs-light "doom-one-light")
(def spacemacs-dark "doom-tomorrow-night")

(defn spacemacs-opened? []
  (app-opened? "emacs" "/Emacs.app"))

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
(defn vim-theme [light?] (if light? "PaperColor" "PaperColor"))

(defn vim-set-theme! [light?]
  (->> (file-by-lines vim)
       (map (fn [line]
              (cond #_(.contains ^String line "colorscheme")
                    #_(str "colorscheme " (vim-theme light?)),
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
      "osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'"
      )
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
  (let [runtime (Runtime/getRuntime)
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
  (when (empty? (:err (open-app! "telegram")))
    (r/sleep 240)
    (r/mouse-move! 26 70)
    (r/sleep 370)
    (r/mouse-click!)
    (r/sleep 450)
    (r/mouse-move! 272 469)
    (r/mouse-click!)))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]

  (let [input (first args)]
    (cond (= input "b")
          (do (zathura-uncomment-colors!)
              #_(spacemacs-set-theme! spacemacs-dark)
              #_(vim-set-theme! false)
              (desktop-set-theme! input)

              ;; use Dark Mode Sync plugin instead
              #_(intellij-set-theme! true)
              (android-set-theme! true))

          (= input "w")
          (do (zathura-comment-colors!)
              #_(spacemacs-set-theme! spacemacs-light)
              #_(vim-set-theme! true)
              (desktop-set-theme! input)

              ;; use Dark Mode Sync plugin instead
              #_(intellij-set-theme! false)
              (android-set-theme! false))

          :else
          (throw (IllegalArgumentException.
                   (str "unknown input " input ", expected: (b)lack or (w)hite")))))

  (chrome-toggle-dark-mode-plugin!)
  (telegram-toggle-dark-mode!)

  (System/exit 0) (comment due to https://dev.clojure.org/jira/browse/CLJ-959))

