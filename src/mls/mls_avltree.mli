(** mls_avltree.mli *)

module      Int        = Mls_int
module      Optional   = Mls_optional
module type Comparable = Mls_comparable.Signature

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

    module Tree : sig
        type 'value t = 'value Tree_type.t
                      = Branch of 'value Branch_type.t
                      | Leaf   of 'value Leaf_type.t
                      | Empty
    end

    module Branch : sig
        type 'value t = 'value Branch_type.t

        val height      : 'value t ->  int
        val key         : 'value t ->  Key.t
        val value       : 'value t -> 'value
        val left_child  : 'value t -> 'value Tree.t
        val right_child : 'value t -> 'value Tree.t
    end

    module Leaf : sig
        type 'value t = 'value Leaf_type.t

        val key   : 'value t -> Key.t
        val value : 'value t -> 'value
    end

    (* TYPES *)
    type  key          =  Key.t
    type 'value branch = 'value Branch.t
    type 'value leaf   = 'value Leaf.t
    type 'value t      = 'value Tree.t

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

    val is_avl         : 'value t -> bool
    val is_balanced    : 'value t -> bool
    val is_left_heavy  : 'value t -> bool
    val is_right_heavy : 'value t -> bool

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

    val rebalance : 'value t -> 'value t
    (**
     * Given a tree with children that satisfy the AVL invariant, rebalance
     * this tree such that it satisfies the avl invariant.  Return the value
     * unmodified if the value is a leaf or empty.  The behavior is undefined
     * if the value has subtrees that violate the AVL invariant.
     *)

    val insert : 'value t -> key:key -> value:'value -> 'value t

    val lookup : 'value t -> key:key -> 'value Optional.t

    val rotate_left       : 'value t -> 'value t
    val rotate_right      : 'value t -> 'value t
    val rotate_left_right : 'value t -> 'value t
    val rotate_right_left : 'value t -> 'value t

end with module Key = Key
