type qname = (char list) list


let check q = 
  List.for_all (fun x -> if x=[] then false else (List.for_all (fun y -> if y='.' then false else true) x)) q

let _ = check [['j'; 'a'; 'v'; 'a'; '.'; 'l'; 'a'; 'n'; 'g' ] ; ['O'; 'b'; 'j'; 'e'; 'c'; 't']]
let _ = check [['j'; 'a'; 'v'; 'a'] ; [] ; ['O'; 'b'; 'j'; 'e'; 'c'; 't']]
let _ = check [['j'; 'a'; 'v'; 'a'] ; ['l'; 'a'; 'n'; 'g' ] ; ['O'; 'b'; 'j'; 'e'; 'c'; 't']]

let rec extract l = match l with
| [] -> ([], [])
| h::t -> if h='.' then ([], t) 
          else let (p, r) = extract t in (h::p, r)

let _ = extract ['j'; 'a'; 'v'; 'a'; '.' ; 'l'; 'a'; 'n'; 'g' ; '.' ;'O'; 'b'; 'j'; 'e'; 'c'; 't']

let rec make l = match extract l with
| ([], []) -> None
| ([], t) -> None
| (p, []) -> Some [p]
| (p, r) -> let reste = make r in match reste with
          | None -> None
          | Some x -> Some (p::x) 

let _ = make ['j'; 'a'; 'v'; 'a'; '.' ; 'l'; 'a'; 'n'; 'g' ; '.' ;'O'; 'b'; 'j'; 'e'; 'c'; 't']

let rec equal p l1 l2 = match (l1, l2) with
| ([], []) -> true
| ([], _) -> false
| (_, []) -> false
| (h1::t1, h2::t2) -> if p h1 h2 then equal p t1 t2 else false

let _ = equal (fun x y -> x=y) [1;2;3] [1;2;3;4]
let _ = equal (fun x y -> x=y) [1;2;3] [1;2;3]
let _ = equal (fun x y -> x=y) [1;3;2] [1;2;3]

let rec prefix q1 q2 = match (q1, q2) with
| ([], []) -> []
| (_, []) -> []
| ([], _) -> []
| (h1::t1, h2::t2) -> if equal (fun x y -> x=y) h1 h2 then h1::(prefix t1 t2) else []

let q1 = [['j'; 'a'; 'v'; 'a'] ; ['l'; 'a'; 'n'; 'g' ] ; ['O'; 'b'; 'j'; 'e'; 'c'; 't']]
let q2 = [['j'; 'a'; 'v'; 'a'] ; ['l'; 'a'; 'n'; 'g' ] ; ['S'; 't'; 'r'; 'i'; 'n'; 'g']]
let q3 = [['j'; 'a'; 'v'; 'a'] ; ['n'; 'e'; 't' ] ; ['S'; 'o'; 'c'; 'k'; 'e'; 't']]
let q4 = [['x'; 'x'; 'x'] ; ['y'; 'y' ] ; ['t'; 'u'; 'z'] ; ['v']]

let _ = prefix q1 q2
let _ = prefix q2 q3
let _ = prefix q3 q4

let rec prefixl l = match l with
| [] -> []
| h::[] -> h
| h1::h2::t -> prefixl ((prefix h1 h2)::t)

let _ = prefixl [q1; q2]
let _ = prefixl [q1; q2; q3]
let _ = prefixl [q1; q2; q3; q4]

type expr = 
| Constant of int
| Variable of qname
| Add of expr * expr

type program = 
| Skip
| Assign of qname * expr
| If of expr * program * program
| Seq of program * program

let qx = [['x']]
let qy = [['y']]
let x_plus_2 = Add(Variable qx, Constant 2)
let y_plus_3 = Add(Variable qy, Constant 3)
let prog1 = If(Variable qx, Skip, Seq(Assign(qx, x_plus_2), Assign(qx, y_plus_3)))

let rec vars prog = match prog with
| Skip -> []
| Assign (x, y) -> x::(vars_exp y)
| If (exp, p1, p2) -> (vars_exp exp)@(vars p1)@(vars p2)
| Seq (p1, p2) -> (vars p1)@(vars p2)
and
vars_exp exp = match exp with
| Constant _ -> []
| Variable x -> [x]
| Add (x, y) -> (vars_exp x)@(vars_exp y) 

let _ = vars prog1

let init q = List.fold_right (fun x acc -> Seq(Assign(x, Constant 0), acc)) q Skip

let _ = init [qx; qy]

type state = (qname * int) list

let rec get st q = match st with
| [] -> None
| (hx, hy)::t -> if hx=q then Some hy else get t q

let rec set st q i = match st with
| [] -> [(q, i)]
| (hx, hy)::t -> if hx=q then (hx, i)::t else (hx, hy)::(set t q i) 

let rec eexpr st exp = match exp with
| Constant x -> Some x
| Variable x -> get st x
| Add (x, y) ->
  begin match (eexpr st x, eexpr st y) with
  | (None, _) -> None
  | (_, None) -> None
  | (Some x2, Some y2) -> Some (x2 + y2)
  end

let _ = eexpr [qx, 3] (Add(Variable qx, Constant 2))
let _ = eexpr [qy, 3] (Add(Variable qx, Constant 2))

let rec eprog st p = match p with
| Skip -> Some st
| Assign (x, exp) -> begin match eexpr st exp with
  | None -> None
  | Some y -> Some (set st x y)
  end
| If (exp, p1, p2) -> begin match eexpr st exp with
  | None -> None
  | Some x -> if x=0 then eprog st p2 else eprog st p1
end
| Seq(p1, p2) -> begin match eprog st p1 with
  | None -> None
  | Some newSt -> eprog newSt p2
end

let _ = eprog [(qx, 4);(qy, 3)] prog1
let _ = eprog [(qx, 0);(qy, 3)] prog1
let _ = eprog [(qx, 0)] (Assign(qx, Variable qy))

let rec opt_expr exp = match exp with
| Add (x, y) -> begin match (opt_expr x, opt_expr y) with
                | (Constant 0, y) -> y
                | (x, Constant 0) -> x
                | (newX, newY) -> Add (newX, newY)  
                end
| _ -> exp

let rec opt p = match p with
| Skip -> Skip
| Assign(qname, exp) -> begin match opt_expr exp with
    | Variable x -> if x=qname then Skip else Assign(qname, exp)
    | _ -> Assign(qname, opt_expr exp)
  end
| If(exp, p1, p2) -> begin match opt_expr exp with
| Constant x -> if x = 0 then opt p2 else opt p1
| _ -> If(exp, p1, p2)
end
| Seq(p1, p2) -> begin match (opt p1, opt p2) with
  | (Skip, y) -> y
  | (x, Skip) -> x
  | (x, y) -> Seq(x, y)
end

let _ = opt (If(Add(Constant 0, Constant 0), Assign(qx, Constant 1), Seq(Seq(Skip, Assign(qx, Add(Variable qx, Constant 0))), Skip)))

type instr = Set of qname * expr | Goto of int | JumpZero of expr * int
and assembly = instr list

let rec nth n l = match l with
| [] -> None
| h::t -> if n=1 then Some h else nth (n-1) t

let _ = nth (1) [1; 2; 3; 4]

let exec asm (pc, st) = match (nth pc asm) with 
| None -> None
| Some (Set(x, e)) -> begin match eexpr st e with
            | None -> None
            | Some y -> Some ((pc+1, set st x y))
            end
| Some (Goto i) -> Some (pc+i, st)
| Some (JumpZero (exp, i)) -> begin match eexpr st exp with
            | None -> None
            | Some y -> if y=0 then Some (pc+i, st) else Some (pc+1, st)
            end

let _ = exec [Set(qx, Constant 0); Set (qx, Constant 1)] (2, [(qx, 0)])
let _ = exec [JumpZero(Variable qx, 2)] (1, [(qx, 0)])

let rec compile p = match p with
| Skip -> ([], 0)
| Assign (x, exp) -> ([Set(x, exp)], 1)
| If (exp, p1, p2) -> let ((c1, t1), (c2, t2))=(compile p1, compile p2) in
  (JumpZero(exp, t1+2)::(c1@[Goto (t2+1)]@c2), t1+t2+2)
| Seq (p1, p2) -> let ((c1, t1), (c2, t2)) = (compile p1, compile p2) in
  (c1@c2, t1+t2)

let _ = compile prog1

