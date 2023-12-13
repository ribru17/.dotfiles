;; extends

; Text object `call` for `sizeof` expressions

(sizeof_expression
 value: (parenthesized_expression . "(" . (_) @_start (_)? @_end . ")"
 (#make-range! "call.inner" @_start @_end))) @call.outer

(sizeof_expression
 type: (type_descriptor) @call.inner) @call.outer
