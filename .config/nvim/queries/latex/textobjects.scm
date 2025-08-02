; extends

(inline_formula
  .
  "$"
  _+ @math.inner
  "$" .) @math.outer

(displayed_equation
  .
  "$$"
  _+ @math.inner
  "$$" .) @math.outer
