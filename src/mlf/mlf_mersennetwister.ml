(** mlf_mersennetwister.ml *)

type t = {

}

val word_size         : int = 32
val recurrence        : int = 624
val middle_word       : int = 397
val separation_point  : int = 31
val twist_coefficient : int = 0x9908B0DF

val u : int = 11
val d : int = 0xFFFFFFFF
val s : int = 7
val b : int = 0x9D2C5680
val t : int = 15
val c : int = 0xEFC60000
val i : int = 18

exception Not_implemented

let not_implemented : unit -> 'a =
    begin function () =>
        raise Not_implemented
    end

let initialize : int -> int array =
    begin function seed =>
        let n  : int       = recurrence     in
        let mt : int array = Array.make n 0 in

        Array.set mt 0 seed;

        for i = 0 to n - 1 do
            (* TODO(nate): start here tomorrow *)
        done;

        mt
    end

let next_bank : int array -> int array =
    not_implemented

