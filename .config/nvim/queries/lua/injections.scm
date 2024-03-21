; extends

(function_call
  name: (dot_index_expression) @_method
  arguments: (arguments
    .
    (_)
    .
    (string
      (string_content) @injection.content))
  (#any-of? @_method "vim.split" "vim.gsplit")
  (#set! injection.language "luap"))

; Arbitrary string injections using `--> INJECT: <parser>`
(_
  (comment
    (comment_content) @injection.language)
  .
  (string
    (string_content) @injection.content)
  (#gsub! @injection.language "^> INJECT: ([%w_]+)$" "%1"))

(_
  (comment
    (comment_content) @injection.language)
  .
  (field
    value: (string
      (string_content) @injection.content))
  (#gsub! @injection.language "^> INJECT: ([%w_]+)$" "%1"))

(_
  (comment
    (comment_content) @injection.language)
  .
  (variable_declaration
    (assignment_statement
      (expression_list
        (string
          (string_content) @injection.content))))
  (#gsub! @injection.language "^> INJECT: ([%w_]+)$" "%1"))

(_
  (comment
    (comment_content) @injection.language)
  .
  (assignment_statement
    (expression_list
      (string
        (string_content) @injection.content)))
  (#gsub! @injection.language "^> INJECT: ([%w_]+)$" "%1"))
