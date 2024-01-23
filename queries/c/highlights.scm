; extends
; TODO: Make a PR for this?
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
