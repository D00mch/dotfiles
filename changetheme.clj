#! /usr/bin/env clojure

;; setting common dependencies

(require '[clojure.string :as str])

;; robot help functions

(import java.awt.Robot)
(import java.awt.event.KeyEvent)

(def robot (Robot.))

(defn robot-hot-keys [keys]
  (doseq [key keys] (.keyPress robot key))
  (.delay robot 60)
  (doseq [key keys] (.keyRelease robot key)))

(defn robot-print [^String s]
  (for [byte (.getBytes s)
        :let [code (int byte)
              code (if (< 96 code 123) (- code 32) code)]]
    (doto robot
      (.delay 5)
      (.keyPress code)
      (.keyRelease code))))

(defn robot-type [^Integer i]
  (doto robot
    (.delay 40)
    (.keyPress i)
    (.keyRelease i)))

;; file help functions

(defn expand-home [s]
  (if (.startsWith s "~")
    (clojure.string/replace-first s "~" (System/getProperty "user.home"))
    s))

(defn file-by-lines [f-name]
  (str/split (slurp f-name) #"\n"))

(defn write-lines [f-name lines]
  (->> (str/join "\n" lines) (spit f-name)))

;; zathura

(def zathura (expand-home "~/dotfiles/.config/zathura/zathurarc"))

(defn zathura-change-colors-with [f path]
  (let [lines           (file-by-lines path)
       [s title colors] (partition-by #(.contains % "Colours") lines)
       colors'          (map f colors)]
    (->> (concat s title colors')
         (write-lines path))))

(defn zathura-comment-colors []
  (zathura-change-colors-with #(if (= "set" (re-find #"\w+" %))
                                 (str "#" %)
                                 %)
                              zathura))

(defn zathura-uncomment-colors []
  (zathura-change-colors-with #(if (= "#set" (re-find #"#\w+" %))
                                 (subs % 1)
                                 %)
                              zathura))

;; spacemacs

(def spacemacs (expand-home "~/dotfiles/.spacemacs"))
(def spacemacs-light "doom-one-light")
(def spacemacs-dark  "doom-tomorrow-night")

;; TODO: check if spacemacs is opened,
;; than press alt+m  -> load-theme -> doom-one-light -> enter -> y

(defn spacemacs-set-theme [theme]
  ;; (do
  ;;   (.delay robot 400)
  ;;   (robot-hot-keys [KeyEvent/VK_ALT KeyEvent/VK_X])
  ;;   (.delay robot 100)
  ;;   (robot-print (str "load-theme\n" theme "\n")))
  (->> (file-by-lines spacemacs)
       (map (fn [line]
              (if (.contains line "dotspacemacs-themes ")
                (str "   dotspacemacs-themes '(" theme)
                line)))
       (write-lines spacemacs)))

;; desktop theme

(use '[clojure.java.shell :only [sh]])

(defn desktop-set-theme [theme]
  (clojure.java.shell/sh
   "sh"
   "-c"
   (str "xfconf-query -c xsettings -p /Net/ThemeName -s " theme)))

;; chrome dark-mode plugin

(defn chrome-toggle-dark-mode-plugin []
  (let [runtime          (Runtime/getRuntime)
        keys-dark-toggle [KeyEvent/VK_SHIFT KeyEvent/VK_ALT KeyEvent/VK_D]
        keys-exit-chrome [KeyEvent/VK_CONTROL KeyEvent/VK_Q]]
    (.exec runtime "google-chrome-stable")
    (.delay robot 700)
    (robot-hot-keys keys-dark-toggle)
    (.delay robot 1000)
    (robot-hot-keys keys-exit-chrome)))

;; apply themes

(def input (first *command-line-args*))

(cond (= input "b")
      (do (zathura-uncomment-colors)
          (spacemacs-set-theme spacemacs-dark)
          (desktop-set-theme "Matcha-dark-sea")
          (chrome-toggle-dark-mode-plugin)
          )

      (= input "w")
      (do (zathura-comment-colors)
          (spacemacs-set-theme spacemacs-light)
          (desktop-set-theme "Mist")
          (chrome-toggle-dark-mode-plugin)
          )

      :else
      (throw (IllegalArgumentException.
              (str "unknown input " input ", expected: (b)lack or (w)hite"))))

(System/exit 0) ;; due to https://dev.clojure.org/jira/browse/CLJ-959
