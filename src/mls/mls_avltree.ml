(** mls_avltree.ml *)

module      Int        = Mls_int
module      Optional   = Mls_optional
module type Comparable = Mls_comparable.Signature

module Make (Key : Comparable) = struct

    (* MODULES *)
    module Key = Key

    module rec Tree_type : sig
        type 'value t = Branch of 'value Branch_type.t
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

    module Tree = struct
        type 'value t = 'value Tree_type.t
                      = Branch of 'value Branch_type.t
                      | Empty

        let make_branch branch = Branch branch
        let make_empty  ()     = Empty
    end

    module Branch = struct
        type 'value t = 'value Branch_type.t = {
            height      :  int               ;
            key         :  Key.t             ;
            value       : 'value             ;
            left_child  : 'value Tree_type.t ;
            right_child : 'value Tree_type.t ;
        }

        let make ~key ~value ?(left_child  = Tree_type.Empty)
                             ?(right_child = Tree_type.Empty) =
            let left_child_height  = height left_child in
            let right_child_height = height right_child in
            let height = 1 + (Int.greater left_child_height
                                          right_child_height) in
            { height; key; value; left_child; right_child }

        let height      branch = branch.height
        let key         branch = branch.key
        let value       branch = branch.value
        let left_child  branch = branch.left_child
        let right_child branch = branch.right_child
    end

    (* TYPES *)
    type  key          =  Key.t
    type 'value branch = 'value Branch_type.t
    type 'value t      = 'value Tree_type.t

    (* FUNCTIONS *)
    let key tree =
        begin match tree with
        | Tree.Branch branch -> Optional.make @@ Branch.key branch
        | Tree.Empty         -> Optional.nothing ()
        end

    let value tree =
        begin match tree with
        | Tree.Branch branch -> Optional.make @@ Branch.value branch
        | Tree.Empty         -> Optional.nothing ()
        end

    let height tree =
        begin match tree with
        | Tree.Branch branch -> Branch.height branch
        | Tree.Empty         -> 0
        end

    let balance tree =
        begin match tree with
        | Tree.Branch branch ->
                let left_height  = height @@ Branch.left_child  branch in
                let right_height = height @@ Branch.right_child branch in
                right_height - left_height
        | Tree.Empty         -> 0
        end

    let is_avl tree =
        let b = balance tree in
        -1 <= b && b <= 1

    let is_balanced tree = (balance tree) == 0
    let is_left_heavy tree = (balance tree) < 0
    let is_right_heavy tree = (balance tree) > 0

    let empty () =
        Tree.Empty

    let make ~key ~value ?(left_child  = Tree.Empty)
                         ?(right_child = Tree.Empty) =
        Tree.make_branch @@ Branch.make ~key:key
                                        ~value:value
                                        ~left_child:left_child
                                        ~right_child:right_child

    let left_child tree =
        begin match tree with
        | Tree.Branch branch -> Branch.left_child branch
        | _                  -> Tree.Empty
        end

    let right_child tree =
        begin match tree with
        | Tree.Branch branch -> Branch.right_child branch
        | _                  -> Tree.Empty
        end

    let rotate_left tree =
        begin match tree with
        | Tree.Branch {
            Branch.key; Branch.value; Branch.left_child;
            Branch.right_child = Tree.Branch {
                            Branch.key         = right_key         ;
                            Branch.value       = right_value       ;
                            Branch.left_child  = right_left_child  ;
                            Branch.right_child = right_right_child ;
                          }
          } -> begin make
                   ~key:right_key
                   ~value:right_value
                   ~left_child:begin make
                                   ~key:key
                                   ~value:value
                                   ~left_child:left_child
                                   ~right_child:right_left_child
                               end
                   ~right_child:right_right_child
               end
        | other -> other
        end

    let rotate_right tree =
        begin match tree with
        | Tree.Branch {
            Branch.key; Branch.value; Branch.right_child;
            Branch.left_child = Branch {
                           Branch.key         = left_key         ;
                           Branch.value       = left_value       ;
                           Branch.left_child  = left_left_child  ;
                           Branch.right_child = left_right_child ;
                         }
          } -> begin make
                   ~key:left_key
                   ~value:left_value
                   ~left_child:left_left_child
                   ~right_child:begin make
                                    ~key:key
                                    ~value:value
                                    ~left_child:left_right_child
                                    ~right_child:right_child
                                end
               end
        | other -> other
        end

    let rotate_left_right tree =
        begin match tree with
        | Tree.Branch branch ->
              make ~key:Branch.key branch
                   ~value:Branch.value branch
                   ~left_child:Branch.left_child branch
                   ~right_child:(rotate_right @@ Branch.right_child branch)
              |> rotate_left
        | Empty -> Empty
        end

    let rotate_right_left tree =
        begin match tree with
        | Tree.Branch branch ->
              make ~key:Branch.key branch
                   ~value:Branch.value branch
                   ~left_child:(rotate_left @@ Branch.left_child branch)
                   ~right_child:Branch.right_child branch
              |> rotate_right
        | Empty -> Empty
        end

    let rec rebalance tree =
        let open Tree_type in
        if is_avl tree
            then tree
        else if is_left_heavy tree
            then if is_left_heavy (right_child tree)
                 then rotate_right_left tree
                 else rotate_left tree
            else if is_right_heavy (left_child tree)
                 then rotate_left_right tree
                 else rotate_right tree

    let rec insert tree ~key ~value =
        let open Tree_type in
        let tree' = begin match tree with
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
        end in rebalance tree'

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


end
