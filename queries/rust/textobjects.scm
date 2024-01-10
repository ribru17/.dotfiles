; extends
; Fixes an issue where function calls aren't properly recognized within a macro
(macro_invocation
  (token_tree
    (identifier) @_start
    .
    (token_tree
      .
      "("
      .
      (_) @_innerstart
      (_)? @_innerend
      .
      ")") @_end)
  (#make-range! "call.inner" @_innerstart @_innerend)
  (#make-range! "call.outer" @_start @_end))
