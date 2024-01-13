; extends
(function_call
  name: (dot_index_expression) @_method
  arguments:
    (arguments
      .
      (_)
      .
      (string
        (string_content) @injection.content))
  (#any-of? @_method "vim.split" "vim.gsplit")
  (#set! injection.language "luap"))
