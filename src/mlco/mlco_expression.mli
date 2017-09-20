(**
 * 'mlco_expression.mli' defines the interface for the recursive expression
 * type
 *)

module type Foo = Mlco_type

module rec Expression : sig
    type t = Variable    of string
           | Integer     of int
           | Abstraction of Abstraction.t
           | Application of Application.t
           | Let         of Let.t
end

and Abstraction : sig
    type t = {
        parameter      : string       ;
        body           : Expression.t ;
    }
end

and Application : sig
    type t = {
        expression : Expression.t ;
        argument   : Expression.t ;
    }
end

and Let : sig
    type t = {
        variable     : string ;
        value        : Expression.t ;
        continuation : Expression.t ;
    }
end

open Expression

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
