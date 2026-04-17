(** TP3 - Card Game with Types and Graphics
    Custom types, pattern matching, list operations, graphics *)

(** Card suit type *)
type coul = Coeur | Trefle | Pique | Carreau

(** Card height type *)
type haut = Sept | Huit | Neuf | Dix | Valet | Dame | Roi | As

(** Card type as a record *)
type carte = {h : haut; c : coul}

(** [coul c] returns the suit of card [c]. *)
let coul c = c.c

(** [haut c] returns the height of card [c]. *)
let haut c = c.h

(** [haut_of_int i] converts an integer to a card height. *)
let haut_of_int i = match i with
  | 7 -> Sept
  | 8 -> Huit
  | 9 -> Neuf
  | 10 -> Dix
  | 11 -> Valet
  | 12 -> Dame
  | 13 -> Roi
  | 14 -> As
  | _ -> failwith "Invalid card height"

(** TEST *)
let _ = haut_of_int 12 (* Dame *)

(** [coul_of_string s] converts a string to a card suit. *)
let coul_of_string s = match s with
  | "Coeur" -> Coeur
  | "Trefle" -> Trefle
  | "Carreau" -> Carreau
  | "Pique" -> Pique
  | _ -> failwith "Invalid card suit"

(** TEST *)
let _ = coul_of_string "Pique" (* Pique *)

(** [carte i s] creates a card from an integer height and string suit. *)
let carte i s = {c = coul_of_string s; h = haut_of_int i}

(** TEST *)
let _ = (haut (carte 8 "Trefle")) = Huit
let _ = (coul (carte 14 "Trefle")) = Trefle

(** [string_of_haut h] converts a card height to a string. *)
let string_of_haut h = match h with
  | Sept -> "Sept"
  | Huit -> "Huit"
  | Neuf -> "Neuf"
  | Dix -> "Dix"
  | Valet -> "Valet"
  | Dame -> "Dame"
  | Roi -> "Roi"
  | As -> "As"

(** [string_of_coul c] converts a card suit to a string. *)
let string_of_coul c = match c with
  | Coeur -> "Coeur"
  | Trefle -> "Trefle"
  | Carreau -> "Carreau"
  | Pique -> "Pique"

(** [string_of_carte c] converts a card to a human-readable string. *)
let string_of_carte c = (string_of_haut c.h) ^ " de " ^ (string_of_coul c.c)

(** TEST *)
let res = string_of_carte (carte 11 "Pique") (* "Valet de Pique" *)
let res = string_of_carte (carte 9 "Trefle")  (* "Neuf de Trefle" *)

(** [coul_of_int a] converts an integer to a suit. *)
let coul_of_int a = match a with
  | 0 -> Coeur
  | 1 -> Trefle
  | 2 -> Carreau
  | 3 -> Pique
  | _ -> failwith "Invalid suit number"

(** [random_carte ()] generates a random card. *)
let random_carte () =
  {c = coul_of_int (Random.int 4);
   h = haut_of_int ((Random.int 8) + 7)}

(** [exist c l] returns true if card [c] exists in list [l]. *)
let rec exist c l = match l with
  | [] -> false
  | x :: l' -> if c = x then true else exist c l'

(** [ajtcarte l] adds a new random card to list [l], ensuring no duplicates. *)
let rec ajtcarte l =
  let c = random_carte () in
  if not (exist c l) then c :: l else ajtcarte l

(** TEST *)
let res =
  let l1 = ajtcarte [] in
  let l2 = ajtcarte l1 in
  match l1, l2 with
  | [c], [c1; c2] -> c = c2 && c1 <> c2
  | _ -> false

(** [faitjeu n] creates a game with [n] cards. *)
let rec faitjeu n =
  if n = 0 then [] else ajtcarte (faitjeu (n - 1))

(** [reduc l] performs one reduction step on the list of piles.
    If piles A, B, C have matching top cards (A and C), merge B onto A. *)
let rec reduc l = match l with
  | (e1 :: l1') :: l2 :: (e3 :: l3') :: l' ->
      if e1.c = e3.c || e1.h = e3.h then
        (l2 @ (e1 :: l1')) :: (e3 :: l3') :: l'
      else
        (e1 :: l1') :: (reduc (l2 :: (e3 :: l3') :: l'))
  | _ -> l

(** Test data *)
let p1 = [carte 14 "Trefle";  carte 10 "Coeur"]
let p2 = [carte 7 "Pique";    carte 11 "Carreau"]
let p3 = [carte 14 "Carreau"; carte 8 "Pique"]
let p4 = [carte 7 "Carreau";  carte 10 "Trefle"]
let p'1 = p2 @ p1

(** TEST *)
let _ = (reduc [p1; p2; p3; p4]) = [p'1; p3; p4]

(** [reussite l] repeatedly applies [reduc] until no more reductions possible. *)
let rec reussite l =
  let l' = reduc l in
  if l = l' then l else reussite l'

let p''1 = p3 @ p'1

(** TEST *)
let res = (reussite [p1; p2; p3; p4]) = [p''1; p4]
