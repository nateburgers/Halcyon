(** mls_comparable.ml *)

module type Signature = sig
    type t

    val compare : t -> t -> bool
end
