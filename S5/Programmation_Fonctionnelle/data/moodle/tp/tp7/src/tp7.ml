(** TP7 - N-ary Trees
    Trees with arbitrary number of children per node *)

(** N-ary tree type: either a leaf or a node with a list of children *)
type 'a narbr =
  | Feuille of 'a
  | Noeud of 'a * 'a narbr list

(** [feuille v] creates a leaf node with value [v]. *)
let feuille v = Feuille v

(** [noeud v l] creates a node with value [v] and children list [l]. *)
let noeud (v : 'a) (l : 'a narbr list) = Noeud (v, l)

(** [valeur a] returns the value stored in the root of tree [a]. *)
let valeur a = match a with
  | Feuille d -> d
  | Noeud (c, d) -> c

(** [sous_arbres a] returns the list of children of node [a]. *)
let sous_arbres a = match a with
  | Noeud (f, v) -> v
  | Feuille k -> []

let a1 = feuille 4
let a2 = noeud 3 [a1; a1]

(** TEST *)
let _ = valeur a1 = 4
let _ = valeur a2 = 3
let _ = sous_arbres a1 = []
let _ = sous_arbres a2 = [a1; a1]

(** [compter a] counts the total number of nodes in tree [a]. *)
let rec compter a =
  let rec compteur a acc = match a with
    | Feuille c -> 1 + acc
    | Noeud (c, d) -> listeur d acc
  and listeur l acc = match l with
    | [] -> acc
    | e1 :: tl -> compter e1 + listeur tl acc
  in
  compteur a 0

(** TEST *)
let _ = compter a2 (* 2 *)

(** [pluslongue a] returns the length of the longest path from root to leaf. *)
let rec pluslongue a =
  let rec arb a acc = match a with
    | Feuille f -> 1 + acc
    | Noeud (f, n) -> 1 + lis n acc
  and lis c acc = match c with
    | [] -> acc
    | e1 :: tl -> max (arb e1 acc) (lis tl acc)
  in
  arb a 0

let a3 = noeud 8 [a1; a2; a1]

(** TEST *)
let _ = pluslongue a3 (* 3 *)

(** [listsa a] returns a list of all subtrees in tree [a]. *)
let listsa a =
  let rec ads a = match a with
    | Feuille f -> [a]
    | Noeud (v, j) -> a :: (concat j)
  and concat e = match e with
    | [] -> []
    | e1 :: tl -> (ads e1) @ (concat tl)
  in
  ads a

let f4 = feuille 4
let f10 = feuille 10
let f12 = feuille 12
let f13 = feuille 13
let f20 = feuille 20
let f21 = feuille 21
let n7 = noeud 7 [f10; f12; f13]
let n3 = noeud 3 [f4; n7; f20]
let n5 = noeud 5 [n3; f21]

(** TEST *)
let _ =
  List.sort compare (listsa n5) =
  List.sort compare [f4; f10; f12; f13; f20; f21; n7; n3; n5]

(** [ajout n l] prepends value [n] to each list in [l]. *)
let rec ajout n l = match l with
  | [] -> []
  | x :: reste -> [n :: x] @ (ajout n reste)

(** [listbr a] returns all root-to-leaf paths as lists. *)
let listbr a =
  let rec arb a = match a with
    | Feuille f -> [[f]]
    | Noeud (v, j) -> ajout v (listeu j)
  and listeu l = match l with
    | [] -> []
    | e1 :: tl -> (arb e1) @ (listeu tl)
  in
  arb a

(** TEST *)
let _ =
  let res = [
    [5; 3; 4];
    [5; 3; 7; 10];
    [5; 3; 7; 12];
    [5; 3; 7; 13];
    [5; 3; 20];
    [5; 21]
  ] in
  List.sort compare (listbr n5) = List.sort compare res

(** [egal a b] checks if trees [a] and [b] are structurally equal. *)
let egal a b =
  let rec egala a b = match (a, b) with
    | Feuille f, Feuille slim -> if f = slim then true else false
    | Feuille f, Noeud (n, d) -> false
    | Noeud (n, d), Feuille slim -> false
    | Noeud (n, d), Noeud (v, w) ->
        if v = n then egalb d w else false
  and egalb d w = match (d, w) with
    | [], [] -> true
    | [], _ -> false
    | _, [] -> false
    | e1 :: t1, e2 :: t2 ->
        if egala e1 e2 then egalb t1 t2 else false
  in
  egala a b

(** TEST *)
let _ = egal n5 n5 (* true *)

(** [remplace a1 a2 a] replaces all occurrences of subtree [a1] with [a2] in tree [a]. *)
let rec remplace a1 a2 a =
  if egal a a1 then a2
  else match a with
    | Noeud (n, reste) -> Noeud (n, List.map (remplace a1 a2) reste)
    | _ -> a

let n42 = noeud 42 [feuille 2048]
let res = noeud 5 [(noeud 3 [f4; n42; f20]); f21]

(** TEST *)
let _ = (remplace n7 n42 n5) = res (* true *)
