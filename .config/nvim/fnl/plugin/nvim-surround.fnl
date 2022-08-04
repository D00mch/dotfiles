(module plugin.nvim-surround
  {require {surr nvim-surround}})

(surr.setup
  {:delimiters 
   {:pairs 
    {"(" ["("  ")"]
     ")" ["( " " )"]
     "{" ["{"  "}"]
     "}" ["{ " " }"]
     "<" ["<"  ">"]
     ">" ["< " " >"]
     "[" ["["  "]"]
     "]" ["[ " " ]"]
     "c" ["#_" ""]}}})
