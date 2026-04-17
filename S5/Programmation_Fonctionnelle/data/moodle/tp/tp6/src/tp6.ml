(** TP6 - Binary Trees
    Tree data structures, traversals, BST, positioning *)

(** Binary tree type: either a leaf or a node with left/right children *)
type 'a arbin =
  | Feuille of 'a
  | Noeud of 'a arbin * 'a * 'a arbin

(** [feuille v] creates a leaf node with value [v]. *)
let feuille v = Feuille v

(** [noeud v g d] creates a node with value [v], left child [g], right child [d]. *)
let noeud v g d = Noeud (g, v, d)

(** [compter a] counts the number of leaf nodes in tree [a]. *)
let rec compter a = match a with
  | Feuille b -> 1
  | Noeud (g, _, d) -> compter g + compter d

(** TEST *)
let arbre_test = noeud 12 (feuille 5) (noeud 7 (feuille 6) (feuille 8))
let _ = compter arbre_test (* 3 *)

(** [to_list a] converts tree [a] to a list using inorder traversal. *)
let rec to_list a = match a with
  | Feuille b -> [b]
  | Noeud (g, c, d) -> to_list g @ [c] @ to_list d

(** TEST *)
let _ = to_list arbre_test (* [5; 12; 6; 7; 8] *)

(** [ajoutArbre e a] inserts element [e] into binary search tree [a]. *)
let rec ajoutArbre e a = match a with
  | Noeud (g, c, d) ->
      if e < c then Noeud (ajoutArbre e g, c, d)
      else Noeud (g, c, ajoutArbre e d)
  | Feuille b -> Noeud (Feuille "Nil", e, Feuille "Nil")

(** [constr l] constructs a binary search tree from list [l]. *)
let rec constr l = match l with
  | [] -> Feuille "Nil"
  | e1 :: tl -> ajoutArbre e1 (constr tl)

let l = ["celeri"; "orge"; "mais"; "ble"; "tomate"; "soja"; "poisson"]

(** TEST *)
let _ =
  List.filter (fun s -> s <> "Nil") (to_list (constr l)) =
  List.sort compare l

(** Coordinate type for positioning *)
type coord = int * int

(** Binary tree with positioned nodes *)
type 'a arbinp = (coord * 'a) arbin

let d = 5  (* Vertical spacing *)
let e = 4  (* Horizontal spacing *)

(** [compterter a] counts all nodes (leaves and internal) in tree [a]. *)
let rec compterter a = match a with
  | Feuille f -> 1
  | Noeud (g, c, d) -> compterter g + compterter d + 1

(** [placer a] assigns (x, y) coordinates to each node in tree [a].
    Uses inorder traversal for x-coordinates and depth for y-coordinates. *)
let placer a =
  let rec aux a h l = match a with
    | Feuille v -> (Feuille ((l + e, h + d), v), l + e)
    | Noeud (g, v, dr) ->
        let (gauche, posg) = aux g (h + d) l in
        let (droite, posd) = aux dr (h + d) (posg + e) in
        (Noeud (gauche, ((posg + e, h + d), v), droite), posd)
  in
  let a, _ = aux a 0 0 in
  a

(** Test tree *)
let t =
  noeud 'a'
    (feuille 'j')
    (noeud 'b'
       (noeud 'c'
          (noeud 'd' (feuille 'w') (feuille 'k'))
          (feuille 'z'))
       (feuille 'y'))

(** TEST *)
let res = (placer t = noeud ((8, 5), 'a')
     (feuille ((4, 10), 'j'))
     (noeud ((32, 10), 'b')
        (noeud ((24, 15), 'c')
           (noeud ((16, 20), 'd')
              (feuille ((12, 25), 'w'))
              (feuille ((20, 25), 'k')))
           (feuille ((28, 20), 'z')))
        (feuille ((36, 15), 'y'))))
