;; extends

; TODO: Remove upon merging of the following PR:
; https://github.com/nvim-treesitter/nvim-treesitter-textobjects/pull/535
(macro_invocation) @call.outer
(macro_invocation (token_tree . "(" . (_) @_start (_)? @_end . ")"
  (#make-range! "call.inner" @_start @_end)))

; Fixes an issue where function calls aren't properly recognized within a macro
(macro_invocation (token_tree
 (identifier) @_start .
 (token_tree . "(" .
  (_) @_innerstart (_)? @_innerend . ")") @_end)
   (#make-range! "call.inner" @_innerstart @_innerend)
   (#make-range! "call.outer" @_start @_end))
