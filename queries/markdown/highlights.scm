;; extends

; bullet points
([(list_marker_minus) (list_marker_star)] @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "•"))

; Checkbox list items
((task_list_marker_unchecked) @text.todo.unchecked (#offset! @text.todo.unchecked 0 -2 0 0) (#set! conceal "✗"))
((task_list_marker_checked) @text.todo.checked (#offset! @text.todo.checked 0 -2 0 0) (#set! conceal "✔"))
(list_item (task_list_marker_checked)) @comment

; Use box drawing characters for tables
(pipe_table_header ("|") @punctuation.special @conceal (#set! conceal "┃"))
(pipe_table_delimiter_row ("|") @punctuation.special @conceal (#set! conceal "┃"))
(pipe_table_delimiter_cell ("-") @punctuation.special @conceal (#set! conceal "━"))
(pipe_table_row ("|") @punctuation.special @conceal (#set! conceal "┃"))

; Block quotes
((block_quote_marker) @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "▐"))
(block_quote
  (_
    (_
      (block_continuation) @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "▐")
      ))
  )
(block_quote
  (_
    (_
      (_
        (block_continuation) @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "▐")
        )
      ))
  )
(block_quote
  (_
    ((_
       (_
         (block_continuation) @punctuation.special (#set! conceal "▐")
         )
       )) .
    )
  )
(block_quote
  (_
    (block_continuation) @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "▐")
    )
  )
(block_quote
  (_
    (
     (block_continuation) @punctuation.special (#set! conceal "▐") 
     ) .
    )
  )
(block_quote
  (_)*
  (block_continuation) @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "▐")
  )
