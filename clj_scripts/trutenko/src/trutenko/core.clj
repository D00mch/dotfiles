(ns trutenko.core
  (:gen-class)
  (:require [clojure.string :as str]
            [clojure.java.shell :use [sh]])
  (:import (java.awt ^Robot Robot ^Toolkit Toolkit)
           (java.awt.datatransfer ^Clipboard Clipboard ^StringSelection StringSelection)
           (java.awt.event KeyEvent)))

(defn open-app! [app-name]
  (sh "sh" "-c" (str "open -a " app-name)))

(def ^Robot robot (Robot.))
(def ^Clipboard clipboard (.. Toolkit getDefaultToolkit getSystemClipboard))

(defn robot-hot-keys! [keys]
  (doseq [key keys]
    (doto ^Robot robot
      (.keyPress key)
      (.delay 10)))
  (.delay ^Robot robot 100)
  (doseq [key (reverse keys)] (.keyRelease ^Robot robot key)))

(defn robot-put-into-clipboard [^String s]
  (.setContents clipboard (StringSelection. ^String s) nil))

(defn robot-type! [^Integer i]
  (doto ^Robot robot
    (.delay 40)
    (.keyPress i)
    (.keyRelease i)))

(defn notify! []
  (open-app! "slack")
  (.delay ^Robot robot 300)
  (robot-hot-keys! [KeyEvent/VK_META KeyEvent/VK_SHIFT KeyEvent/VK_K])
  (.delay ^Robot robot 300)
  (robot-put-into-clipboard "Trutenko")
  (robot-hot-keys! [KeyEvent/VK_META KeyEvent/VK_V])
  (.delay ^Robot robot 400)
  (robot-type! KeyEvent/VK_ENTER)
  (.delay ^Robot robot 400)
  (robot-put-into-clipboard "Привет, это робот Артура. Напоминаю тебе про стендап #staros. Хорошего дня!")
  (robot-hot-keys! [KeyEvent/VK_META KeyEvent/VK_V])
  (.delay ^Robot robot 200)
  (robot-type! KeyEvent/VK_ENTER))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "about to notify Trutenko")
  (notify!)
  (System/exit 0))
