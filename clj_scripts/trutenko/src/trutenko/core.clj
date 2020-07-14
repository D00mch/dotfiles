(ns trutenko.core
  (:gen-class)
  (:require [clojure.string :as str]
            [robot.core :as r]
            [clojure.java.shell :use [sh]]))

(defn open-app! [app-name]
  (sh "sh" "-c" (str "open -a " app-name)))

(defn notify! []
  (open-app! "slack")
  (r/delay 300)
  (r/hot-keys! [:cmd :shift :k])
  (r/delay 500)
  (r/clipboard-put "Trutenko")
  (r/hot-keys! [:cmd :v])
  (r/delay 700)
  (r/type! :enter)
  (r/type! :enter)
  (r/delay 300)
  (r/clipboard-put "Привет, это робот Артура. Напоминаю тебе про стендап #staros. Хорошего дня!")
  (r/hot-keys! [:cmd :v])
  (r/delay 200)
  (r/type! :enter))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "about to notify Trutenko")
  (notify!)
  (System/exit 0))

