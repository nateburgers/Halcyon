(** mls_comparable.mli *)

module type Signature = sig
    type t

    val compare : t -> t -> bool
end
