(** mls_regex.ml *)

type t = Nothing
       | EmptyString
       | Character     of char
       | KleeneStar    of t
       | Concatenation of t * t
       | LogicalOr     of t * t
       | LogicalAnd    of t * t
       | Complement    of t

let nothing = Nothing

let empty = EmptyString

let char c = Character c

let star regex = KleeneStar regex

let
