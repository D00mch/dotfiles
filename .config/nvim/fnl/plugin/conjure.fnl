(module plugin.conjure
  {require {nvim aniseed.nvim}})

(set nvim.g.conjure#log#wrap true)
(set nvim.g.conjure#eval#result_register "*")
(set nvim.g.conjure#log#botright true)
(set nvim.g.conjure#mapping#doc_word "hh")
(set nvim.g.conjure#mapping#eval_visual "ev")
(set nvim.g.conjure#mapping#eval_file "eb")
(set nvim.g.conjure#mapping#eval_root_form "ef")
(set nvim.g.conjure#mapping#eval_comment_current_form "sf")
(set nvim.g.conjure#extract#tree_sitter#enabled true)

