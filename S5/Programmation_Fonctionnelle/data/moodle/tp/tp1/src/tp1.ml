(** TP1 - Introduction to OCaml
    Basic functions, conditionals, tuples, higher-order functions, recursion *)

(** [mul2 n] multiplies [n] by 2. *)
let mul2 n = 2 * n

(** TEST *)
let _ = mul2 21 (* 42 *)

(** [vabs n] returns the absolute value of [n]. *)
let vabs n = if n > 0 then n else -n

(** TEST *)
let _ = vabs (-5) (* 5 *)
let _ = vabs 12   (* 12 *)

(** [test1 n] returns true if [n] is in the range [12, 29]. *)
let test1 n = n >= 12 && n <= 29

(** TEST *)
let _ = test1 25  (* true *)
let _ = test1 (-8) (* false *)

(** [test2 n] returns true if [n] equals 2, 5, 9, or 23. *)
let test2 n = n = 2 || n = 5 || n = 9 || n = 23

(** TEST *)
let _ = test2 5 (* true *)
let _ = test2 6 (* false *)

(** [test3 p] returns true if the first element of pair [p] equals 12. *)
let test3 p = fst p = 12

(** TEST *)
let _ = test3 (12, "foo") (* true *)
let _ = test3 (12, 42)    (* true *)
let _ = test3 (13, true)  (* false *)

(** [bissext y] returns true if year [y] is a leap year.
    Rules: divisible by 400, OR divisible by 4 but not by 100. *)
let bissext y =
  if y mod 400 = 0 then true
  else if y mod 100 = 0 then false
  else if y mod 4 = 0 then true
  else false

(** TEST *)
let _ = bissext 2000 (* true *)
let _ = bissext 1900 (* false *)
let _ = bissext 2016 (* true *)
let _ = bissext 2017 (* false *)

(** [proj1 (a, b, c)] returns the first element [a] of the 3-tuple. *)
let proj1 (a, b, c) = a

(** [proj23 (a, b, c)] returns [(b, c)], the second and third elements. *)
let proj23 (a, b, c) = (b, c)

(** TEST *)
let _ = proj1 (1, "foo", true)  (* 1 *)
let _ = proj23 (1, "foo", true) (* ("foo", true) *)

(** [inv2 ((a, b), (c, d))] returns [(d, c)], swapping inner elements. *)
let inv2 ((a, b), (c, d)) = (d, c)

(** TEST *)
let _ = inv2 ((true, 'a'), (1, "un")) (* ("un", 1) *)

(** [incrpaire p] increments both elements of pair [p] by 1. *)
let incrpaire p = (fst p + 1, snd p + 1)

(** TEST *)
let _ = incrpaire (12, 42) (* (13, 43) *)

(** [appliquepaire f p] applies function [f] to both elements of pair [p]. *)
let appliquepaire f p = (f (fst p), f (snd p))

(** TEST *)
let _ = appliquepaire (fun x -> not x) (false, true) (* (true, false) *)

(** [incrpaire2 p] increments both elements of [p] using [appliquepaire]. *)
let incrpaire2 p = appliquepaire (fun x -> x + 1) p

(** TEST *)
let _ = incrpaire2 (4, 18) (* (5, 19) *)

(** [rapport (f, g) x] returns [f(x) / g(x)]. *)
let rapport (f, g) x = f x /. g x

(** TEST *)
let _ = rapport ((fun x -> x +. 1.), (fun x -> x -. 1.)) 2. (* 3. *)

(** [mytan x] computes tan(x) using sin and cos. *)
let mytan x = rapport (sin, cos) x

(** TEST *)
let _ = mytan 0. (* 0. *)

(** [premier n] returns true if [n] is a prime number.
    Uses trial division up to sqrt(n). *)
let premier n =
  if n = 1 then false
  else
    let rec estpremier x n =
      if x * x > n then true
      else if n mod x = 0 then false
      else estpremier (x + 1) n
    in
    estpremier 2 n

(** TEST *)
let _ = premier 1  (* false *)
let _ = premier 2  (* true *)
let _ = premier 6  (* false *)
let _ = premier 13 (* true *)

(** [n_premier n] returns the [n]th prime number. *)
let n_premier n =
  let rec xnpremier n x i =
    if premier x && i < n then xnpremier n (x + 1) (i + 1)
    else if premier x && i = n then x
    else xnpremier n (x + 1) i
  in
  xnpremier n 2 1

(** TEST *)
let _ = n_premier 10 (* 29 *)
