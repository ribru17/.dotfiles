;; extends

[
 (anchor_begin)
 (anchor_end)
 "."
] @variable.builtin

((character "." @constant) @_
 (#has-parent? @_ set negated_set))

(class (escape_char)) @string.escape

(range) "-" @operator
