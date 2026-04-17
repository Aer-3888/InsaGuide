(** TP5 - List Operations
    Basic list manipulation, sublists, pattern matching *)

(** [longueur l] returns the length of list [l]. *)
let rec longueur l = match l with
  | [] -> 0
  | e :: r -> 1 + longueur r

(** TEST *)
let res = longueur [1; 2; 3] (* 3 *)

(** [appartient e l] returns true if element [e] is in list [l]. *)
let rec appartient e l = match l with
  | [] -> false
  | e1 :: tl -> if e1 = e then true else appartient e tl

(** TEST *)
let res = appartient 4 [1; 2; 3] (* false *)

(** [rang e l] returns the 1-indexed position of [e] in [l], or 0 if not found. *)
let rec rang e l = match l with
  | [] -> 0
  | e1 :: tl ->
      if e1 = e then 1
      else if rang e tl = 0 then 0
      else 1 + rang e tl

(** TEST *)
let res = rang 2 [3; 2; 1] (* 2 *)

(** Option type for safe indexing *)
type 'a option = None | Some of 'a

(** [rang_opt e l] returns Some position or None if not found. *)
let rec rang_opt e l = match l with
  | [] -> None
  | e1 :: tl ->
      if e1 = e then Some 1
      else match rang_opt e tl with
        | None -> None
        | Some c -> Some (c + 1)

(** TEST *)
let res = rang_opt 2 [3; 2; 1] (* Some 2 *)
let res = rang_opt 0 [3; 2; 1] (* None *)

(** [concatl l1 l2] concatenates two lists. *)
let rec concatl l1 l2 = match l1, l2 with
  | [], l2 -> l2
  | l1, [] -> l1
  | e1 :: tl, l2 -> e1 :: (concatl tl l2)

(** TEST *)
let res = concatl [1; 2; 3] [4; 5; 6] (* [1; 2; 3; 4; 5; 6] *)

(** [debliste l n] returns the first [n] elements of list [l]. *)
let rec debliste l n = match l, n with
  | [], _ -> l
  | _, 0 -> []
  | e1 :: tl, n -> e1 :: debliste tl (n - 1)

(** TEST *)
let res = debliste [1; 2; 3; 4; 5; 6; 7] 3 (* [1; 2; 3] *)

(** [finliste l n] returns the last [n] elements of list [l]. *)
let rec finliste l n = match l with
  | [] -> []
  | e :: tl ->
      if n >= longueur l then l
      else finliste tl n

(** TEST *)
let res = finliste [1; 2; 3; 4; 5; 6; 7] 3 (* [5; 6; 7] *)

(** [remplace x y l] replaces all occurrences of [x] with [y] in list [l]. *)
let rec remplace x y l = match l with
  | [] -> []
  | e1 :: tl ->
      if e1 = x then y :: (remplace x y tl)
      else e1 :: (remplace x y tl)

(** TEST *)
let res = remplace 2 42 [1; 2; 3; 2; 5] (* [1; 42; 3; 42; 5] *)

(** [entete l l1] returns true if [l] is a prefix of [l1]. *)
let rec entete l l1 = match l, l1 with
  | [], _ -> true
  | _, [] -> false
  | e1 :: t1, e2 :: t2 ->
      if e1 = e2 then entete t1 t2 else false

(** TEST *)
let res = entete [1; 2; 3] [1; 2; 3; 2; 5] (* true *)

(** [sousliste l l1] returns true if [l] appears as a contiguous sublist in [l1]. *)
let rec sousliste l l1 = match l, l1 with
  | [], _ -> true
  | _, [] -> false
  | e1 :: t1, e2 :: t2 ->
      if e1 = e2 then
        if entete t1 t2 then true
        else sousliste l t2
      else sousliste l t2

(** TEST *)
let res = sousliste [2; 3; 2] [2; 1; 2; 3; 2; 5] (* true *)
let res = sousliste [1; 2; 1] [1; 1; 2; 1; 4; 5; 6] (* true *)

(** [oter l l1] removes prefix [l] from [l1] if [l] is a prefix. *)
let oter l l1 =
  if entete l l1 then
    let rec hotter la lb = match la, lb with
      | [], lb -> lb
      | e1 :: t1, e2 :: t2 -> hotter t1 t2
      | _ -> failwith "Impossible case"
    in
    hotter l l1
  else l1

(** TEST *)
let res = oter [1; 2; 3] [1; 2; 3; 2; 5] (* [2; 5] *)

(** [remplacel l1 l2 l] replaces all occurrences of sublist [l1] with [l2] in [l]. *)
let rec remplacel l1 l2 l = match l with
  | [] -> []
  | e2 :: t2 ->
      if entete l1 l then
        concatl l2 (remplacel l1 l2 (oter l1 l))
      else e2 :: remplacel l1 l2 t2

(** TEST *)
let res = remplacel [1; 2; 1] [5; 6] [4; 1; 2; 1; 2; 1; 2; 1; 3; 8]
(* [4; 5; 6; 2; 5; 6; 2; 5; 6; 3; 8] *)

(** [supprimel l1 l] removes all occurrences of sublist [l1] from [l]. *)
let supprimel l1 l = match l1 with
  | [] -> l
  | _ -> remplacel l1 [] l

(** TEST *)
let res = supprimel [1; 2; 1] [4; 1; 2; 1; 2; 1; 3; 8] (* [4; 2; 1; 3; 8] *)
let res = supprimel [] [1; 2; 3] (* [1; 2; 3] *)
