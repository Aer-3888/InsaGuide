type linexpr = {cst : int ; coeffs : (int * string) list}
let e = {cst = 2 ; coeffs = [(7,"x");(9,"y")]}

let eval_lin f le = 
  let rec eval_li l = match l with
    | [] -> 0
    | e :: l1 -> (fst e) * (f (snd e)) + eval_li l1
  in le.cst + eval_li le.coeffs

(* TEST *)
let _ = 27 = eval_lin (fun v -> if v = "x" then 1 else 2) e



let check1 le = 
  let rec checkl1 l = match l with
    | [] -> true
    | e :: l1 -> if (fst e) = 0 then false else checkl1 l1
  in checkl1 le.coeffs
(* TEST *)
let bad1 = {cst = 2 ; coeffs = [(1,"x");(0,"y")]}
let _ = false = check1 bad1
let good1 = {cst = 2 ; coeffs = [(1,"x");(3,"y")]}
let _ = true = check1 good1 



let check2 le = 
   let rec checkl2 l = match l with
     | [] -> true
     | [e] -> true
     | e1 :: e2 :: l1 -> if (snd e1) > (snd e2) then false else checkl2 (e2::l1)
   in checkl2 le.coeffs 

   (* TEST *)
let bad2 = {cst = 2 ; coeffs = [(1,"y");(7,"x")]}
let _ = false = check2 bad2
let good2 = {cst = 2 ; coeffs = [(1,"x");(3,"y")]}
let _ = true = check2 good2



let rec existe e l = match l with
| [] -> false
| a :: l1 -> if e = snd a then true else existe e l1
(* TEST *)
let exi1 = {cst = 2 ; coeffs = [(1,"x");(1,"y")]}
let _ = true = existe "x" exi1.coeffs 
let _ = false = existe "z" exi1.coeffs

let rec check3 le = 
  let rec checkl3 l = match l with
    | [] -> true
    | e :: l1 -> if existe (snd e) l1 then false else checkl3 l1
  in checkl3 le.coeffs
(* TEST *)
let bad3 = {cst = 2 ; coeffs = [(7,"x");(1,"x");(1,"z")]}
let _ = check3 bad3
let good3 = {cst = 2 ; coeffs = [(1,"x");(3,"y")]}
let _ = check3 good3

let checkline le = (check1 le) && (check2 le) && (check3 le)
(* TEST *)
let _ = checkline bad1
let _ = checkline bad2
let _ = checkline bad3
let goodline = {cst = 2 ; coeffs = [(1,"x");(3,"y")]}
let _ = checkline goodline



let constant c = {cst = c ; coeffs = []}
(* TEST *)
let _ = 3 = eval_lin (fun v -> if v = "x" then 1 else 2) (constant 3)



let variable ci xi = {cst = 0 ; coeffs = [(ci,xi)]}
(* TEST *)
let _ = 9 = eval_lin (fun v -> if v = "x" then 3 else 0) (variable 3 "x")


let rec mul i le = 
  let rec coeffsi l = match l with
    | [] -> []
    | e :: l1 -> ((fst e) * i, snd e) :: coeffsi l1
  in {cst = le.cst * i ; coeffs = coeffsi le.coeffs}
(* TEST *)
let le1 = {cst = 1 ; coeffs = [(2,"x");(2,"y")]}
let f = (fun v -> if v = "x" then 1 else 2) 
let _ = eval_lin f (mul 2 le1) = 2 * (eval_lin f le1)
let _ = checkline (mul 2 le1)


let add (i,v) le = {le with coeffs = ((i,v) :: le.coeffs)}
(* TEST *)
let _ = eval_lin f (add (2,"z") le1) = 2 * (f "z") + eval_lin f le1
let _ = checkline (add (2,"z") le1)


let norm1 le = 
  let rec norml1 l = match l with
    | [] -> []
    | e :: l1 -> if fst e = 0 then norml1 l1 else e :: (norml1 l1)
  in {cst = le.cst ; coeffs = norml1 le.coeffs}
(* TEST *)
let _ = norm1 bad1


let rec jqastable f x = if f x = x then x else jqastable f (f x)

let norm2 le =
  let rec coeffok l = match l with 
    | [] -> []
    | [e] -> [e]
    | e1 :: e2 :: l1 -> if (snd e1) > (snd e2) then e2 :: (coeffok (e1::l1)) else e1 :: (coeffok (e2::l1))
  in {cst = le.cst ; coeffs = jqastable coeffok le.coeffs}
(* TEST *)
let _ = norm2 bad2
let bad22 = {cst = 2 ; coeffs = [(3,"z");(1,"y");(7,"x")]}
let _ = norm2 bad22

(* Fonction récupérant tous les coefficients d'une variable dans une liste de coeffs*)
let rec touscoeffs e l = match l with 
| [] -> []
| e1 :: l1 -> if e = (snd e1) then fst e1 :: (touscoeffs e l1) else touscoeffs e l1
(* TEST *)
let lex = {cst = 34 ; coeffs = [(1,"x");(2,"y");(4,"x")]}
let tcx = touscoeffs "x" lex.coeffs
(* Fonction faisant la somme des éléments d'une liste et donc ici des coefficients d'une variable*)
let rec somme n l = match l with 
| [] -> n
| e :: l1 -> somme (n+e) l1
(* TEST *)
let _ = somme 0 (tcx)
(* Fonction créant un nouveau coefficient pour une variable en récupérants tous les coeffs différents et en les sommant*)
let total e l = (somme 0 (touscoeffs e l), e)
(* TEST *)
let _ = total "x" lex.coeffs
(* Fonction vérifiant si un élément est déjà contenu dans une liste *)
let rec contient e l = match l with
| [] -> false
| e1 :: l1 -> if e =  snd e1 then true else contient e l1
(* TEST *)
let _ = contient "x" [(1,"y");(1,"z");(1,"x")]
(* Fonction faisant la liste de toutes les variables d'une liste de coeffs et sans doublons*)
let rec listecoeffs l = match l with
| [] -> []
| a :: l1 -> if contient (snd a) l1 then listecoeffs l1 else (snd a)::(listecoeffs l1 )
(* TEST *)
let _ = listecoeffs lex.coeffs
(* Fonction créant une liste de coeffs uniques à partir d'une liste avec doublons*)
let rec coeffdiff l le = match l with
    | [] ->[]
    | e :: l1 -> (total e le.coeffs) :: (coeffdiff l1 le)
(* TEST *)
let _ = coeffdiff (listecoeffs lex.coeffs) lex
let norm3 le = {cst = le.cst ; coeffs = coeffdiff (listecoeffs le.coeffs) le}
(* TEST *)
let _ = norm3 bad3

let rec normalise le = 
  if not (check1 le) 
  then normalise (norm1 le) 
  else if not (check2 le) 
    then normalise (norm2 le) 
    else if not (check3 le) 
      then normalise (norm3 le) 
      else le
(* TEST *)
let reallybad = {cst = 34 ; coeffs = [(7,"y");(2,"x");(0,"z");(4,"x")]}
let _ = normalise reallybad



type 'a expr = 
| Cst of 'a
| Var of string
| Add of 'a expr * 'a expr
| Mul of 'a expr * 'a expr

let e = Add(Add(Cst 2,Mul(Cst 7,Var "x")),Mul(Cst 9,Var "y"))

type 'a anneau = 
{
  addition : 'a -> 'a -> 'a;
  multiplication : 'a -> 'a -> 'a;
  zero : 'a;
  one : 'a;
  equal : 'a -> 'a -> bool
}


let int_anneau = 
{
  addition = ( + ) ;
  multiplication = ( * ) ;
  zero = 0 ;
  one = 1 ;
  equal = ( = )
}


let rec eval_expr an f e = match e with
| Cst(c) -> c
| Var(s) -> f s
| Add(e1,e2) -> an.addition (eval_expr an f e1) (eval_expr an f e2)
| Mul(e1,e2) -> an.multiplication (eval_expr an f e1) (eval_expr an f e2)
(* TEST *)
let exp1 = Add(Cst(1),Add(Mul(Cst(2),Var("x")),Mul(Cst(2),Var("y"))))
(* 2x+2y *)
let _ = eval_expr int_anneau (fun v -> if v = "x" then 1 else 2) exp1 = 7
(* 2+7x+9y *)
let _ = eval_expr int_anneau (fun v -> if v = "x" then 1 else 2) e = 27



let rec equal_expr e1 e2 = match (e1,e2) with
| (Cst(c1),Cst(c2)) -> c1 = c2 
| (Var(v1),Var(v2)) -> v1 = v2
| (Add(e11,e12),Add(e21,e22)) -> (equal_expr e11 e21) && (equal_expr e12 e22)
| (Mul(e11,e12),Mul(e21,e22)) -> (equal_expr e11 e21) && (equal_expr e12 e22)
| (_,_) -> false
(* TEST *)
let _ = equal_expr e e
let _ = equal_expr exp1 e


let rec simpl_expr e = match e with 
  | Cst(c) -> Cst(c)
  | Var(v) -> Var(v) 
  | Add(e1,e2) ->
    begin 
      match (e1,e2) with 
      | (Cst(0),_) -> simpl_expr e2
      | (_,Cst(0)) -> simpl_expr e1
      | (Var(v1),Var(v2)) -> if v1 = v2 then Mul(Cst(2),Var(v1)) else Add(e1,e2)
      | (a,b) -> Add(simpl_expr a, simpl_expr b)
    end
  | Mul(e1,e2) -> 
    begin
      match (e1,e2) with
      | (Cst(1),_)  -> simpl_expr e2 
      | (_,Cst(1))  -> simpl_expr e1 
      | (Cst(0),_)  -> Cst(0)
      | (_,Cst(0))  -> Cst(0)
      | (a,b)       -> Mul(simpl_expr a, simpl_expr b)
    end
(* TEST *)
let s0x = Add(Cst(0),Var("x"))
let _ = simpl_expr s0x
let sx0 = Add(Var("x"),Cst(0))
let _ = simpl_expr sx0
let sxx = Add(Var("x"),Var("x"))
let _ = simpl_expr sxx
let m1x = Mul(Cst(1),Var("x"))
let _ = simpl_expr m1x
let mx1 = Mul(Var("x"),Cst(1))
let _ = simpl_expr mx1
let m0x = Mul(Cst(0),Var("x"))
let _ = simpl_expr m0x
let mx0 = Mul(Var("x"),Cst(0))
let _ = simpl_expr mx0

let expr_of_linexpr le = 
  let rec exp_coeff l = match l with
    | [] -> Cst(0)
    | e :: l1 -> Add(Mul(Cst(fst e),Var(snd e)), exp_coeff l1)
  in simpl_expr(Add(Cst(le.cst),exp_coeff le.coeffs))
(* TEST *)
let linexp = {cst = 34 ; coeffs = [(2,"x");(3,"y")]}
let expexp = expr_of_linexpr linexp

let rec linexpr_of_expr e = match e with 
| Cst(c) -> {cst = c ; coeffs = []}
| Var(v) -> {cst = 0 ; coeffs = [(1,v)]}
| Add(e1,e2) -> let a = linexpr_of_expr e1 in let b = linexpr_of_expr e2
                in normalise {cst = a.cst + b.cst ; coeffs = a.coeffs @ b.coeffs}
| Mul(e1,e2) ->
  begin
    match (e1,e2) with
    | (Cst(c),Var(v)) | (Var(v),Cst(c)) -> {cst = 0 ; coeffs = [(c,v)]}
    | (_,_) -> failwith "Erreur : l'expression n'est pas linéaire"
  end
(* TEST *)
let _ = linexpr_of_expr expexp


