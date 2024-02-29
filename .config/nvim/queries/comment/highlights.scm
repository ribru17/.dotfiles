; extends

((tag
  (name) @keyword
  ":" @punctuation.delimiter)
  .
  "text" @type
  (#eq? @keyword "INJECT"))
