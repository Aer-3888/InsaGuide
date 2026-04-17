(** TP4 - List Algorithms and Partitions
    Quicksort, bubble sort, fixed points, integer partitions *)

(** [split v l] partitions list [l] into elements less than [v] and >= [v]. *)
let rec split v l = match l with
  | [] -> ([], [])
  | e :: l' ->
      if e < v then
        (e :: fst(split v l'), snd(split v l'))
      else
        (fst(split v l'), e :: snd(split v l'))

(** TEST *)
let res1, res2 = split 4 [12; 27; -12; 7; 8; 1; 3; 6; 12; 42]
(* ([-12; 1; 3], [12; 27; 7; 8; 6; 12; 42]) *)

(** [qs l] sorts list [l] using quicksort algorithm. *)
let rec qs l = match l with
  | [] -> []
  | [e] -> [e]
  | e :: l' ->
      (qs (fst(split e l'))) @ (e :: (qs (snd(split e l'))))

(** TEST *)
let res = qs [4; 12; 27; -12; 7; 8; 1; 3; 6; 12; 42]
(* [-12; 1; 3; 4; 6; 7; 8; 12; 12; 27; 42] *)

(** [kieme k l] returns the [k]th element of list [l] (1-indexed). *)
let rec kieme k l = match (k, l) with
  | (1, a :: l') -> a
  | (n, e :: l') -> kieme (n - 1) l'
  | (n, []) -> failwith "Index out of bounds"

(** TEST *)
let res = kieme 7 [4; 12; 27; -12; 7; 1; 8; 3; 6; 12; 42]
(* 8 *)

(** [jqastable x f] finds the fixed point of function [f] starting from [x].
    Returns [x] such that [f(x) = x]. *)
let rec jqastable x f =
  if f x = x then x else jqastable (f x) f

(** TEST *)
let res = jqastable 13 (fun x ->
  if x = 1 then 1
  else if x mod 2 = 1 then 3 * x + 1
  else x / 2)
(* 1 - Collatz conjecture *)

(** [unebulle l] performs one pass of bubble sort on list [l]. *)
let rec unebulle l = match l with
  | [] -> l
  | [a] -> l
  | e1 :: e2 :: l' ->
      if e1 < e2 then e1 :: (unebulle (e2 :: l'))
      else e2 :: (unebulle (e1 :: l'))

(** TEST *)
let res = unebulle [4; 12; 27; -12; 7; 8; 1; 3; 6; 42; 12]
(* [4; 12; -12; 7; 8; 1; 3; 6; 27; 12; 42] *)

(** [tribulle l] sorts list [l] using bubble sort (repeated until fixed point). *)
let tribulle l = jqastable l unebulle

(** TEST *)
let res = tribulle [4; 12; 27; -12; 7; 8; 1; 3; 6; 12; 42]
(* [-12; 1; 3; 4; 6; 7; 8; 12; 12; 27; 42] *)

(** [merge ll] flattens a list of lists into a single list. *)
let rec merge ll = match ll with
  | [] -> []
  | l :: ll' -> l @ (merge ll')

(** TEST *)
let res = merge [[1]; [2; 3]; [5]]
(* [1; 2; 3; 5] *)

(** [create f k] creates a list [[f 1; f 2; ...; f k]]. *)
let rec create f k =
  if k = 1 then [f 1]
  else (create f (k - 1)) @ [f k]

(** TEST *)
let res = create (fun x -> x + 1) 4
(* [2; 3; 4; 5] *)

(** [insert j ll] inserts element [j] at the head of each sublist in [ll]. *)
let rec insert j ll = match ll with
  | [] -> []
  | l :: ll' -> (j :: l) :: (insert j ll')

(** TEST *)
let res = insert 1 [[3; 5]; [7; 3; 9]; []; [6]]
(* [[1; 3; 5]; [1; 7; 3; 9]; [1]; [1; 6]] *)

(** [partition n] generates all integer partitions of [n].
    Returns a list of lists, where each sublist is a partition in descending order. *)
let partition n =
  (** [partition_faible m k] generates partitions of [m] with parts <= [k]. *)
  let rec partition_faible m k =
    match (m, k) with
    | (0, 0) -> [[]]
    | (_, 0) -> []
    | (a, b) ->
        if b > a then partition_faible a a
        else merge (create (fun c ->
          insert c (partition_faible (a - c) c)) b)
  in
  partition_faible n n

(** TEST *)
let res = partition 5
(* Contains [5], [4; 1], [3; 2], [3; 1; 1], [2; 2; 1], [2; 1; 1; 1], [1; 1; 1; 1; 1] *)
