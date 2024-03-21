; extends

((identifier) @variable.builtin
  (#any-of? @variable.builtin "vim" "bit")
  (#set! "priority" 128))

(function_call
  name: (dot_index_expression) @_method
  arguments: (arguments
    .
    (_)
    .
    (string
      (string_content) @string.regexp))
  (#any-of? @_method "vim.split" "vim.gsplit"))
