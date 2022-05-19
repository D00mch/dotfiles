(module plugin.rooter
  {require {nvim aniseed.nvim
            util util}})

(set nvim.g.rooter_patterns [".git" "deps.edn" "project.clj" "package.json" "pubspec.yaml" 
                             "settings.gradle.kts" "settings.gradle"])
