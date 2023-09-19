;; extends

; Bullet points
([(list_marker_minus) (list_marker_star)] @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "•"))
(list
 (list_item
   (list
     (list_item
       ([(list_marker_minus) (list_marker_star)] @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "⭘"))
       ))))
(list
 (list_item
   (list
     (list_item
       (list
         (list_item
           ([(list_marker_minus) (list_marker_star)] @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "◼"))
           ))))))
(list
 (list_item
  (list
    (list_item
      (list
        (list_item
          (list
            (list_item
              ([(list_marker_minus) (list_marker_star)] @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "◻"))
              ))))))))
(list
 (list_item
  (list
    (list_item
      (list
        (list_item
          (list
            (list_item
              (list
                (list_item
                  ([(list_marker_minus) (list_marker_star)] @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "→"))
                  ))))))))))

; Checkbox list items
((task_list_marker_unchecked) @text.todo.unchecked (#offset! @text.todo.unchecked 0 -2 0 0) (#set! conceal "✗"))
((task_list_marker_checked) @text.todo.checked (#offset! @text.todo.checked 0 -2 0 0) (#set! conceal "✔"))
(list_item (task_list_marker_checked)) @comment

; Tables
(pipe_table_header ("|") @punctuation.special @conceal (#set! conceal "┃"))
(pipe_table_delimiter_row ("|") @punctuation.special @conceal (#set! conceal "┃"))
(pipe_table_delimiter_cell ("-") @punctuation.special @conceal (#set! conceal "━"))
((pipe_table_align_left) @punctuation.special @conceal (#set! conceal "┣"))
((pipe_table_align_right) @punctuation.special @conceal (#set! conceal "┫"))
(pipe_table_row ("|") @punctuation.special @conceal (#set! conceal "┃"))

; Block quotes
((block_quote_marker) @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "▐"))
((block_continuation) @punctuation.special (#eq? @punctuation.special "> ") (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "▐"))
((block_continuation) @punctuation.special (#eq? @punctuation.special ">") (#set! conceal "▐"))

; Headers
((atx_h1_marker) @text.title (#set! conceal "1"))
((atx_h2_marker) @text.title (#set! conceal "2"))
((atx_h3_marker) @text.title (#set! conceal "3"))
((atx_h4_marker) @text.title (#set! conceal "4"))
((atx_h5_marker) @text.title (#set! conceal "5"))
((atx_h6_marker) @text.title (#set! conceal "6"))
