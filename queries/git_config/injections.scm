; extends
; Alias bash injections
; TODO: Remove after PR merge
(section
  (section_header
    (section_name) @_section)
  (variable
    value: (string) @injection.content)
  (#eq? @_section "alias")
  (#lua-match? @injection.content "^!")
  (#offset! @injection.content 0 1 0 0)
  (#set! injection.language "bash"))

(section
  (section_header
    (section_name) @_section)
  (variable
    value:
      (string
        "\""
        "\"") @injection.content)
  (#eq? @_section "alias")
  (#lua-match? @injection.content "^\"!")
  (#offset! @injection.content 0 2 0 -1)
  (#set! injection.language "bash"))
