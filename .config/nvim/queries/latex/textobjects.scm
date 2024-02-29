; extends

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
