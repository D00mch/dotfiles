(module plugin.nvim-surround
  {require {surr nvim-surround}})

(surr.setup
  {:surrounds
   { "(" {:add ["(" ")" ]}
     ")" {:add ["( "" )"]}
     "{" {:add ["{" "}" ]}
     "}" {:add ["{ "" }"]}
     "<" {:add ["<" ">" ]}
     ">" {:add ["< "" >"]}
     "[" {:add ["[" "]" ]}
     "]" {:add ["[ "" ]"]}
     "q" {:add ["“" "”" ]}
     "Q" {:add ["‘" "’" ]}
     "c" {:add ["#_"""  ]} }})
