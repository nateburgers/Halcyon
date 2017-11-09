(** mls_avltree.mli *)

module      Int        = Mls_int
module      Optional   = Mls_optional
module type Comparable = Mls_comparable.Signature

module Make (Key : Comparable) : sig

    (* MODULES *)
    module Key : Comparable

    (* TYPES *)
    type 'value t

    (* FUNCTIONS *)
    val make_empty : unit -> 'value t

    val balance : 'value t -> int

    val height : 'value t -> int

    val insert : 'value t
              ->  key   :  Key.t
              ->  value : 'value
              -> 'value t

    val remove : 'value t
              ->  key : Key.t
              -> 'value t

    val lookup : 'value t
              ->  key : Key.t
              -> 'value Optional.t

end with module Key = Key
