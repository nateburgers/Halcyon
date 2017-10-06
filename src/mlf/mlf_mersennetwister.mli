(** mlf_mersennetwister.mli *)

type t

val make : int -> t

val next : t -> int * t
