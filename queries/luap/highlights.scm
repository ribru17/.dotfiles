;; extends

[
 "."
 (anchor_begin)
 (anchor_end)
] @variable.builtin

((character "." @constant)
 (#has-ancestor? @constant set negated_set)
 )

(class (escape_char)) @string.escape

(range) "-" @operator
