(ns theme.core
  (:gen-class)
  (:require [clojure.string :as str]
            [clojure.java.shell :use [sh]])
  (:import (java.awt ^Robot Robot MouseInfo)
           (java.awt.event InputEvent KeyEvent)))

(def system-osx?
  (= "Mac OS X" (System/getProperty "os.name")))

;; robot

(def robot (Robot.))

(defn robot-hot-keys! [keys]
  (doseq [key keys]
    (doto ^Robot robot
      (.keyPress key)
      (.delay 10)))
  (.delay ^Robot robot 100)
  (doseq [key (reverse keys)] (.keyRelease ^Robot robot key)))

(defn robot-print! [^String s]
  (doseq [byte (.getBytes s)
          :let [code (int byte)
                code (if (< 96 code 123) (- code 32) code)]]
    (doto ^Robot robot
      (.delay 50)
      (.keyPress code)
      (.delay 10)
      (.keyRelease code))))

(defn robot-type! [^Integer i]
  (doto ^Robot robot
    (.delay 40)
    (.keyPress i)
    (.keyRelease i)))

(defn robot-mouse-click! []
  (doto ^Robot robot
    (.mousePress InputEvent/BUTTON1_DOWN_MASK)
    (.delay 70)
    (.mouseRelease InputEvent/BUTTON1_DOWN_MASK)))

(defn robot-mouse-pos []
  (let [mouse-info (.. MouseInfo getPointerInfo getLocation)]
    [(. mouse-info x) (. mouse-info y)]))

(defn robot-mouse-move!
  ([[x y]] (robot-mouse-move! x y))
  ([x y] (.mouseMove ^Robot robot x y)))

(defn robot-mac-open! [app-name]
  (do
    (robot-hot-keys! [KeyEvent/VK_META KeyEvent/VK_SPACE])
    (.delay ^Robot robot 100)
    (robot-print! (str app-name "\n"))))

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
  (let [shell-oputput (clojure.java.shell/sh "sh" "-c" "ps ax | grep emacs")
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
        (robot-mac-open! "emacs")
        (.delay ^Robot robot 100)
        (robot-type! KeyEvent/VK_ESCAPE)
        (.delay ^Robot robot 100)
        (robot-type! KeyEvent/VK_SPACE)
        (.delay ^Robot robot 100)
        (robot-type! KeyEvent/VK_SPACE)
        (.delay ^Robot robot 100)
        (robot-print! (str "load-theme\n"))
        (.delay ^Robot robot 100)
        (robot-print! (str theme "\n"))
        (.delay ^Robot robot 150)
        (robot-type! KeyEvent/VK_ENTER)))))

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
        keys-dark-toggle [KeyEvent/VK_ALT KeyEvent/VK_SHIFT KeyEvent/VK_D]
        keys-exit-chrome [KeyEvent/VK_CONTROL KeyEvent/VK_Q]]
    (if system-osx?
      (do (robot-mac-open! "chrome")
          (.delay ^Robot robot 200)
          (robot-hot-keys! keys-dark-toggle))
      (do
        (.exec runtime "google-chrome-stable")
        (.delay ^Robot robot 700)
        (robot-hot-keys! keys-dark-toggle)
        (.delay ^Robot robot 1000)
        (robot-hot-keys! keys-exit-chrome)))))

;; telegram

;; TODO: parse pixel patterns or find api
(defn telegram-toggle-dark-mode! []
  (robot-mac-open! "telegram")
  (.delay ^Robot robot 100)
  (robot-mouse-move! 26 70)
  (.delay ^Robot robot 250)
  (robot-mouse-click!)
  (.delay ^Robot robot 400)
  (robot-mouse-move! 238 433)
  (robot-mouse-click!))

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
