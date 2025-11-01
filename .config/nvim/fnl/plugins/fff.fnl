{1 :dmtrKovalenko/fff.nvim
 :build (fn []
          ((. (require :fff.download) :download_or_build_binary)))
 :keys [{1 :ff
         2 (fn []
             ((. (require :fff) :find_in_git_root)))
         :desc "FFFind files"}]
 :lazy false
 :opts {:debug {:enabled true :show_scores true}}}	
