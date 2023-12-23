;; extends

; Highlight `command` commands.
; TODO: Make a PR for this.
(command
  name: (command_name) @_name
  .
  argument: (word) @function.call
  (#eq? @_name "command"))
