(** TP9 - Propositional Logic and Parsing
    Formula parsing, evaluation, tautology checking, CNF conversion

    Note: This is a condensed version focusing on core logic functions.
    The original includes the full Opal parser combinator library (100+ lines)
    and Knights and Knaves puzzle solutions. *)

(** Formula type representing propositional logic expressions *)
type formula =
  | True
  | False
  | P of string                       (* Propositional variable *)
  | Not of formula
  | And of formula * formula
  | Or of formula * formula
  | Imp of formula * formula          (* Implication *)
  | Iff of formula * formula          (* Bi-implication *)

(** Valuation maps variable names to boolean values *)
type valuation = (string * bool) list

(** [get_value p v] looks up the value of variable [p] in valuation [v]. *)
let get_value (p : string) (v : valuation) : bool =
  List.assoc p v

(** [eval fm v] evaluates formula [fm] under valuation [v]. *)
let rec eval (fm : formula) (v : valuation) : bool =
  match fm with
  | True -> true
  | False -> false
  | P s -> get_value s v
  | Not f -> not (eval f v)
  | And (f, g) -> (eval f v) && (eval g v)
  | Or (f, g) -> (eval f v) || (eval g v)
  | Imp (f, g) -> not (eval f v) || (eval g v)
  | Iff (f, g) -> (eval f v) = (eval g v)

(** [atoms fm] extracts all propositional variables from formula [fm]. *)
let atoms (fm : formula) : string list =
  let rec atoms_internal (fm : formula) (curlist : string list) : string list =
    match fm with
    | True | False -> curlist
    | P x -> if List.mem x curlist then curlist else x :: curlist
    | Not f -> atoms_internal f curlist
    | Or (f, g) | And (f, g) | Imp (f, g) | Iff (f, g) ->
        atoms_internal g (atoms_internal f curlist)
  in
  atoms_internal fm []

(** [tautology fm] checks if formula [fm] is a tautology (always true).
    Uses exhaustive truth table generation. *)
let tautology (fm : formula) : bool =
  let rec tautology_atomic_descent
      (decided : valuation)
      (atoms_to_be_decided : string list) : bool =
    match atoms_to_be_decided with
    | [] -> eval fm decided
    | head :: body ->
        tautology_atomic_descent ((head, true) :: decided) body &&
        tautology_atomic_descent ((head, false) :: decided) body
  in
  tautology_atomic_descent [] (atoms fm)

(** [find_truth f fm] applies function [f] to each valuation that makes [fm] true. *)
let find_truth (f : valuation -> unit) (fm : formula) : unit =
  let rec truth_in_depth (v : valuation) (undecided : string list) : unit =
    match undecided with
    | [] -> if eval fm v then f v else ()
    | head :: body ->
        truth_in_depth ((head, true) :: v) body;
        truth_in_depth ((head, false) :: v) body
  in
  truth_in_depth [] (atoms fm)

(** [nnf fm] converts formula [fm] to Negation Normal Form.
    Pushes negations inward using De Morgan's laws. *)
let rec nnf : formula -> formula = fun fm ->
  match fm with
  | True -> True
  | False -> False
  | P x -> P x
  | Imp (x, y) -> nnf (Or (Not x, y))
  | Iff (x, y) -> nnf (Or (And (x, y), And (Not x, Not y)))
  (* Double negation *)
  | Not (Not x) -> nnf x
  (* De Morgan's laws *)
  | Not (And (x, y)) -> nnf (Or (Not x, Not y))
  | Not (Or (x, y)) -> nnf (And (Not x, Not y))
  (* Modified De Morgan for implications *)
  | Not (Imp (x, y)) -> nnf (And (x, Not y))
  | Not (Iff (x, y)) -> nnf (Or (And (x, Not y), And (Not x, y)))
  (* Recursively process subformulas *)
  | And (x, y) -> And (nnf x, nnf y)
  | Or (x, y) -> Or (nnf x, nnf y)
  | Not x -> Not (nnf x)

(** Example: Knights and Knaves puzzle
    "A1 asserts that A1 and A2 are both knaves."

    Model:
    - c1: A1 is a knight (truth teller)
    - c2: A2 is a knight

    Formula: c1 <=> (~c1 . ~c2)

    Solution: c1=false (A1 is a knave), c2=true (A2 is a knight)
*)

(** Example: "If I am a knight there is gold on the island"

    Model:
    - k: "I" is a knight
    - g: there is gold on the island

    Formula: k <=> (k => g)

    Solution: k=true, g=true (knight with gold)
*)

(** Example: Tautologies

    p => q => p            is a tautology
    ~(p . q) <=> ~p + ~q   is a tautology (De Morgan)
    ~~p <=> p              is a tautology (double negation)
    p . ~p <=> false       is a tautology (contradiction)
*)

(** Note: For full parser implementation and Knights and Knaves solutions,
    see the original tp9.ml file which includes:
    - Opal parser combinator library
    - Formula parsing from strings
    - Pretty printing with Unicode symbols
    - CNF simplification
    - Complete puzzle solutions with explanations
*)
