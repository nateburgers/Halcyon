(** mls_avltree.ml *)

module type Comparable = Mls_comparable.Signature

module Optional = struct
    type 'value t = Value of 'value
                  | Nothing

    let nothing () =
        Nothing

    let make value =
        Value value
end

module Int = struct
    type t = int

    let greater lhs rhs =
        if lhs > rhs then lhs else rhs
end

module Make (Key : Comparable) = struct

    (* MODULES *)
    module Key = Key

    module rec Tree_type : sig
        type 'value t = Branch of 'value Branch_type.t
                      | Leaf   of 'value Leaf_type.t
                      | Empty
    end = Tree_type

    and Branch_type : sig
        type 'value t = {
            height      :  int               ;
            key         :  Key.t             ;
            value       : 'value             ;
            left_child  : 'value Tree_type.t ;
            right_child : 'value Tree_type.t ;
        }
    end = Branch_type

    and Leaf_type : sig
        type 'value t = {
            key   :  Key.t ;
            value : 'value ;
        }
    end = Leaf_type

    (* TYPES *)
    type  key          =  Key.t
    type 'value branch = 'value Branch_type.t
    type 'value leaf   = 'value Leaf_type.t
    type 'value t      = 'value Tree_type.t

    (* FUNCTIONS *)
    let key tree =
        let open Tree_type in
        begin match tree with
        | Branch { key } -> Optional.make key
        | Leaf   { key } -> Optional.make key
        | Empty          -> Optional.nothing ()
        end

    let value tree =
        let open Tree_type in
        begin match tree with
        | Branch { value } -> Optional.make value
        | Leaf   { value } -> Optional.make value
        | Empty            -> Optional.nothing ()
        end

    let height tree =
        let open Tree_type in
        begin match tree with
        | Branch branch -> branch.height
        | Leaf   _      -> 1
        | Empty         -> 0
        end

    let balance tree =
        let open Tree_type in
        begin match tree with
        | Branch { left_child ; right_child } ->
                (height right_child) - (height left_child)
        | Leaf  _ -> 0
        | Empty _ -> 0
        end

    let empty () =
        Tree_type.Empty

    let make_leaf ~key ~value =
        let open Tree_type in
        let open Leaf_type in Leaf { key ; value }

    let make_branch ~key ~value ~left_child ~right_child =
        let left_child_height  = height left_child in
        let right_child_height = height right_child in
        let node_height        = 1 + Int.greater left_child_height
                                                 right_child_height in
        let open Branch_type in Tree_type.Branch {
            height = node_height; key; value; left_child; right_child
        }

    let make ~key ~value ?(left_child  = Optional.Nothing)
                         ?(right_child = Optional.Nothing) =
        begin match (left_child, right_child) with
        | (Optional.Nothing, Optional.Nothing) ->
                make_leaf ~key:key ~value:value
        | (Optional.Nothing, Optional.Value right) ->
                make_branch ~key:key
                            ~value:value
                            ~left_child:Tree_type.Empty
                            ~right_child:right
        | (Optional.Value left, Optional.Nothing) ->
                make_branch ~key:key
                            ~value:value
                            ~left_child:left
                            ~right_child:Tree_type.Empty
        | (Optional.Value left, Optional.Value right) ->
                make_branch ~key:key
                            ~value:value
                            ~left_child:left
                            ~right_child:right
        end

    let left_child tree =
        let open Tree_type in
        begin match tree with
        | Branch { left_child } -> left_child
        | Leaf     _            -> Empty
        | Empty                 -> Empty
        end

    let right_child tree =
        let open Tree_type in
        begin match tree with
        | Branch { right_child } -> right_child
        | Leaf     _             -> Empty
        | Empty                  -> Empty
        end

    let rec insert tree ~key ~value =
        let open Tree_type in
        begin match tree with
        | Branch { key   = branch_key;
                   value = branch_value; left_child; right_child } ->
                if Key.compare key branch_key
                then begin make_branch
                         ~key:key
                         ~value:value
                         ~left_child:(insert left_child ~key:key ~value:value)
                         ~right_child:right_child
                     end
                else begin make_branch
                         ~key:key
                         ~value:value
                         ~left_child:left_child
                         ~right_child:(insert right_child ~key:key ~value:value)
                     end
        | Leaf { key = leaf_key; value = leaf_value } ->
                if Key.compare key leaf_key
                then begin make_branch
                         ~key:key
                         ~value:value
                         ~left_child:(make_leaf ~key:key ~value:value)
                         ~right_child:(empty ())
                     end
                else begin make_branch
                         ~key:key
                         ~value:value
                         ~left_child:(empty ())
                         ~right_child:(make_leaf ~key:key ~value:value)
                     end
        | Empty -> make_leaf ~key:key ~value:value
        end

    let key_equals lhs rhs =
        if Key.compare lhs rhs
        then false
        else begin if Key.compare rhs lhs
                   then false
                   else true
             end

    let rec lookup tree ~key =
        let open Tree_type in
        begin match tree with
        | Branch {key = branch_key; value; left_child; right_child} ->
                if Key.compare key branch_key
                then lookup left_child ~key:key
                else if Key.compare branch_key key
                then lookup right_child ~key:key
                else Optional.make value
        | Leaf {key = leaf_key; value } ->
                if Key.compare key leaf_key
                then Optional.nothing ()
                else if Key.compare leaf_key key
                then Optional.nothing ()
                else Optional.make value
        | Empty ->
                Optional.nothing ()
        end

    let rotate_left tree =
        let open Tree_type in
        begin match tree with
        | Branch {
            key; value; left_child;
            right_child = Branch {
                            key         = right_key         ;
                            value       = right_value       ;
                            left_child  = right_left_child  ;
                            right_child = right_right_child ;
                          }
          } -> begin make_branch
                   ~key:right_key
                   ~value:right_value
                   ~left_child:begin make_branch
                                   ~key:key
                                   ~value:value
                                   ~left_child:left_child
                                   ~right_child:right_left_child
                               end
                   ~right_child:right_right_child
               end
        | Branch {
            key; value; left_child;
            right_child = Leaf {
                            key   = right_key   ;
                            value = right_value ;
                          }
          } -> begin make_branch
                   ~key:right_key
                   ~value:right_value
                   ~left_child:begin make_branch
                                   ~key:key
                                   ~value:value
                                   ~left_child:left_child
                                   ~right_child:Empty
                               end
                   ~right_child:Empty
               end
        | other -> other
        end

    let rotate_right tree =
        let open Tree_type in
        begin match tree with
        | Branch {
            key; value; right_child;
            left_child = Branch {
                           key         = left_key         ;
                           value       = left_value       ;
                           left_child  = left_left_child  ;
                           right_child = left_right_child ;
                         }
          } -> begin make_branch
                   ~key:left_key
                   ~value:left_value
                   ~left_child:left_left_child
                   ~right_child:begin make_branch
                                    ~key:key
                                    ~value:value
                                    ~left_child:left_right_child
                                    ~right_child:right_child
                                end
               end
        | Branch {
            key; value; right_child;
            left_child = Leaf {
                           key   = left_key   ;
                           value = left_value ;
                         }
          } -> begin make_branch
                   ~key:left_key
                   ~value:left_value
                   ~left_child:Empty
                   ~right_child:begin make_branch
                                    ~key:key
                                    ~value:value
                                    ~left_child:Empty
                                    ~right_child:right_child
                                end
               end
        | other -> other
        end

    let rotate_left_right tree =
        let open Tree_type in
        begin match tree with
        | Branch { key; value; left_child; right_child } ->
                rotate_left begin make_branch
                                ~key:key
                                ~value:value
                                ~left_child:left_child
                                ~right_child:(rotate_right right_child)
                            end
        | other -> other
        end

    let rotate_right_left tree =
        let open Tree_type in
        begin match tree with
        | Branch { key; value; left_child; right_child } ->
                rotate_right begin make_branch
                                ~key:key
                                ~value:value
                                ~left_child:(rotate_left left_child)
                                ~right_child:right_child
                             end
        | other -> other
        end

end
