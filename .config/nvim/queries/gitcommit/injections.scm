; extends

((subject) @injection.content
  (#set! injection.language "markdown_inline"))

((message_line) @injection.content
  (#set! injection.language "markdown")
  (#set! injection.combined))
