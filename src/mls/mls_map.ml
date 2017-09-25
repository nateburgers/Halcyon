(** mls_map.ml *)

module Avl_tree = Mls_avltree

module Make (Key : Comparable) = struct
    module Key      = Key
    module Avl_tree = Avl_tree.Make (Key)

    type  key     =  Key.t
    type 'value t = 'value Avl_tree.t

    let empty () = Avl_tree.empty ()
end
