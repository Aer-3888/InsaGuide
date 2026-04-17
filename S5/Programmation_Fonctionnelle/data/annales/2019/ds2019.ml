(*Examen 2019 Version de Léo-Paul JULIEN*)

type linexpr = {cst : int; coeffs : (int * string) list }
               
let e = {cst = 2 ; coeffs = [(7,"x");(9,"y")]}
        
let _ = e.cst

(*Question 1*)        
let rec eval_lin f le = match le with 
  |{cst = c; coeffs = l} -> c + let rec aux f l = match l with
      |(a,b)::reste -> a * (f b) + aux f reste 
      |[] -> 0
    in aux f l
  
let _ = eval_lin (fun v -> if v = "x" then 1 else 2) e

(*Question 2*)
    
let rec checkC1 le = match le with 
  |{cst = c; coeffs = l} -> let rec aux l = match l with
      |(a,b)::reste -> if a = 0 then false else aux reste 
      |[] -> true
      in aux l    
  
let bad1 = {cst = 2 ; coeffs = [(7,"x");(9,"y");(0,"z")]}
let _ = checkC1 bad1
let _ = checkC1 e
    
(*Question 3*)
let rec checkC2 le = match le with 
  |{cst = c; coeffs = l} -> let rec aux l = match l with
      |(a,b)::(c,d)::reste -> let tail = (c,d)::reste in if b > d then false else aux tail
      |(_,_)::[] -> true
      |[] -> false
      in aux l     
        
          
let bad2 = {cst = 2 ; coeffs = [(9,"y");(7,"x")]}
let _ = checkC2 bad2
let _ = checkC2 e

(*Question 4*)
    
let rec appartient e l = match l with
  |[] -> false
  |(a,b)::reste -> if b = e then true else appartient e reste

let checkC3 le = match le with
|{cst = c; coeffs = l} -> let rec aux l = match l with
  |(a,b)::reste -> if appartient b reste then false else aux reste
  |[] -> true
  in aux l
        
let bad3 = {cst = 2 ; coeffs = [(4,"y");(7,"x");(5,"y")]}
let _ = checkC3 bad3
let _ = checkC3 e
    
 (*Question 5*)   
let checklin le = if (checkC1 le) && (checkC2 le) && (checkC3 le) then true else false
    
let _ = checklin e

(*Question 6*)
let constant c = {cst = c;coeffs = []}
  
let _ = constant 2

(*Question 7*)
let variable ci xi = {cst = 0 ; coeffs=[(ci,xi)]}

let _ = variable 2 "x"

(*Question 8*)

let rec mult l i = match l with 
|[] -> []
|(a,b)::reste -> ((a*i),b)::(mult reste i) 

let _ = mult [(4,"y");(7,"x");(5,"y")] 2

let mul i le = match le with
|{cst = c; coeffs = []} -> {cst = c * i; coeffs = []}
|{cst = c; coeffs = l} -> {cst = c * i; coeffs = mult l i}


let _ = mul 2 e
let _ = mul 2 (variable 2 "x")

let _ = checklin (mul 2 e) = true

(*Quesion 9*)

let rec addt (i,v) l = match l with 
|[] -> []
|(a,b)::reste -> if b = v then ((a+i),b)::(addt (i,v) reste) else (a,b)::(addt (i,v) reste)

let _ = addt (3,"y") [(4,"y");(7,"x");(5,"y")]

let add (i,v) le = match le with
|{cst = c; coeffs = []} -> {cst = c; coeffs = []}
|{cst = c; coeffs = l} -> {cst = c ; coeffs = addt (i,v) l}

let _ = add (3,"y") e

(*Question 10*)

let rec transfC1 l = match l with
|(a,b)::reste -> if a = 0 then transfC1 reste else (a,b)::(transfC1 reste)
|[] -> []

let _ = transfC1 [(0,"x");(9,"y");(1,"z")]

let rec transfC2 l = match l with
|[] -> []
|(a,b)::(c,d)::reste -> if b > d then (c,d)::(transfC2 ((a,b)::reste)) else (a,b)::(transfC2 ((c,d)::reste))
|(a,b)::[] -> [(a,b)]

let _ = transfC2 [(4,"y");(7,"x");(5,"z")]

let string_of_char c = String.make 1 c
let _ = string_of_char 'a'

let transfC3 l =  let rec aux l i = match l with
|(a,b)::reste -> if appartient b reste then (a,string_of_char (char_of_int((i%26)+97)))::(aux reste (i+1)) else (a,b)::(aux reste i)
|[] -> []
in aux l 0

let _ = transfC3 [(4,"y");(7,"x");(5,"y")]

let normalise le = {cst = le.cst; coeffs = transfC1 (transfC2(transfC3 le.coeffs))}


let _ = normalise bad1
let _ = normalise bad2
let _ = normalise bad3


(*Partie 2*)

type 'a expr = 
  |Cst of 'a
  |Var of string
  |Add of 'a expr * 'a expr
  |Mul of 'a expr * 'a expr

let e = Add(Add(Cst 2,Mul(Cst 7,Var "x")),Mul(Cst 9,Var "y"))

(*Question 11*)
type 'a anneau = 
{
  addition : 'a -> 'a ->'a;
  multiplication : 'a -> 'a -> 'a;
  zero : 'a;
  one : 'a;
  equal : 'a -> 'a -> bool;
}

(*Question 12*)

let int_anneau = 
  {
    addition = (+);
    multiplication = ( * );
    zero = 0;
    one = 1;
    equal = ( = );

}
(*Question 13*)

let rec eval_expr an f e = match e with
|Cst(c) -> c
|Var (s) -> (f s)
|Add(p,q) -> an.addition (eval_expr an f p) (eval_expr an f q)
|Mul(p,q) -> an.multiplication (eval_expr an f p) (eval_expr an f q)

let _ = eval_expr int_anneau (fun v -> if v = "x" then 1 else 2) e

(*Question 14*)

let rec equal_expr e1 e2 = match e1 with
|Cst(c) -> if (e2 = Cst(c)) then true else false
|Var(s) -> if (e2 = Var(s)) then true else false
|Add(p,q) -> begin match e2 with
  |Cst(c2) -> false
  |Var(v2) -> false
  |Add(s,r) -> equal_expr p s && equal_expr q r
  |Mul(s,r) ->false
  end
|Mul(p,q) -> begin match e2 with
  |Cst(c2) -> false
  |Var(v2) -> false
  |Add(s,r) ->false
  |Mul(s,r) -> equal_expr p s && equal_expr q r
end

let e1 = Add(Add(Cst 2,Mul(Cst 7,Var "x")),Mul(Cst 8,Var "y"))

let _ = equal_expr e e

(*Question 15*)

let rec simpl_expr e = match e with
|Cst(c) -> Cst(c)
|Var(s) -> Var(s)
|Add(p,q) -> begin match (p,q) with 
  |(Cst(0),_) -> simpl_expr q
  |(_,Cst(0)) -> simpl_expr p
  |(Var(s1),Var(s2)) -> if s1 = s2 then Mul(Cst(2),Var(s1)) else Add(p,q)
  |(a,b) -> Add(simpl_expr a,simpl_expr b)
  end
|Mul(p,q) -> begin match (p,q) with
  |(Cst(1),_) -> simpl_expr q
  |(_,Cst(1)) -> simpl_expr p
  |(Cst(0),_) -> Cst(0)
  |(_,Cst(0)) -> Cst(0)
  |(a,b) -> Mul(simpl_expr a, simpl_expr b)
end

let e2 = Add(Cst 0, Var "x")
let e3 = Add(Var "x",Mul(Cst 0,Var "x"))
let e4 = Mul(Cst (-1),Var "x")
let _ = simpl_expr e3

(*Question 16*)

let rec trans_linexpr l = match l with 
|[] -> Cst(0)
|(a,b)::reste -> Add(Mul(Cst(a),Var(b)),trans_linexpr reste)



let rec expr_of_linexpr le = match normalise le with
|{cst = c; coeffs = l } -> simpl_expr(Add(Cst(c),trans_linexpr l))

let le1 = {cst = 14;coeffs=[(2,"x");(2,"y");(3,"x")]} 
let e7 = expr_of_linexpr le1

(*Question 17*)

exception Erreur of string

let rec linexpr_of_expr e = match e with
|Cst(c) -> normalise {cst = c; coeffs = []} 
|Var(v) -> normalise {cst = 0; coeffs = [1,v]}
|Add(p,q) -> let e1 = linexpr_of_expr p and e2 = linexpr_of_expr q 
  in normalise {cst = e1.cst + e2.cst; coeffs = e1.coeffs@e2.coeffs}
|Mul(p,q) -> match (p,q) with
  |(Cst(p),Var(q)) | (Var(q),Cst(p)) -> normalise {cst = 0; coeffs = [p,q]}
  |(_,_) -> raise (Erreur "conversion impossible")  

let _ = linexpr_of_expr e1 

(*Question 18*)

let simpl_plus e = expr_of_linexpr (linexpr_of_expr (simpl_expr(e)))

let simpl_plus1 e = try expr_of_linexpr (linexpr_of_expr e) with Erreur "conversion impossible" -> expr_of_linexpr (linexpr_of_expr (simpl_expr(e)))

let _ = simpl_plus e3


let e4 = Add(Mul (Cst 0,Mul(Var "x",Var "y")),Mul(Add(Cst 0,Cst 1),Var "x"))
let _ = linexpr_of_expr e4
let _ = simpl_plus1 e4
let e8 = Add (Cst 14,
Add (Mul (Cst 2, Var "x"),
 Add (Mul (Cst 2, Var "y"), Mul (Cst 3, Var "x"))))

 let _ = simpl_plus e8