; extends

(sizeof_expression
  value: (parenthesized_expression
    .
    "("
    _+ @call.inner
    ")")) @call.outer

(sizeof_expression
  type: (type_descriptor) @call.inner) @call.outer
