(* Examen Ocaml 2020 *)
(* Nom:              *)
(* Prénom:           *)

(** {Nombre en représentation binaire} **)

(* Q1 *)

type bit = B0| B1

type bint = bit list

(* Q2  *)

let int_of_bit b = match b with
|B0 -> 0
|B1 -> 1

let _ = int_of_bit B0 = 0 && int_of_bit B1 = 1;;

(* Q3 *)
let rec int_of_bint l = let sum x e = int_of_bit x+ 2*e in 
List.fold_right sum l 0

let _ = int_of_bint [B1] = 1 && int_of_bint [B1;B0;B1] = 5;;

(* function elle doit faire acc += Bit*2 >// on initialise acc a 1 dans fold right *)
(* Q4 *)

let rec count_zeros l =match l with
|[B1]->0
|[B0]->1
|e::tl->if e= B0 then 1+count_zeros tl else 0

let _ = count_zeros [B0;B0;B0;B1;B0;B1] = 3;;

(* Q5 *)

let rec count_and_remove l = match l with
|[B1]->([B1],0)
|[B0]->([],1)
|e::tl->if e= B0 then (fst(count_and_remove tl),1+snd(count_and_remove tl)) else (e::tl,0)

let _ = count_and_remove [B0;B0;B0;B1;B0;B1] = ([B1;B0;B1], 3);;

(* Q6 *)

let normalise l = List.rev (fst(count_and_remove (List.rev l)))


let _ =
  let n1 = normalise [B0;B1;B1] in
  let n2 = normalise [B0;B1;B1;B0] in
  let n3 = normalise [B0;B1;B1;B0;B0] in
  n1 = n2 && n2 = n3 && n3 = [B0;B1;B1];;


(** {Bibliothèque d'ensembles} *)
type comparison = EQUAL| LESSTHAN| GREATERTHAN

let cmp_int = fun i j -> if i = j then EQUAL else if i < j then LESSTHAN else GREATERTHAN;;

(* Q7 *)

let rec is_sorted cmp l = match l with
|e::f::[]->if cmp e f = LESSTHAN then true else false
|e::f::tl->if cmp e f = LESSTHAN then is_sorted cmp (f::tl) else false

let _ = (is_sorted cmp_int [1;5;7]) && not (is_sorted cmp_int [1;7;5]);;

(** Q8 *)

let rec add_elt cmp e l = match l with
|[] -> [e]
|e1::tl -> if cmp e1 e = GREATERTHAN then e::e1::tl else [e1]@add_elt cmp e tl

let _ = add_elt cmp_int 6 [1;5;7] = [1;5;6;7];;

(* Q9 *)

let rec union cmp l1 l2 = match (l1,l2) with
|[],_->l2
|_,[]->l1
|(e1::t1,e2::t2)-> (match cmp e1 e2 with
                    |GREATERTHAN -> [e2]@union cmp l1 t2
                    |EQUAL -> [e1]@union cmp t1 t2
                    |LESSTHAN -> [e1]@union cmp t1 l2
                    )

let _ = union cmp_int [1;5;7] [2;5;6] = [1;2;5;6;7];;


(** {Représentation d'ensembles d'entiers} *)

type intset = Empty | Node of intset * bool * intset;;

(* Soit la liste d'entiers binaires l qui représente l'ensemble {0;2;3;4;7}. *)
let l = [ [] ; [B0;B1] ; [B1;B1] ; [B0;B0;B1] ; [B1;B1;B1] ];;
(* L'arbre a reprśente la liste l sous forme de intset *)
let a = Node
          (Node (Node (Empty, false, Node (Empty, true, Empty)), false,
                 Node (Empty, true, Empty)),
           true, Node (Empty, false, Node (Empty, true, Node (Empty, true, Empty))))

(* Q10 *)

let rec cardinal s = match s with
|Node(a,boole,barbarin)-> if boole = true then 1+cardinal a + cardinal barbarin else cardinal a + cardinal barbarin
|Empty ->0

let _ = cardinal Empty = 0 && cardinal a = 5

(* Q11 *)

let rec mem s x = match s,x with 
|Node(a,booll,b),[]->booll
|Node(a,booll,b),e::tl-> if e = B0 then mem a tl else mem b tl
|Empty,_ -> false



let _ = mem a [] && mem a [B0;B0;B1] && not (mem a [B1]);;

(* Q12 *)

let rec singleton l = match l with
|[]->Node(Empty,true,Empty)
|e::tl -> if e = B0 then Node(singleton tl,false,Empty) else Node(Empty,false,singleton tl)

let _ = singleton [B0;B1] = Node (Node (Empty, false, Node (Empty, true, Empty)), false, Empty);;

(* Q13 *)

let rec add_elt i s = match i,s with
|[],Node(a,boool,b) -> Node(a,true,b)
|[],Empty ->Node(Empty,true,Empty)
|e::tl,Node(a,b,c)->if e =B0 then Node(add_elt tl a,b,c) else Node(a,b,add_elt tl c)
|e::tl,Empty -> if e =B0 then Node(add_elt tl Empty,false,Empty) else Node(Empty,false,add_elt tl Empty)


let a1 = Node
 (Node (Node (Empty, false, Node (Empty, true, Empty)), false,
   Node (Empty, true, Node (Empty, true, Empty))),
 true, Node (Empty, false, Node (Empty, true, Node (Empty, true, Empty))));;

let _ = add_elt [B1;B1] a = a &&  add_elt [B0;B1; B1] a = a1;;


(* Q14 *)

let rec remove_elt i s = match i,s with
|[],Node(a,b,c)->Node(a,false,c)
|_,Empty->Empty
|e::tl,Node(a,b,c)->if e=B0 then Node (remove_elt tl a,b,c) else Node(a,b,remove_elt tl c)


let _ = remove_elt [] Empty = Empty &&
          remove_elt [B1;B1;B1] Empty = Empty &&
            remove_elt [] a  = Node
          (Node (Node (Empty, false, Node (Empty, true, Empty)), false,
                 Node (Empty, true, Empty)),
           false, Node (Empty, false, Node (Empty, true, Node (Empty, true, Empty)))) &&
              remove_elt [B1;B1;B1] a = 
                Node
                  (Node (Node (Empty, false, Node (Empty, true, Empty)), false,
                         Node (Empty, true, Empty)),
                   true, Node (Empty, false, Node (Empty, true, Node (Empty, false, Empty))));;

(* Q15 *)

let rec is_empty s = match s with
|Node(a,b,c)->if b=true then false else is_empty a && is_empty c
|Empty->true

let _ = is_empty Empty = true  &&
        is_empty (Node(Empty, false, Empty)) = true &&
          is_empty (Node(Empty, true, Empty)) = false &&
            is_empty a = false;;

(* Q16 *)


let rec minimise s = match s with
|Empty -> Empty
|Node(a,b,c)-> (match is_empty a,is_empty c with
				|true,true->if b=true then Node (Empty,b,Empty) else Empty
				|false,true->Node(minimise a,b,Empty)
				|true,false->Node(Empty,b,minimise c)
				|false,false->Node(minimise a,b,minimise c)
				)



let _ = minimise Empty = Empty &&
          minimise (Node(Empty,false,Empty)) = Empty &&
            minimise
              (Node
                 (Node (Node (Empty, false, Node (Empty, false, Empty)), false,
                     Node (Empty, false, Empty)),
                  false, Node (Empty, false, Node (Empty, true, Node (Empty, false, Empty))))) =
              Node (Empty, false, Node (Empty, false, Node (Empty, true, Empty)));;

(* Q17 *)

let rec union s1 s2 = match s1,s2 with
|Empty, Empty->Empty
|Empty,Node(a,b,c)->Node (a,b,c)
|Node(a,b,c),Empty->Node(a,b,c)
|Node(a1,b1,c1),Node(a2,b2,c2)-> Node(union a1 a2, b1 || b2,union c1 c2)


let u1 =
  (* [ [] ; [B0;B1] ; [B1;B1;B1] ] *)
  Node (Node (Empty, false, Node (Empty, true, Empty)), true,
               Node (Empty, false, Node (Empty, false, Node (Empty, true, Empty))));;
let u2 = 
  (*[[B1;B1];[B0;B0;B1];[B1;B1;B1]] *)
  Node (Node (Node (Empty, false, Node (Empty, true, Empty)), false, Empty),
        false, Node (Empty, false, Node (Empty, true, Node (Empty, true, Empty))));;

let _ = union u1 Empty = u1 && union Empty u2 = u2 && union u1 u2 = a;;


(* Q18 *)

let div2 s = match s with
|Empty -> Empty
|Node(a,b,c)-> union a c

let _ =
  div2 Empty = Empty
  && div2 (Node(Empty, true, Empty)) = Empty
  && div2 (Node(Node(Empty, true, Empty),false,Empty)) = Node(Empty, true, Empty)
  && div2 (Node(Empty,false,Node(Empty, true, Empty))) = Node(Empty, true, Empty)
  && div2 a = Node (Node (Empty, false, Node (Empty, true, Empty)), false,
   Node (Empty, true, Node (Empty, true, Empty)));;

(* Q19 *)


let rec elements s = match s with
|Empty -> []
|Node(a,b,c)->if b then [[]]@(List.map(fun l->B0::l) (elements a))@(List.map(fun l->B1::l) (elements c)) else (List.map(fun l->B0::l) (elements a))@(List.map(fun l->B1::l) (elements c))
    
let _ =
  elements Empty = [] &&
  elements (Node(Empty, true, Empty)) = [[]]  &&
    elements (Node (Node(Empty,true, Empty), false, Empty)) = [[B0]]  &&
      elements (Node(Empty, false, (Node(Empty, true, Empty)))) = [[B1]]  &&
        List.sort compare (elements a) = List.sort compare l;;




