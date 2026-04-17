open ListLabels

type literal = int
type clause  = literal list

let negate = (~-)
let ( ** ) f g = fun x -> f (g x)

exception Unsat

let setify l = sort_uniq Pervasives.compare l

let unit_propagation clauses =
  let rec unit_propagation literals clauses =
    let unit_clauses, clauses =
      partition (fun c -> length c = 1) clauses
    in
    if unit_clauses = [] then literals, clauses
    else
      let units = concat unit_clauses in
      let neg_units = map negate units in
      let clauses  =
        filter (for_all ~f:(not ** mem ~set:units)) clauses
        |> map ~f:(filter ~f:(not ** mem ~set:neg_units))
      in
      if exists (fun c -> c = []) clauses then raise Unsat
      else
        let literals = units @ literals in
        unit_propagation literals clauses
  in
  unit_propagation [] clauses


let dpll clauses =
  let all_literals = List.concat clauses |> setify in
  let rec dpll assignment clauses =
    let literals, clauses = unit_propagation clauses in
    let assignment = literals @ assignment in
    if map negate literals |> exists ~f:(mem ~set:assignment) then raise Unsat;
    if clauses = [] then setify assignment
    else begin
        let lit =
          List.find_opt (fun lit -> not (mem lit assignment)
                                    && not (mem (negate lit) assignment))
            all_literals
        in
        match lit with
        | None -> assignment
        | Some lit ->
           try
             dpll (lit :: assignment) ([lit] :: clauses)
           with Unsat ->
             dpll (negate lit :: assignment) ([negate lit] :: clauses)
      end
  in
  dpll [] clauses

(* For more info look at the paper by T.Weber "A SAT-based Sudoku solver" at LPAR'05 *)
let sudoku_encode m =
  let sqrt n =
    let rec sqrt i =
      if i*i = n then
        i
      else if i*i > n then
        failwith "Not a square"
      else
        sqrt (i+1) in
    sqrt 0 in

  let n = Array.length m in
  let n' = sqrt n in
  let var i j k = n*n*i+n*j+k+1 in
  let res = ref [] in

  (* Each cell has at least one digit *)
  for i = 0 to n-1 do
    for j = 0 to n-1 do
      let l = ref [] in
      for k = 0 to n-1 do
        l := (var i j k)::!l
      done;
      res := !l::!res
    done
  done;

  (* Each cell has at most one digit *)
  for i = 0 to n-1 do
    for j = 0 to n-1 do
      for k = 0 to n-2 do
        for k' = k+1 to n-1 do
          res := [-(var i j k);-(var i j k')]::!res
        done
      done
    done
  done;

  (* Condition on the lines *)
  for i = 0 to n-1 do
    for k = 0 to n-1 do
      for j = 0 to n-2 do
        for j' = j+1 to n-1 do
          res := [-(var i j k);-(var i j' k)]::!res
        done
      done
    done
  done;

  (* Condition on the columns *)
  for j = 0 to n-1 do
    for k = 0 to n-1 do
      for i = 0 to n-2 do
        for i' = i+1 to n-1 do
          res := [-(var i j k);-(var i' j k)]::!res
        done
      done
    done
  done;

  (* Condition on the squares *)
  for ii = 0 to n'-1 do
    for jj = 0 to n'-1 do
      for i = n'*ii to n'*(ii+1)-1 do
        for i' = n'*ii to n'*(ii+1)-1 do
          for j = n'*jj to n'*(jj+1)-1 do
            for j' = n'*jj to n'*(jj+1)-1 do
              if var i j 0 < var i' j' 0 then
                for k = 0 to n-1 do
                  res := [-(var i j k);-(var i' j' k)]::!res
                done
            done
          done
        done
      done
    done
  done;

  (* Conditions given by the initial state *)
  for i = 0 to n-1 do
    for j = 0 to n-1 do
      if m.(i).(j) <> 0 then
        res := [var i j (m.(i).(j) - 1)]::!res
    done
  done;

  !res


let sudoku_decode v n =
  let sol = List.filter (fun x -> x > 0) v in
  let res = Array.make_matrix n n 0 in

  let unvar x =
    let x' = x-1 in
    let k = x' mod n in
    let x' = x' / n in
    let j = x' mod n in
    let i = x' / n in
    (i,j,k) in

  List.iter (fun x -> let (i,j,k) = unvar x in res.(i).(j) <- k+1) sol;
  res


let sudoku_print res =
  Array.iteri (fun i t ->
    if i mod 3 = 0 then Printf.printf "+-------+-------+-------+\n";
    Array.iteri (fun j k ->
      if j mod 3 = 0 then Printf.printf "| ";
      Printf.printf "%d " k;
    ) t;
    Printf.printf "|\n";
  ) res;
  Printf.printf "+-------+-------+-------+\n"



(* A simple sudoku:
   +-------+-------+-------+
   | . . 8 | . 9 3 | 5 . . |
   | 6 5 . | 4 . 2 | . . . |
   | . 2 1 | . 8 . | 3 . . |
   +-------+-------+-------+
   | 3 8 . | . 6 . | 2 . 9 |
   | . 7 . | . . . | . 1 . |
   | 1 . 9 | . 4 . | . 7 3 |
   +-------+-------+-------+
   | . . 5 | . 1 . | 7 3 . |
   | . . . | 3 . 9 | . 2 6 |
   | . . 6 | 8 2 . | 1 . . |
   +-------+-------+-------+ *)

let simple_sudoku =
  [|[|0;0;8;0;9;3;5;0;0|];
    [|6;5;0;4;0;2;0;0;0|];
    [|0;2;1;0;8;0;3;0;0|];
    [|3;8;0;0;6;0;2;0;9|];
    [|0;7;0;0;0;0;0;1;0|];
    [|1;0;9;0;4;0;0;7;3|];
    [|0;0;5;0;1;0;7;3;0|];
    [|0;0;0;3;0;9;0;2;6|];
    [|0;0;6;8;2;0;1;0;0|]|]


(* A medium sudoku:
   +-------+-------+-------+
   | . 2 . | 8 5 4 | . . . |
   | . . . | 6 . . | . . 8 |
   | . 1 . | . . . | . . 9 |
   +-------+-------+-------+
   | 2 . . | . . . | . 9 3 |
   | . 7 5 | 3 . 8 | 6 2 . |
   | 8 9 . | . . . | . . 7 |
   +-------+-------+-------+
   | 4 . . | . . . | . 6 . |
   | 3 . . | . . 2 | . . . |
   | . . . | 7 6 1 | . 4 . |
   +-------+-------+-------+ *)

let medium_sudoku =
  [|[|0;2;0;8;5;4;0;0;0|];
    [|0;0;0;6;0;0;0;0;8|];
    [|0;1;0;0;0;0;0;0;9|];
    [|2;0;0;0;0;0;0;9;3|];
    [|0;7;5;3;0;8;6;2;0|];
    [|8;9;0;0;0;0;0;0;7|];
    [|4;0;0;0;0;0;0;6;0|];
    [|3;0;0;0;0;2;0;0;0|];
    [|0;0;0;7;6;1;0;4;0|]|]


(* A hard sudoku:
   +-------+-------+-------+
   | . . . | . 5 . | 9 . . |
   | 9 8 . | . . . | . 5 . |
   | . 4 5 | 7 . . | 3 . . |
   +-------+-------+-------+
   | . . 4 | 2 . . | 8 7 . |
   | . . . | 1 . 4 | . . . |
   | . 7 6 | . . 9 | 1 . . |
   +-------+-------+-------+
   | . . 8 | . . 1 | 6 3 . |
   | . 2 . | . . . | . 8 1 |
   | . . 7 | . 3 . | . . . |
   +-------+-------+-------+ *)

let hard_sudoku =
  [|[|0;0;0;0;5;0;9;0;0|];
    [|9;8;0;0;0;0;0;5;0|];
    [|0;4;5;7;0;0;3;0;0|];
    [|0;0;4;2;0;0;8;7;0|];
    [|0;0;0;1;0;4;0;0;0|];
    [|0;7;6;0;0;9;1;0;0|];
    [|0;0;8;0;0;1;6;3;0|];
    [|0;2;0;0;0;0;0;8;1|];
    [|0;0;7;0;3;0;0;0;0|]|]


let sudoku m =
  let n = Array.length m in
  try
    let solution = dpll (sudoku_encode m) in
    sudoku_print (sudoku_decode solution n)
  with
    | Unsat -> failwith "No solution!"


let _ = sudoku simple_sudoku

let _ = sudoku medium_sudoku

let _ = sudoku hard_sudoku

let addition32 a b =
  let rec list_of_int acc n v =
    if n = 0 then acc
    else if v = 0 then list_of_int (0 :: acc) (n - 1) v
    else list_of_int (v mod 2 :: acc) (n - 1) (v / 2)
  in
  let int_of_list l =
    let rec int_of_list n = function
      | [] -> n
      | b :: r -> int_of_list (n * 2 + b) r
    in
    int_of_list 0 l
  in
  let a_bits = ref 1 in
  let b_bits = ref 33 in
  let carry = ref 65 in
  let add_bits = ref 97 in
  let res = ref [[- !carry]] in
  let add clause = res := clause :: !res in
  let rec encode l1 l2 =
    match l1, l2 with
    | [], [] -> ()
    | ai :: l1, bi :: l2 ->
       add [if ai = 1 then !a_bits else - !a_bits];
       add [if bi = 1 then !b_bits else - !b_bits];
       add [!a_bits; !b_bits; !carry; - !add_bits];
       add [!a_bits; !b_bits; - !carry; !add_bits];
       add [!a_bits; - !b_bits; !carry; !add_bits];
       add [!a_bits; - !b_bits; - !carry; - !add_bits];
       add [- !a_bits; !b_bits; !carry; !add_bits];
       add [- !a_bits; !b_bits; - !carry; - !add_bits];
       add [- !a_bits; - !b_bits; !carry; - !add_bits];
       add [- !a_bits; - !b_bits; - !carry; !add_bits];
       let c = !carry in
       incr carry;
       add [!a_bits; !b_bits; - !carry];
       add [!a_bits; c; - !carry];
       add [!b_bits; c; - !carry];
       add [- !a_bits; - !b_bits; !carry];
       add [- !a_bits; -c; !carry];
       add [- !b_bits; -c; !carry];
       incr a_bits; incr b_bits; incr add_bits;
       encode l1 l2
    | _ -> assert false
  in
  encode (list_of_int [] 32 a |> rev) (list_of_int [] 32 b |> rev);
  dpll !res
  |> filter ~f:(((<) 96) ** abs)
  |> sort ~cmp:(fun x y -> -(compare (abs x) (abs y)))
  |> map ~f:(fun x -> if x > 0 then 1 else 0)
  |> int_of_list

let _ = Printf.printf "%d + %d = %d\n" 28 14 (addition32 28 14)

let pigeon_hole m n =
  let var i j = i*m+j+1 in
  let res = ref [] in
  (* Every pigeon is in a hole *)
  for i = 0 to n-1 do
    let l = ref [] in
    for j = m-1 downto 0 do
      l := (var i j)::!l
    done;
    res := !l::!res
  done;

  (* A hole cannot contain more than 1 pigeon *)
  for j = 0 to m-1 do
    for i = 0 to n-2 do
      for i' = i+1 to n-1 do
        res := [-(var i j); -(var i' j)]::!res
      done
    done
  done;
  !res

(* Satisfiable *)
let _ = dpll (pigeon_hole 1 1)
let _ = dpll (pigeon_hole 2 2)
let _ = dpll (pigeon_hole 3 3)
let _ = dpll (pigeon_hole 4 4)
let _ = dpll (pigeon_hole 5 5)
let _ = dpll (pigeon_hole 6 5)

(* Unsatisfiable *)
(* let _ = dpll (pigeon_hole 1 2) *)
(* let _ = dpll (pigeon_hole 2 3) *)
(* let _ = dpll (pigeon_hole 3 4) *)
(* let _ = dpll (pigeon_hole 4 5) *)
(* let _ = dpll (pigeon_hole 5 6) *)
let _ = dpll (pigeon_hole 6 7)
