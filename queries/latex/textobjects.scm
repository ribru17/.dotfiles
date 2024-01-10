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

; TODO: Make a PR of the following.
[
  (generic_command)
  (text_mode)
] @call.outer

(text_mode
  (curly_group
    .
    "{"
    .
    (_) @_start
    (_)? @_end
    .
    "}")
  (#make-range! "call.inner" @_start @_end))

(generic_command
  (curly_group
    .
    "{"
    .
    (_) @_start
    (_)? @_end
    .
    "}")
  (#make-range! "call.inner" @_start @_end))
