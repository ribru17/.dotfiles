; extends
; Highlight `command` commands.
(command
  name: (command_name) @_name
  .
  argument: (word) @function.call
  (#eq? @_name "command"))
