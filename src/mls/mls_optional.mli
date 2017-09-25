(** mls_optional.mli *)

type 'value t = Value of 'value
              | Nothing

val nothing : unit -> 'value t

val make : 'value -> 'value t
