; extends

; These are technically type specifiers, not qualifiers, but it looks better
; this way imo.
(sized_type_specifier
  [
    "signed"
    "unsigned"
  ] @type.qualifier
  (_)+)

(sized_type_specifier
  (_)+
  [
    "signed"
    "unsigned"
  ] @type.qualifier)
