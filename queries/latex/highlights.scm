; extends
(math_environment
  (begin
    command: _ @markup.environment
    name:
      (curly_group_text
        (_) @markup.environment.name)))

(math_environment
  (end
    command: _ @markup.environment
    name:
      (curly_group_text
        (_) @markup.environment.name)))
