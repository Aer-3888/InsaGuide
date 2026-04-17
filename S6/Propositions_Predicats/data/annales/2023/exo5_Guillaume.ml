type formula =
| Atom of string
| Not of formula
| Imp of formula * formula;;

let is_axiom = function 
| Imp(a1, Imp(b1, a2)) -> if a1=a2 then true else
  begin match a1 with
  | Imp(Not(a3), Not(b2)) -> if b1=b2 && a3=a2 then true else
    begin match a1, b1, a2 with
    | Imp(a4, Imp(b3, c1)), Imp(a5, b4), Imp(a6, c2) -> (c1=c2 && a4=a5 && a5=a6 && b3=b4)
    | _ -> false
    end
  | _ -> 
    begin match a1, b1, a2 with
    | Imp(a4, Imp(b3, c1)), Imp(a5, b4), Imp(a6, c2) -> (c1=c2 && a4=a5 && a5=a6 && b3=b4)
    | _ -> false
    end
  end
| _ -> false;;

let _ = is_axiom (Imp(Atom "a", Imp(Atom "b", Atom "a")));; (* doit rendre true *)
let _ = is_axiom (Imp(Imp(Not(Atom "a"), Not(Atom "b")), Imp(Atom "b", Atom "a")));; (* doit rendre true *)
let _ = is_axiom (Imp(Imp(Atom "a", Imp(Atom "b", Atom "c")), Imp(Imp(Atom "a", Atom "b"), Imp(Atom "a", Atom "c")))) (* doit rendre true *)
let _ = is_axiom (Imp(Atom "a", Atom "b"));; (* doit rendre false *)

let modus_ponens p prev = List.exists (fun x -> 
  List.exists (fun y ->
    match y with
    | Imp(x2, b) -> b=p && x=x2
    | _ -> false
  ) prev
) prev;;

let _ = modus_ponens (Atom "p") [Atom "a"; Imp(Atom "a", Atom "p"); Atom "r"];; (* true *)
let _ = modus_ponens (Atom "p") [Imp(Atom "a", Atom "p"); Atom "r"];; (* false *)

let check demo =
  let rec tmp_func todo valid = match todo with
  | [] -> true
  | h::t -> (is_axiom h || modus_ponens h valid) && (tmp_func t (h::valid))
in tmp_func demo [];;

let p = Atom "p";;
let q = Atom "q";;

let _ = check [
  Imp(p, Imp(Imp(p, p), p));
  Imp(Imp(p, Imp(Imp(p, p), p)), Imp(Imp(p, Imp(p, p)), Imp(p, p)));
  Imp(Imp(p, Imp(p, p)), Imp(p, p));
  Imp(p, Imp(p, p));
  Imp(p, p)
] (* true *)

let _ = check [
  p;
  Imp(p, q);
  q
];; (* false *)