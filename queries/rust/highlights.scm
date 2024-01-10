; extends
; Fixes an issue where function calls aren't properly recognized within a macro
(macro_invocation
  (token_tree
    (identifier) @function.call
    .
    (token_tree)))
