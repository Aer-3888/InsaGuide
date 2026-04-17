(** TP2 - Advanced Recursion and Numerical Methods
    Mutual recursion, higher-order functions, numerical integration *)

(** [pair n] returns true if [n] is even, using mutual recursion with [impair]. *)
let rec pair n =
  if n = 0 then true else impair (pred n)

(** [impair n] returns true if [n] is odd, using mutual recursion with [pair]. *)
and impair n =
  if n = 0 then false else pair (pred n)

(** TEST *)
let res = pair 12   (* true *)
let res = impair 12 (* false *)

(** [sigma (a, b)] computes the sum of integers from [a] to [b]. *)
let rec sigma (a, b) =
  if a > b then 0
  else a + sigma (succ a, b)

(** TEST *)
let res = sigma (-2, 4) (* 7 *)

(** [sigma2 f (a, b)] computes the sum of [f(i)] for i from [a] to [b]. *)
let rec sigma2 f (a, b) =
  if a > b then 0
  else f a + sigma2 f (succ a, b)

(** TEST *)
let res = sigma2 (fun x -> 2 * x) (-2, 4) (* 14 *)

(** [sigma3 (f, fc) i acc (a, b)] is a generalized accumulation function.
    - [f]: function applied to each value
    - [fc]: combiner function (like fold)
    - [i]: increment step
    - [acc]: accumulator initial value
    - [(a, b)]: range *)
let rec sigma3 (f, fc) i acc (a, b) =
  if a > b then acc
  else fc (f a) (sigma3 (f, fc) i acc (a + i, b))

(** TEST *)
let res = sigma3 ((fun x -> 2 * x), fun v acc -> v + acc) 2 0 (2, 6)
(* 24 *)

(** TEST - Building a list *)
let res = sigma3 ((fun x -> x * x), fun x acc -> x :: acc) 2 [] (0, 10)
(* [100; 64; 36; 16; 4; 0] *)

(** [sigma4 (f, fc) (p, fi) acc a] iterates until predicate [p] is satisfied.
    - [(f, fc)]: transformation and combination functions
    - [p]: stopping predicate
    - [fi]: increment function
    - [acc]: accumulator
    - [a]: starting value *)
let rec sigma4 (f, fc) (p, fi) acc a =
  if p a then acc
  else fc (f a) (sigma4 (f, fc) (p, fi) acc (fi a))

(** TEST *)
let res =
  sigma4
    ((fun x -> 2 * x), fun v acc -> v + acc)
    ((fun v -> v > 6), fun v -> v + 2)
    0
    2
(* 24 *)

(** [cum f (a, b) dx] computes the cumulative sum of [f] over [[a, b]] with step [dx]. *)
let cum f (a, b) dx =
  sigma4 (f, fun a b -> a +. b)
         ((fun a -> a > b), fun v -> v +. dx)
         0.
         a

(** TEST *)
let res = cum (fun x -> 2. *. x) (0.2, 0.7) 0.2
(* 2.4 *)

(** [integre f (a, b, dx)] approximates the integral of [f] from [a] to [b]
    using the rectangle method with step [dx]. *)
let integre f (a, b, dx) = dx *. cum f (a, b) dx

(** TEST *)
let res = integre (fun x -> 1. /. x) (1., 2., 0.001)
(* 0.693897243059959257 - approximately ln(2) *)

(** [maxi f (a, b) p] finds the maximum of function [f] over interval [[a, b]]
    using ternary search with precision [p]. *)
let rec maxi f (a, b) p =
  if abs_float (a -. b) < p then f a
  else
    let m1 = (2. *. a +. b) /. 3. in
    let m2 = (a +. 2. *. b) /. 3. in
    if f m1 > f m2
    then maxi f (a, m2) p
    else maxi f (m1, b) p

(** TEST *)
let res = maxi (fun x -> 1. -. (x *. x)) (0., 2.) 0.0001
(* 1. - maximum at x=0 *)
