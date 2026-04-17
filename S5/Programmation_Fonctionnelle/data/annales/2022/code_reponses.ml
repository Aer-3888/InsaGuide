(* Opérations sur les mots *)
type 'alphabet word = 'alphabet list

let rec string_of_list f sep l = 
  match l with
  | [] -> "e"
  | h::[] -> f h
  | h::t -> (f h)^sep^(string_of_list f sep t)

let _ = string_of_list string_of_int ";" [1;2;3]
let _ = string_of_list string_of_int ";" [1]
let _ = string_of_list string_of_int ";" []

type bin = bool word

let string_of_bin bin = string_of_list (fun x -> if x then "1" else "0") "." bin

let _ = string_of_list string_of_int ";" []

let _ = string_of_bin [true; false; true]
let _ = string_of_bin []

let string_of_words l = string_of_list string_of_bin ";" l

let _ = string_of_words [[false; true; true];[];[true; true; true]]

let rec commbn_prefix l1 l2 = 
  match (l1, l2) with
  | (h1::t1, h2::t2) ->
    if h1=h2 then
      let (prefix, r1, r2) = commbn_prefix t1 t2
      in
      (h1::prefix, r1, r2)
    else
      ([], l1, l2)
  | (_, _) -> ([], l1, l2)

let _ = commbn_prefix [1;2;3] [1;2;4;5]

let all_pairs l1 l2 = List.concat (List.map (fun x -> List.map (fun y -> (x, y)) l2) l1)

let _ = all_pairs [1; 2; 3; 4] [5; 6; 7; 8]

let rec partition_symbol c l =
  match l with
  | [] -> ([], [])
  | h::t -> 
    begin
      let (x, y) = partition_symbol c t
      in
      match h with
      | [] -> (x, []::y)
      | h2::t2 -> if h2=c then (t2::x, y) else (x, h::y)
    end

let _ = partition_symbol 1 [[1;2;3];[2;4];[1;4;5];[6;7]]


(* Expression régulières *)
type 'alphabet regexp =
| Empty
| Epsilon
| Symbol of 'alphabet
| Concat of 'alphabet regexp * 'alphabet regexp
| Union of 'alphabet regexp * 'alphabet regexp

let rec alphabet r = 
  match r with
  | Empty -> []
  | Epsilon -> []
  | Symbol x -> [x]
  | Concat (x, y) -> (alphabet x)@(alphabet y)
  | Union (x, y) -> (alphabet x)@(alphabet y)

let _ = alphabet (Concat(Symbol 0, Union(Concat(Symbol 1, Symbol 0), Concat(Symbol 1, Epsilon))))

let rec words reg = match reg with
| Empty -> []
| Epsilon -> [[]]
| Symbol x -> [[x]]
| Concat (x, y) -> List.concat (List.map (fun i -> List.map (fun j -> j@i) (words x)) (words y))
| Union (x, y) -> (words x)@(words y)

let _ = words (Concat(Union(Symbol 0, Symbol 1), Union(Concat(Symbol 1, Symbol 0), Concat(Symbol 1, Epsilon))))

let rec simplify reg = match reg with
| Concat (x, Epsilon) -> simplify x
| Concat (Epsilon, x) -> simplify x
| Concat (Empty, x) -> Empty
| Concat (x, Empty) -> Empty
| Concat (x, y) -> Concat(simplify x, simplify y)
| Union (x, Empty) -> simplify x
| Union (Empty, x) -> simplify x
| Union (x, y) -> Union(simplify x, simplify y)
| _ -> reg

let rec regexp_of_word w = match w with
| [] -> Epsilon
| h::t -> Concat(Symbol h, regexp_of_word t)

let _ = regexp_of_word [1; 1; 0]

let rec regexp_2words w1 w2 = 
  let (prefix, t1, t2) = commbn_prefix w1 w2
  in
  simplify (Concat(regexp_of_word prefix, Union(regexp_of_word t1, regexp_of_word t2)))

let _ = regexp_2words [0; 0; 1; 0; 0] [0; 0; 0; 1; 0]

let rec of_words l = match l with
| [] -> Empty
| h::t -> 
  begin 
    match h with
    | [] -> Union(Epsilon, of_words t)
    | a::_ ->
    let (f, r) = partition_symbol a l
    in
    simplify (Union(Concat(Symbol a, of_words f), of_words r))
  end

let _ = of_words [["a"; "b"; "c"];["d"; "e"];[];["a"; "b"; "d"];["d"; "e"; "f"]]

let rec hasEpsilon reg = match reg with
| Empty -> false
| Epsilon -> true
| Symbol _ -> false
| Concat (x, y) -> hasEpsilon x && hasEpsilon y
| Union (x, y) -> hasEpsilon x || hasEpsilon y

let _ = hasEpsilon (Union
(Concat (Symbol "a", Concat (Symbol "b", Union (Symbol "c", Symbol "d"))),
Union (Concat (Symbol "d", Concat (Symbol "e", Union (Epsilon, Symbol "f"))),
 Epsilon)))

let brz s reg = 
  match reg with
  | Empty -> Empty
  | Epsilon -> Empty
  | Symbol x -> if x=s then Epsilon else Empty
  | Concat(x, y) -> if hasEpsilon x then simplify (Union(Concat(brz s x, y), brz s y))
                    else simplify (Concat(brz s x, y))
  | Union(x, y) -> simplify (Union(brz s x, brz s y))


let _ = simplify (brz "a" (Union(Union(Concat(Symbol "a", Symbol "b"), Concat(Symbol "a", Symbol "c")), Concat(Symbol "c", Symbol "d"))))

let rec mem word reg = match word with
| [] -> hasEpsilon reg
| h::t -> mem t (brz h reg)

let _ = mem ["a"; "b"; "c"] (Union
 (Concat (Symbol "a", Concat (Symbol "b", Union (Symbol "c", Symbol "d"))),
 Union (Concat (Symbol "d", Concat (Symbol "e", Union (Epsilon, Symbol "f"))),
  Epsilon)))

let _ = mem ["a"; "b"; "f"] (Union
 (Concat (Symbol "a", Concat (Symbol "b", Union (Symbol "c", Symbol "d"))),
 Union (Concat (Symbol "d", Concat (Symbol "e", Union (Epsilon, Symbol "f"))),
  Epsilon)))