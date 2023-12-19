;; extends

; TODO: Remove upon merging of the following PR:
; https://github.com/nvim-treesitter/nvim-treesitter-textobjects/pull/534

; Text object `call` for constructors
((new_expression
  constructor: (identifier) @_cons
  arguments: (arguments . "(" . (_) @_start (_)? @_end . ")") @_args)
 (#make-range! "call.outer" @_cons @_args)
 (#make-range! "call.inner" @_start @_end))
