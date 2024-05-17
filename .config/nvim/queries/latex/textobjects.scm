; extends

; TODO: Replace with quantified capture after nvim-treesitter 1.0
((inline_formula
  .
  "$"
  .
  (_) @_start
  (_)? @_end
  .
  "$" .) @math.outer
  (#make-range! "math.inner" @_start @_end))

((displayed_equation
  .
  "$$"
  .
  (_) @_start
  (_)? @_end
  .
  "$$" .) @math.outer
  (#make-range! "math.inner" @_start @_end))
