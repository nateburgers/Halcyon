(** mls_avltree.mli *)

module type Comparable = Mls_comparable.Signature

module Optional : sig
    type 'value t = Value of 'value
                  | Nothing

    val nothing : unit -> 'value t

    val make : 'value -> 'value t
end

module Int : sig
    type t = int

    val greater : t -> t -> t
end

module Make (Key : Comparable) : sig

    module Key : Comparable

    (* MODULES *)
    module rec Tree_type : sig
        type 'value t = Branch of 'value Branch_type.t
                      | Leaf   of 'value Leaf_type.t
                      | Empty
    end

    and Branch_type : sig
        type 'value t = {
            height      :  int               ;
            key         :  Key.t             ;
            value       : 'value             ;
            left_child  : 'value Tree_type.t ;
            right_child : 'value Tree_type.t ;
        }
    end

    and Leaf_type : sig
        type 'value t = {
            key   :  Key.t ;
            value : 'value ;
        }
    end

    (* TYPES *)
    type  key          =  Key.t
    type 'value branch = 'value Branch_type.t
    type 'value leaf   = 'value Leaf_type.t
    type 'value t      = 'value Tree_type.t

    (* FUNCTIONS *)
    val empty : unit -> 'value t ;;

    val make :  key         :  key
            ->  value       : 'value
            -> ?left_child  : 'value t Optional.t
            -> ?right_child : 'value t Optional.t
            -> 'value t

    val make_leaf :  key   :  key
                 ->  value : 'value
                 -> 'value t

    val make_branch :  key         :  key
                   ->  value       : 'value
                   ->  left_child  : 'value t
                   ->  right_child : 'value t
                   -> 'value t

    val balance : 'value t -> int
    val height  : 'value t -> int

    val key : 'value t -> key Optional.t
    (**
     * Return the key of the top level node in the tree if the tree is
     * non-empty, otherwise return nothing.
     *)

    val value : 'value t -> 'value Optional.t
    (**
     * Return the value of the top level node in the tree if the tree is
     * non-empty, otherwise return nothing.
     *)

    val left_child  : 'value t -> 'value t
    (**
     * Return the left child of the tree if the tree is a branch, otherwise
     * return an empty tree.
     *)

    val right_child : 'value t -> 'value t
    (**
     * Return the right child of the tree if the tree is a branch, otherwise
     * return an empty tree.
     *)

    (*
    val rebalance : 'value t -> 'value t
    *)

    val insert : 'value t -> key:key -> value:'value -> 'value t

    val lookup : 'value t -> key:key -> 'value Optional.t

    val rotate_left       : 'value t -> 'value t
    val rotate_right      : 'value t -> 'value t
    val rotate_left_right : 'value t -> 'value t
    val rotate_right_left : 'value t -> 'value t

end with module Key = Key
