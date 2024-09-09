; extends

((subject) @injection.content
  (#set! injection.language "markdown_inline"))

(source
  (subject)
  .
  (message) @injection.content
  (#set! injection.language "markdown")
  (#set! injection.include-children))
