(** mlco_expression.ml *)

module rec Expression_type : sig
    type t = Variable    of string
           | Integer     of int
           | Abstraction of Abstraction_type.t
           | Application of Application_type.t
           | Let         of Let_type.t
end = struct
    type t = Variable    of string
           | Integer     of int
           | Abstraction of Abstraction_type.t
           | Application of Application_type.t
           | Let         of Let_type.t
end

and Abstraction_type : sig
    type t = {
        parameter : string       ;
        body      : Expression_type.t ;
    }
end = struct
    type t = {
        parameter : string       ;
        body      : Expression_type.t ;
    }
end

and Application_type : sig
    type t = {
        expression : Expression_type.t ;
        argument   : Expression_type.t ;
    }
end = struct
    type t = {
        expression : Expression_type.t ;
        argument   : Expression_type.t ;
    }
end

and Let_type : sig
    type t = {
        variable     : string ;
        value        : Expression_type.t ;
        continuation : Expression_type.t ;
    }
end = struct
    type t = {
        variable     : string ;
        value        : Expression_type.t ;
        continuation : Expression_type.t ;
    }
end

open Expression_type

module Abstraction = struct
    include Abstraction_type

    type expression = Expression_type.t

    let make ~parameter ~body = { parameter ; body }
end

module Application = struct
    include Application_type
end

module Let = struct
    include Let_type
end

(* ----------------------------------------------------------------------------
 * MIT License
 *
 * Copyright (c) 2017 Nathan Burgers
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 * ----------------------------------------------------------------------------
 *)
