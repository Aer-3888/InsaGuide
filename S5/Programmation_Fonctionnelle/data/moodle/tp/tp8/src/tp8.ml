(** TP8 - Card Game with Graphics (Variant Implementation)
    Alternative type definition using tuple variants, graphics display *)

(** Card types *)
type coul = Coeur | Trefle | Pique | Carreau
type haut = Sept | Huit | Neuf | Dix | Valet | Dame | Roi | As
type carte = Carte of haut * coul

(** [coul c] extracts the suit from card [c]. *)
let coul c = let Carte (_, col) = c in col

(** [haut c] extracts the height from card [c]. *)
let haut c = let Carte (h, _) = c in h

(** [haut_of_int i] converts an integer to a card height. *)
let haut_of_int i = match i with
  | 7 -> Sept | 8 -> Huit | 9 -> Neuf | 10 -> Dix
  | 11 -> Valet | 12 -> Dame | 13 -> Roi | 14 -> As
  | _ -> failwith "Invalid card height"

(** TEST *)
let _ = haut_of_int 12 (* Dame *)

(** [coul_of_string s] converts a string to a card suit. *)
let coul_of_string s = match s with
  | "Coeur" -> Coeur | "Trefle" -> Trefle
  | "Pique" -> Pique | "Carreau" -> Carreau
  | _ -> failwith "Invalid card suit"

(** TEST *)
let _ = coul_of_string "Pique" (* Pique *)

(** [carte i s] creates a card from integer and string. *)
let carte i s = Carte (haut_of_int i, coul_of_string s)

(** TEST *)
let _ = (haut (carte 8 "Trefle")) = Huit
let _ = (coul (carte 14 "Trefle")) = Trefle

(** [string_of_carte c] converts a card to a human-readable string. *)
let string_of_carte c = match c with
  | Carte (h, col) ->
      let hstring = match h with
        | Sept -> "Sept" | Huit -> "Huit" | Neuf -> "Neuf" | Dix -> "Dix"
        | Valet -> "Valet" | Dame -> "Dame" | Roi -> "Roi" | As -> "As"
      and cstring = match col with
        | Coeur -> "Coeur" | Pique -> "Pique"
        | Trefle -> "Trefle" | Carreau -> "Carreau"
      in
      hstring ^ " de " ^ cstring

(** TEST *)
let res = string_of_carte (carte 11 "Pique") (* "Valet de Pique" *)
let res = string_of_carte (carte 9 "Trefle")  (* "Neuf de Trefle" *)

(** [random_carte ()] generates a random card. *)
let random_carte () =
  Carte (
    haut_of_int ((Random.int 8) + 7),
    match Random.int 4 with
    | 0 -> Coeur | 1 -> Trefle | 2 -> Carreau | 3 -> Pique
    | _ -> failwith "Invalid random suit"
  )

(** [ajtcarte l] adds a random card to list [l], ensuring no duplicates. *)
let rec ajtcarte l =
  if List.length l = 32 then l
  else
    let rouxscard = random_carte () in
    if List.mem rouxscard l then ajtcarte l
    else rouxscard :: l

(** TEST *)
let res =
  let l1 = ajtcarte [] in
  let l2 = ajtcarte l1 in
  match l1, l2 with
  | [c], [c1; c2] -> c = c2 && c1 <> c2
  | _ -> false

(** [faitjeu n] creates a deck with [n] cards. *)
let rec faitjeu n =
  if n > 32 then failwith "Maximum 32 cards"
  else if n < 0 then failwith "Negative card count"
  else if n = 0 then []
  else ajtcarte (faitjeu (n - 1))

(** [reduc l] performs one reduction step on piles.
    If piles have matching top cards (same suit or height), fold middle pile. *)
let rec reduc l = match l with
  | (Carte (ah, ac) :: abody) :: bbody :: (Carte (ch, cc) :: cbody) :: rest_of_set ->
      if ah = ch || ac = cc then
        (bbody @ (Carte (ah, ac) :: abody)) ::
        (reduc ((Carte (ch, cc) :: cbody) :: rest_of_set))
      else
        (Carte (ah, ac) :: abody) ::
        (reduc (bbody :: (Carte (ch, cc) :: cbody) :: rest_of_set))
  | x -> x

let p1 = [carte 14 "Trefle";  carte 10 "Coeur"]
let p2 = [carte 7 "Pique";    carte 11 "Carreau"]
let p3 = [carte 14 "Carreau"; carte 8 "Pique"]
let p4 = [carte 7 "Carreau";  carte 10 "Trefle"]
let p'1 = p2 @ p1

(** TEST *)
let _ = (reduc [p1; p2; p3; p4]) = [p'1; p3; p4]

(** [reussite l] applies reductions until no more are possible. *)
let rec reussite l =
  let newl = reduc l in
  if List.length newl = List.length l then newl
  else reussite newl

let p''1 = p3 @ p'1

(** TEST *)
let res = (reussite [p1; p2; p3; p4]) = [p''1; p4]

(** Note: Graphics functions (draw_carte, draw_pile, draw_jeu, draw_reussite)
    require the Graphics library. See TP8 original implementation for full code.

    To use graphics:
    #use "topfind";;
    #require "graphics";;
    open Graphics;;

    Key functions:
    - draw_carte: draws a single card at current position
    - draw_pile: draws a vertical pile of cards
    - draw_jeu: draws all piles horizontally
    - draw_reussite: interactive game loop (press 'q' to quit)
*)
