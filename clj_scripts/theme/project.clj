(defproject theme "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url "https://www.eclipse.org/legal/epl-2.0/"}
  :dependencies [[org.clojure/clojure "1.11.0"]
                 [robot "0.2.1-SNAPSHOT"]]
  :main ^:skip-aot theme.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
