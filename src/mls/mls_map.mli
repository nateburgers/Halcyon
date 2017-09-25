(** mls_map.mli *)

module      Int        = Mls_int
module      Optional   = Mls_optional
module type Comparable = Mls_comparable.Signature

module type BidirectionalCursor = sig
    module Record : sig
        type 'value t = {
            value     :  unit -> 'value              ;
            next      :  unit -> 'value t Optional.t ;
            previous  :  unit -> 'value t Optional.t ;
        }
    end

    type 'value t = 'value Record.t
    (**
     * A bidirectional cursor represents a data structure that can be used to
     * lazily traverse an ordered data structure in either direction.
     *)

    exception Overrun
    (**
     * Exception thrown when an attempt is made to iterate one or more
     * elements past the last element in a container.
     *)

    exception Underrun
    (**
     * Exception thrown when an attempt is made to iterate one or more
     * elements before the first element in a container.
     *)

    val value : 'value t -> 'value
    (**
     * Return the value at the current point in the iteration.
     *)

    val next : 'value t -> 'value t Optional.t
    (**
     * Return the cursor that holds the value for the next element in the
     * sequence if it exists, otherwise return nothing
     *)

    val next_exn : 'value t -> 'value t
    (**
     * Return the cursor that holds the value for the next element in the
     * sequence.  If no such element exists, then raise an [Overrun]
     * exception.
     *)

    val previous : 'value t -> 'value t Optional.t
    (**
     * Return the cursor that holds the value for the previous element in
     * the sequence if it exists, otherwise return nothing.
     *)

    val previous_exn : 'value t -> 'value t
    (**
     * Return the cursor that holds the value for the previous element in
     * the sequence.  If no such element exists, then raise an [Underrun]
     * exception.
     *)

end

module type Signature = sig
    module Key : Comparable

    type  key = Key.t
    type 'value t

    exception Key_not_found

    val empty : unit -> 'value t

    val insert : 'value t
              ->  key   :  key
              ->  value : 'value
              -> 'value t

    (*
    val remove : 'value t
              ->  key : key
              -> 'value t
    *)

    val lookup : 'value t
              ->  key : key
              -> 'value Optional.t

    val lookup_exn : 'value t
                  ->  key : key
                  -> 'value
end

module Make (Key : Comparable) : Signature
    with module Key = Key
