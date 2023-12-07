;; extends

; TODO: Make a PR for this in the textobjects repo.

; Text object `call` for constructors
((new_expression
  constructor: (identifier) @_cons
  arguments: (arguments . "(" . (_) @_start (_)? @_end . ")") @_args)
 (#make-range! "call.outer" @_cons @_args)
 (#make-range! "call.inner" @_start @_end))
