(** mls_optional.ml *)

type 'value t = Value of 'value
              | Nothing

let nothing () =
    Nothing

let make value =
    Value value
