(*Question 1*)
type bit = B0|B1

type bint = bit list

(*Question 2*)
let int_of_bit a =match a with
|B0 ->0
|B1 ->1

(*Question 3*)
let int_of_bint (a:bint) = List.fold_right (fun x y -> (int_of_bit x)+2*y ) a 0

(*Question 4*)
let rec count_zeros (a:bint) = match a with
|b::c -> if b = B0 then 1 + count_zeros c else 0
|[] -> 0

(*Question 5*)
let rec count_and_remove (a:bint) = match a with
|b::c -> if b = B1 then (0, a) else let res = count_and_remove c in
  (1+fst res, snd res)
|[] -> (0, a)

(*Question 6*)
let normalise (a:bint) = List.rev(snd (count_and_remove (List.rev a)))

type comparaison = EQUAL | LESSTHAN |GREATERTHAN

let cmp_int i j = if i = j then EQUAL else if i < j then LESSTHAN else GREATERTHAN

(*Question 7*)
let rec is_sorted f l = match l with
|[] -> true
|a::[] -> true
|a::b::c -> if (f a b) = GREATERTHAN then false else is_sorted f (b::c)

(*Question 8*)
let rec add_elt cmp a l = match l with
|b::c -> if cmp a b = GREATERTHAN then b::(add_elt cmp a c) else a::b::c
|[] -> a::[]

(*Question 9*)
let rec union cmp l1 l2 = match (l1,l2) with
|([],a)->a
|(a,[])->a
|(a::c,b::d)-> if cmp a b = LESSTHAN then (a::(union cmp c l2)) else (b::(union cmp l1 d))

type intset= Empty |Node of intset*bool*intset

(*Question 10*)
let rec cardinal a = match a with
| Empty -> 0
| Node(g,true,d) -> 1 + cardinal g + cardinal d
| Node(g,false,d) -> cardinal g + cardinal d

(*Question 11*)
let rec mem s (i:bint) = match i with 
|[] -> (match s with 
  |Empty -> false
  |Node(_,b,_) -> b)
|a::b -> match s with
  |Empty -> false
  |Node(g,_,d)-> if a=B0 then mem g b else mem d b

(*Question 12*)
let rec singleton (i:bint) = match i with
|B0::a -> Node(singleton a,false,Empty)
|B1::a -> Node(Empty,false,singleton a)
|[] -> Node(Empty,true,Empty)

(*Question 13*)
let rec add_elt (i:bint) s = match s with
|Empty -> singleton i
|Node(g,b,d) -> match i with
  |B0::a -> Node((add_elt a g),b,d)
  |B1::a -> Node(g,b,(add_elt a d))
  |[] -> Node(g,true,d)

(*Question 14*)
let rec remove_elt (i:bint) s = match s with
|Empty -> Empty
|Node(g,b,d) -> match i with
  |[] -> Node (g,false,d)
  |B0::a -> Node((remove_elt a g),b,d)
  |B1::a -> Node(g,b,(remove_elt a d))

(*Question 15*)
let rec is_empty (i:intset) = match i with 
|Empty -> true
|Node(g,b,d) -> match is_empty g,b, is_empty d with
  |true,false,true -> true
  |_ -> false

(*Question 16*)
let rec minimise a = match a with
|Empty -> Empty
|Node(Empty,false,Empty)-> Empty
|Node(g,b,d) -> Node(minimise g,b,minimise d)

(*Question 17*)
let rec union a1 a2 = match a1,a2 with
|Empty,a -> a
|a,Empty -> a
|Node(g1,b1,d1),Node(g2,b2,d2)-> Node((union g1 g2),b1||b2,(union d1 d2))

(*Question 18*)
let div2 a = match a with 
|Empty -> Empty
|Node(a,b,c)-> if b then add_elt [] (union a c) else union a c

(*Question 19*)
let rec elements a = match a with
|Empty -> []
|Node(g,true,d)-> let (i:bint) = [] in i::( (List.map (fun i-> B0::i) (elements g))@(List.map (fun i-> B1::i) (elements d)) )
|Node(g,false,d) -> (List.map (fun i-> B0::i) (elements g))@(List.map (fun i-> B1::i) (elements d))

let rec bint_to_str b = match b with
|[] -> "\n"::[]
|B0::a -> "B0"::(bint_to_str a)
|B1::a -> "B1"::(bint_to_str a)

let rec elements_aux s l lb = match s with
|Empty -> ([],[[]])
|Node(g,b,d)-> let a= if b then l::lb else lb in 
  let resg = elements_aux g (B0::l) lb in
    let resd = (elements_aux d (B1::l) lb) in
      ([],a@(snd resg)@(snd resd))
    

let elements2 s = if s = Empty then [] else List.map List.rev (snd (elements_aux s [] [[]])) 

let i = add_elt [] (add_elt [B0;B0;B1;B0;B1] (add_elt [B0;B0;B1;B0] (singleton [B0;B0;B0;B1])))
