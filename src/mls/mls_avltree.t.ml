(** mls_avltree.t.ml *)

module Comparable_int =
    struct
        type t = int;

        let compare : t -> t -> bool =
            fun x y => x < y
    end

module Avl_tree = Mls_avltree.Make (Comparable_int)

let empty = Avl_tree.empty ()
