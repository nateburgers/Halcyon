(** mls_regex.mli *)

type ('a, 'b) choice = Left  of 'a
                     | Right of 'b

(** TODO(nate): given any lens to a traversable, we can minimize the DFA to
 *              search through the structure.  Traversable should mean
 *              something like foldable, hopefully.
 *)
type (_, _) regex =
    | Nothing       : ('a, unit) regex
    | Empty         : ('a, unit) regex
    | Character     : ('a -> 'b option) -> ('a, 'b) regex
    | Map           : ('a, 'b) regex -> ('b -> 'c) -> ('a, 'c) regex
    | KleeneClosure : ('a, 'b) regex -> ('a, 'b list) regex
    | Concatenation : ('a, 'b) regex -> ('a, 'c) regex -> ('a, 'b * 'c) regex
    | Disjunction   : ('a, 'b) regex -> ('a, 'b) regex -> ('a, 'b) regex
    | Conjunction   : ('a, 'b) regex -> ('a, 'c) regex -> ('a, 'b) regex
    | Complement    : ('a, 'b) regex -> ('a,  unit regex)

type 'a denormalized
type 'a normalized
type 'a compiled

type 'a t      = 'a denormalized regex
type 'a normal = 'a normalized regex

val nothing : unit t

val empty : unit t

val char : char -> char t

val star : 'a t -> 'a list t

val concatenate : t -> t -> t

val or : t -> t -> t

val and : t -> t -> t

val not : t -> t -> t

val normalize : t -> t

module Infix : sig

end
