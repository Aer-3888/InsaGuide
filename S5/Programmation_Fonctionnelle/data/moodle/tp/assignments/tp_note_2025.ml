(** Caaractères *)
(* Nom1 : PHAN
Prenom1 : Théo *)
(* Nom2 : Salem
Prenom2 : Basma*)

open LIST
    
type color = RED | BLUE | BLACK
type font  = BOLD | ITALIC

type rchar = SPACE 
           | Char of char
           | Color of color * rchar
           | Font of font * rchar

let rec get_char c = 
  match c with 
    | SPACE -> ' '
    | Char ch -> ch
    | Color(_, ch) -> get_char ch
    | Font(_, ch) -> get_char ch

let _ = get_char SPACE = ' ' 
let _ = get_char (Font(BOLD,Char 'a')) = 'a'
let _ = get_char (Color(RED,Char 'b')) = 'b'
let _ = get_char (Color(RED,Color(BLUE,Char 'c'))) = 'c'



let rec color c = 
  match c with 
    | SPACE | Char _ -> None
    | Font(_, ch) -> color ch
    | Color(cl, ch) ->
      begin match color ch with 
        | None -> Some cl
        | Some x -> 
            if cl = x then Some cl else None
        end 

let _ = color (Font(BOLD,Char 'a')) = None
let _ = color (Color(RED,Char 'b')) = Some RED
let _ = color (Color(RED,Color(RED,Char 'b'))) = Some RED
let _ = color (Color(RED, Color(RED, Color(RED, Char 'b')))) = Some RED

(** Ligne *)


let rec fill_line c i = if i = 0 then Nil else Cons(c, fill_line c (pred i))

let _ = fill_line 'c' 3 = Cons('c',Cons('c',Cons('c',Nil)))  

let rec insert_at_col c i l = 
      if i <= 0 then Cons(c,l)
      else match l with 
        | Nil -> Cons(SPACE, insert_at_col c (pred i) Nil)
        | Cons(x, rest) -> Cons(x, insert_at_col c (pred i) rest)

let _ =  insert_at_col (Char 'b') 1 (Cons(Char 'a',Cons(Char 'c',Nil))) =
         Cons(Char 'a',Cons(Char 'b',Cons(Char 'c',Nil)))
           
let _ = insert_at_col (Char 'b') 2 (Cons(Char 'a',Nil)) =
        Cons(Char 'a',Cons(SPACE,Cons(Char 'b',Nil)))


let rec remove_last c l = 
    match l with 
      | Nil -> None
      | Cons(a, rl) -> 
          begin match remove_last c rl with
            | Some l2 -> Some (Cons(a, l2))
            | None -> if a = c then Some rl else None
          end
        

let _ = remove_last (Char 'c') (Cons(Char 'a',Cons(Char 'b',Nil))) = None

let _ = remove_last (Char 'c') (Cons(Char 'c',Cons(Char 'b',Cons(Char 'c',Cons(Char 'd',Nil))))) =
        Some (Cons(Char 'c',Cons(Char 'b',Cons(Char 'd',Nil))))

(** Ligne optimisée *)

type opt_line = OptLine of rchar list * rchar * rchar list


let move_right l = 
  match l with 
    | OptLine(lbefore, c, lafter) ->
        begin match lafter with
          | Nil -> OptLine(Cons(c, lbefore), SPACE, Nil)
          | Cons(x, rest) -> OptLine(Cons(c, lbefore), x, rest)
      end
  
let l0 = OptLine(Nil,Char 'a',Cons(Char 'b',Cons(Char 'c',Nil)))
let l1 = OptLine(Cons(Char 'a',Nil),Char 'b',Cons(Char 'c',Nil))
let l2 = OptLine(Cons(Char 'b',Cons(Char 'a',Nil)),Char 'c',Nil)
let l3 = OptLine(Cons(Char 'c',Cons(Char 'b',Cons(Char 'a',Nil))),SPACE,Nil)

let _ = move_right l0 = l1
let _ = move_right l1 = l2
let _ = move_right l2 = l3

(** Texte sous forme d'arbre *)

type text = Word of rchar list
          | Append of text * text

let t0 = (Append (Append (Word (Cons(Char 'a',Cons(Char 'b',Nil))),
                           Word (Cons(Char 'c',Cons(Char 'd',Nil)))),
                         Word (Cons(Char 'e',Nil))))

let rec nb_char t = 
  match t with 
    | Word Nil -> 0
    | Word (Cons(_, rest)) -> 1 + nb_char (Word rest) 
    | Append (t1, t2) -> nb_char t1 + nb_char t2

let _ = nb_char t0 = 5

let rec fold_text fword fappend t =
   match t with
     | Word l -> fword l
     | Append(t1,t2) -> fappend (fold_text fword fappend t1) (fold_text fword fappend t2) 


let nb_char2 : text -> int = fun t -> fold_text (fun l -> nb_char (Word l)) (fun a1 a2 -> a1 + a2) t

let _ = nb_char2 t0 = 5


let line_of_text : text -> rchar list = fun t -> fold_text (fun l -> l) (fun l1 l2 -> append l1 l2) t

let _ = line_of_text  t0 = Cons(Char 'a',Cons(Char 'b',Cons(Char 'c',Cons(Char 'd',Cons (Char 'e',Nil)))))



let rec insert_char c i t =
  match t with
    | Word l -> Word (insert_at_col c i l)
    | Append(t1, t2) ->
      let len1 = nb_char t1 in
      if i < len1 then
        Append(insert_char c i t1, t2)
      else
        Append(t1, insert_char c (i - len1) t2)
      
let _ = insert_at_col (Char 'a') 3 (line_of_text t0)      
let _ = line_of_text t0
let _ = line_of_text (insert_char (Char 'a') 3 t0) = insert_at_col (Char 'a') 3 (line_of_text t0)

(** Rope *)


type rope =
  | Leaf of rchar list
  | Node of int * rope * rope

let r0 = Node (4, Node (2, Leaf (Cons (Char 'a', Cons (Char 'b', Nil))),
                                         Leaf (Cons (Char 'c', Cons (Char 'd', Nil)))),
                                Leaf (Cons (Char 'e', Nil)))

let _ = t0
let rec rope_of_text t = 
    match t with 
      | Word t -> Leaf t
      | Append (t1, t2) -> 
         let n = nb_char t1 in
         Node (n, rope_of_text t1, rope_of_text t2) 

let _ = rope_of_text t0 = r0

let rec rope_insert_char c i t = 
    match t with 
    | Leaf l -> Leaf (insert_at_col c i l) 
    | Node (n, r1, r2) -> 
        if i < n then 
          Node (n+1, rope_insert_char c i r1, r2)
        else
          Node (n, r1 ,rope_insert_char c (i-n) r2 )

let _ = rope_insert_char (Char 'a') 3 (rope_of_text t0) = rope_of_text (insert_char (Char 'a') 3 t0)
let _  = rope_of_text (insert_char (Char 'a') 3 t0)


let rec rop_compact t = 
    match t with 
      | Leaf Nil -> None
      | Leaf _ -> Some t
      | Node (n, r1, r2) -> 
        begin match (rop_compact r1, rop_compact r2) with
          | (None, None) -> None
          | (Some l, None)| (None, Some l) -> Some l
          | (Some l1, Some l2) -> Some (Node (n, l1, l2))
        end

(*TEST*)
let r1 = Node (4, Node (2, Leaf (Cons (Char 'a', Cons (Char 'b', Nil))),
                                         Leaf (Cons (Char 'c', Cons (Char 'd', Nil)))),
                                Leaf ((Nil)))

let comp0 = Node(2, Leaf (Cons (Char 'a', Cons (Char 'b', Nil))), Leaf(Cons (Char 'c', Cons(Char 'd' , Nil))))
let _ = rop_compact r1 = Some comp0

let r2 = Node (4, Node (2, Leaf (Cons (Char 'a', Cons (Char 'b', Nil))),
                                         Leaf (Cons (Char 'c', Cons (Char 'd', Nil)))),
                                Leaf (Cons (Char 'e', Nil)))

let comp1 = r2

let _ = rop_compact r2 = Some comp1

let r3 = Node (4, Node (2, Leaf (Nil),
                                         Leaf (Cons (Char 'c', Cons (Char 'd', Nil)))), 
                  Node (2, Leaf (Cons (Char 'a', Cons (Char 'b', Nil))),
                                         Leaf (Nil)))
                                        
let _ = rop_compact r3
(*FIN TEST*)