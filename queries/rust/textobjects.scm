;; extends

; TODO: Remove upon merging of the following PR:
; https://github.com/nvim-treesitter/nvim-treesitter-textobjects/pull/535

(macro_invocation) @call.outer
(macro_invocation (token_tree . "(" . (_) @_start (_)? @_end . ")"
  (#make-range! "call.inner" @_start @_end)))
