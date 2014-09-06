﻿(*
   Copyright 2008-2014 Nikhil Swamy and Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)
#light "off"
module Microsoft.FStar.Tc.Rel

open Microsoft.FStar
open Microsoft.FStar.Tc
open Microsoft.FStar.Absyn
open Microsoft.FStar.Absyn.Syntax
open Microsoft.FStar.Absyn.Util
open Microsoft.FStar.Util
open Microsoft.FStar.Tc.Env
open Microsoft.FStar.Tc.Normalize

let whnf env t = Tc.Normalize.whnf env t |> Util.compress_typ
let sn env t = Tc.Normalize.norm_typ [Beta;Eta] env t |> Util.compress_typ
let whnf_k env k = Tc.Normalize.norm_kind [Beta;Eta;WHNF] env k |> Util.compress_kind

(**********************************************************************************************************************)
(* Relations (equality and subsumption) between kinds, types, expressions and computations *)
(**********************************************************************************************************************)
type guard = 
  | Trivial
  | NonTrivial of formula

let rec is_trivial f : bool = 
    let bin_op f l = match l with 
        | [Inl t1, _; Inl t2, _] -> f t1 t2
        | _ -> failwith "Impossible" in
    let connectives = [(Const.and_lid, bin_op (fun t1 t2 -> is_trivial t1 && is_trivial t2));
                       (Const.or_lid,  bin_op (fun t1 t2 -> is_trivial t1 || is_trivial t2));
                       (Const.imp_lid, bin_op (fun t1 t2 -> is_trivial t2));
                       (Const.true_lid, (fun _ -> true));
                       (Const.false_lid, (fun _ -> false));
                       ] in

    let fallback phi = match phi.n with 
        | Typ_lam(_, phi) -> is_trivial phi
        | _ -> false in

    match Util.destruct_typ_as_formula f with 
        | None -> fallback f
        | Some (BaseConn(op, arms)) -> 
           (match connectives |> List.tryFind (fun (l, _) -> lid_equals op l) with 
             | None -> false
             | Some (_, f) -> f arms)
        | Some (QAll(_, _, body)) 
        | Some (QEx(_, _, body)) -> is_trivial body
  
let simplify_guard env g =
  match g with 
    | Trivial -> g
    | NonTrivial f -> 
      let f = Tc.Normalize.normalize env f in //NS: EXPENSIVE!
      if is_trivial f 
      then Trivial
      else NonTrivial f

let guard_to_string (env:env) = function  
  | Trivial -> "trivial"
  | NonTrivial f -> Print.formula_to_string (Tc.Normalize.normalize env f)

let trivial t = match t with 
  | Trivial -> ()
  | NonTrivial _ -> failwith "impossible"

let conj_guard g1 g2 = match g1, g2 with 
  | Trivial, g
  | g, Trivial -> g
  | NonTrivial f1, NonTrivial f2 -> NonTrivial (Util.mk_conj f1 f2)

let close bs f = List.fold_right (fun b f -> match b with 
    | Inl a, _ -> Util.mk_forallT a f
    | Inr x, _ -> Util.mk_forall x f) bs f
  
let close_guard b = function
  | Trivial -> Trivial
  | NonTrivial f -> NonTrivial <| close b f

//////////////////////////////////////////////////////////////////////////
//Making substitutions for alpha-renaming 
//////////////////////////////////////////////////////////////////////////
let subst_binder b1 b2 s = 
    if is_null_binder b1 || is_null_binder b2 then s
    else match fst b1, fst b2 with 
        | Inl a, Inl b -> 
          if Util.bvar_eq a b 
          then s
          else Inl(b.v, btvar_to_typ a)::s
        | Inr x, Inr y -> 
          if Util.bvar_eq x y 
          then s
          else Inr(y.v, bvar_to_exp x)::s 
        | _ -> failwith "Impossible"


//////////////////////////////////////////////////////////////////////////
//Generating new unification variables/patterns
//////////////////////////////////////////////////////////////////////////
let new_kvar r binders =
  let wf k () = true in
  let u = Unionfind.fresh (Uvar wf) in
  mk_Kind_uvar (u, Util.args_of_non_null_binders binders) r, u

let new_tvar r binders k =
  let wf t tk = true in
  let binders = binders |> List.filter (fun x -> is_null_binder x |> not) in
  match binders with 
    | [] -> 
      let uv = Unionfind.fresh (Uvar wf) in 
      let uv = mk_Typ_uvar'(uv,k) k r in
      uv, uv
    | _ -> 
      let args = Util.args_of_non_null_binders binders in 
      let uv = Unionfind.fresh (Uvar wf) in 
      let k' = mk_Kind_arrow(binders, k) r in
      let uv = mk_Typ_uvar'(uv,k') k' r in
      mk_Typ_app(uv, args) k r, uv

let new_evar r binders t =
  let wf e t = true in 
  let binders = binders |> List.filter (fun x -> is_null_binder x |> not) in
  match binders with 
    | [] -> 
      let uv = Unionfind.fresh (Uvar wf) in 
      let uv = mk_Exp_uvar'(uv,t) t r in
      uv, uv
    | _ ->
      let args = Util.args_of_non_null_binders binders in 
      let uv = Unionfind.fresh (Uvar wf) in 
      let t' = mk_Typ_fun(binders, mk_Total t) ktype r in
      let uv = mk_Exp_uvar'(uv, t') t' r in
      match args with 
        | [] -> uv, uv
        | _ -> mk_Exp_app(uv, args) t r, uv

let new_cvar r binders t = 
  let u, uv = new_tvar r (binders@[null_t_binder ktype]) keffect in
  mk_Flex (u,t), uv

//////////////////////////////////////////////////////////////////////////
//Refinement subtyping with higher-order unification 
//with special treatment for higher-order patterns 
//////////////////////////////////////////////////////////////////////////
type rel = 
  | EQ 
  | SUB
let rel_to_string = function
  | EQ -> "="
  | SUB -> "<:"

type prob = 
  | KProb of rel * knd * knd 
  | TProb of rel * typ * typ
  | EProb of rel * exp * exp 
  | CProb of rel * comp * comp 
let prob_to_string env = function 
  | KProb(rel, k1, k2) -> Util.format3 "\t%s\n\t\t%s\n\t%s" (Print.kind_to_string k1) (rel_to_string rel) (Print.kind_to_string k2)
  | TProb(rel, k1, k2) -> Util.format5 "\t%s (%s) \n\t\t%s\n\t%s (%s)" (Print.typ_to_string k1) (Print.tag_of_typ k1) (rel_to_string rel) (Print.typ_to_string k2) (Print.tag_of_typ k2)
  | EProb(rel, k1, k2) -> Util.format3 "\t%s \n\t\t%s\n\t%s" (Print.exp_to_string k1) (rel_to_string rel) (Print.exp_to_string k2)
  | CProb(rel, k1, k2) -> 
    let k1 = Normalize.norm_comp [Beta;SNComp;Delta] env k1 in
    let k2 = Normalize.norm_comp [Beta;SNComp;Delta] env k2 in   
    Util.format3 "\t%s \n\t\t%s\n\t%s" (Print.comp_typ_to_string k1) (rel_to_string rel) (Print.comp_typ_to_string k2)

type uvar_inst =  //never a uvar in the co-domain of this map
  | UK of uvar_k * knd 
  | UT of (uvar_t * knd) * typ 
  | UE of (uvar_e * typ) * exp
  | UC of (uvar_t * knd) * typ
let str_uvi = function 
  | UK (u, _) -> Unionfind.uvar_id u |> string_of_int |> Util.format1 "UK %s"
  | UT ((u,_), t) -> Unionfind.uvar_id u |> string_of_int |> (fun x -> Util.format2 "UT %s %s" x (Print.typ_to_string t))
  | UE ((u,_), _) -> Unionfind.uvar_id u |> string_of_int |> Util.format1 "UE %s"
  | UC ((u,_), _) -> Unionfind.uvar_id u |> string_of_int |> Util.format1 "UC %s"

let print_uvi uvi = Util.fprint1 "%s\n" (str_uvi uvi) 
    
type reason = string
type worklist = {
    attempting: list<prob>;
    deferred: list<(int * prob * reason)>;
    subst: list<uvar_inst>;
    top_t: option<typ>;      //the guard is either trivial; or a type of kind top_t => Type, where None => Type = Type and (Some t) => Type = t => Type
    guard: guard;
    ctr: int;
}
type solution = 
    | Success of list<uvar_inst> * guard
    | Failed of list<(int * prob * reason)>
let empty_worklist = {
    attempting=[];
    deferred=[];
    subst=[];
    top_t=None;
    guard=Trivial;
    ctr=0;
}
let singleton prob tk = {empty_worklist with attempting=[prob]; top_t=tk}

let reattempt (_, p, _) = p
let giveup reason prob probs = Failed <| (probs.ctr, prob, reason)::probs.deferred
let giveup_noex probs = Failed probs.deferred
let extend_subst ui wl = 
    //Util.print_string "Extending subst ... "; print_uvi ui;
   {wl with subst=ui::wl.subst; ctr=wl.ctr + 1}
let defer reason prob wl = {wl with deferred=(wl.ctr, prob, reason)::wl.deferred}
let attempt probs wl = {wl with attempting=probs@wl.attempting}

let guard env top g probs = 
    let close_predicate f = match (Util.compress_kind f.tk).n with 
        | Kind_arrow(bs, {n=Kind_type}) -> close bs f
        | Kind_type -> f
        | _ ->  failwith "Unexpected kind" in
    let mk_pred top_t f = match top_t with 
        | None -> f
        | Some t -> 
            let b = [null_v_binder t] in
            mk_Typ_lam(b, f) (mk_Kind_arrow(b, ktype) f.pos) f.pos in

    let g = simplify_guard env g in
    match g with 
    | Trivial -> probs
    | NonTrivial f -> 
        let g = if not top 
                then let qf = close_predicate f in 
                     match probs.top_t, probs.guard with 
                       | _, Trivial -> 
                         NonTrivial (mk_pred probs.top_t qf)
                       | Some _, NonTrivial {n=Typ_lam(bs, body); tk=tk; pos=p} -> 
                         NonTrivial (mk_Typ_lam(bs, Util.mk_conj body qf) tk p)
                       | None, NonTrivial g -> 
                         NonTrivial <| Util.mk_conj g f
                       | _ -> failwith "Impossible"
                else match probs.top_t, probs.guard with 
                       | _, Trivial -> NonTrivial f
                       | None, NonTrivial g -> 
                         NonTrivial <| Util.mk_conj g f
                       | Some _, NonTrivial ({n=Typ_lam(xs, g)}) -> 
                            begin match f.n with 
                            | Typ_lam(ys, fbody) ->
                              let xs, args = Util.args_of_binders xs in
                              NonTrivial <| mk_Typ_lam(xs, Util.mk_conj g (Util.subst_typ (Util.subst_of_list ys args) fbody)) g.tk g.pos
                            | _ -> 
                              NonTrivial <| mk_Typ_lam(xs, Util.mk_conj g f) g.tk g.pos
                            end
                      | Some _, _ -> failwith "Impossible" in
        {probs with guard=g}

let commit env uvi = 
  let rec pre_kind_compat k1 k2 = 
   let k1, k2 = (compress_kind k1), (compress_kind k2) in
   match k1.n,k2.n with 
    | _, Kind_uvar uv 
    | Kind_uvar uv, _ -> true
    | Kind_type, Kind_type -> true
    | Kind_abbrev(_, k1), _ -> pre_kind_compat k1 k2
    | _, Kind_abbrev(_, k2) -> pre_kind_compat k1 k2
    | Kind_arrow(bs, k), Kind_arrow(bs', k') -> List.length bs = List.length bs' && pre_kind_compat k k'
    | _ -> Util.print_string (Util.format4 "(%s -- %s) Pre-kind-compat failed on %s and %s\n" (Range.string_of_range k1.pos) (Range.string_of_range k2.pos) (Print.kind_to_string k1) (Print.kind_to_string k2)); 
      false in

    uvi |> List.iter (fun uv -> 
        if debug env then print_uvi uv;
        match uv with 
        | UK(u,k) -> Unionfind.change u (Fixed k)
        | UT((u,k),t) -> ignore <| pre_kind_compat k t.tk; Unionfind.change u (Fixed t)
        | UE((u,_),e) -> Unionfind.change u (Fixed e)
        | UC((u,_),c) -> Unionfind.change u (Fixed c))
let find_uvar_k uv s = Util.find_map s (function UK(u, t) -> if Unionfind.equivalent uv u then Some t else None | _ -> None)
let find_uvar_t uv s = Util.find_map s (function UT((u,_), t) -> if Unionfind.equivalent uv u then Some t else None | _ -> None)
let find_uvar_e uv s = Util.find_map s (function UE((u,_), t) -> if Unionfind.equivalent uv u then Some t else None | _ -> None)
let find_uvar_c uv s = Util.find_map s (function UC((u,_), t) -> if Unionfind.equivalent uv u then Some t else None | _ -> None)

let intersect_vars v1 v2 = 
    let fvs1 = freevars_of_binders v1 in
    let fvs2 = freevars_of_binders v2 in 
    binders_of_freevars ({ftvs=Util.set_intersect fvs1.ftvs fvs2.ftvs; fxvs=Util.set_intersect fvs1.fxvs fvs2.fxvs})

let rec compress_k env s k = 
    let k = Util.compress_kind k in 
    match k.n with 
        | Kind_uvar(uv, actuals) -> 
            (match find_uvar_k uv s with
                | None -> k
                | Some k' -> 
                    match k'.n with 
                        | Kind_lam(formals, body) -> 
                               let k = Util.subst_kind (Util.subst_of_list formals actuals) body in
                               compress_k env s k
                        | _ -> if List.length actuals = 0 
                               then compress_k env s k'
                               else failwith "Wrong arity for kind unifier")
        | _ -> k

let rec compress env s t =
    let t = Util.compress_typ t in
    match t.n with 
        | Typ_uvar (uv, _) ->
           (match find_uvar_t uv s with 
                | None -> t
                | Some t -> compress env s t)   
        | Typ_app({n=Typ_uvar(uv, k)}, args) -> 
            (match find_uvar_t uv s with 
                | Some t -> 
                  let t = compress env s t in 
                  whnf env (mk_Typ_app(t, args) t.tk t.pos)
                | _ -> t)
        | _ -> whnf env t

let rec compress_e env s e = 
    let e = Util.compress_exp e in
    match e.n with 
        | Exp_uvar (uv, t) -> 
           begin match find_uvar_e uv s with 
            | None -> e
            | Some e' -> compress_e env s e'
           end
        | Exp_app({n=Exp_uvar(uv, t)}, args) -> 
           begin match find_uvar_e uv s with 
            | None -> e
            | Some e' -> 
                let e' = compress_e env s e' in
                mk_Exp_app(e', args) e.tk e.pos //TODO: whnf for expressions?
           end
        | _ -> e

let rec comp_comp env s c = 
    let c = Util.compress_comp c in
    match c.n with
    | Rigid t -> 
        (match (whnf env t).n with
            | Typ_meta(Meta_comp c) -> comp_comp env s c
            | _ -> failwith "Impossible")

    | Flex({n=Typ_app({n=Typ_uvar(uv, _)}, args)}, ret) -> 
      begin match find_uvar_c uv s with 
        | None ->  c
        | Some t' -> 
          let t' = compress env s t' in 
          as_comp <| (whnf env <| mk_Typ_app(t', (args@[targ ret])) keffect ret.pos)
      end

    | _ -> c

type match_result = 
  | MisMatch
  | HeadMatch
  | FullMatch

let head_match = function 
    | MisMatch -> MisMatch
    | _ -> HeadMatch

let rec head_matches env t1 t2 : match_result = 
  match (Util.compress_typ t1 |> Util.unascribe_typ).n, (Util.compress_typ t2 |> Util.unascribe_typ).n with 
    | Typ_btvar x, Typ_btvar y -> if Util.bvar_eq x y then FullMatch else MisMatch
    | Typ_const f, Typ_const g -> if Util.fvar_eq f g then FullMatch else MisMatch
    | Typ_btvar _, Typ_const _
    | Typ_const _, Typ_btvar _ -> MisMatch

    | Typ_refine(x, _), Typ_refine(y, _) -> head_matches env x.sort y.sort |> head_match
   
    | Typ_refine(x, _), _  -> head_matches env x.sort t2 |> head_match
    | _, Typ_refine(x, _)  -> head_matches env t1 x.sort |> head_match

    | Typ_fun _, Typ_fun _  -> HeadMatch
    
    | Typ_app(head, _), Typ_app(head', _) -> head_matches env head head'
    | Typ_app(head, _), _ -> head_matches env head t2
    | _, Typ_app(head, _) -> head_matches env t1 head
     
    | Typ_uvar (uv, _),  Typ_uvar (uv', _) -> if Unionfind.equivalent uv uv' then FullMatch else MisMatch

    | Typ_lam _, Typ_lam _ -> HeadMatch

    | _ -> MisMatch

let head_matches_delta env t1 t2 : (match_result * option<(typ*typ)>) =
    let success d r t1 t2 = (r, if d then Some(t1, t2) else None) in
    let fail () = (MisMatch, None) in
    let rec aux d t1 t2 = 
        match head_matches env t1 t2 with 
            | MisMatch -> 
                if d then fail() //already took a delta step
                else let t1 = Tc.Normalize.norm_typ [DeltaHard; Beta] env t1 in
                     let t2 = Tc.Normalize.norm_typ [DeltaHard; Beta] env t2 in
                     aux true t1 t2 
            | r -> success d r t1 t2 in
    aux false t1 t2

let binders_eq v1 v2 = 
  List.length v1 = List.length v2 
  && List.forall2 (fun ax1 ax2 -> match fst ax1, fst ax2 with 
        | Inl a, Inl b -> Util.bvar_eq a b
        | Inr x, Inr y -> Util.bvar_eq x y
        | _ -> false) v1 v2

let rec pat_vars seen : args -> option<binders> = function 
    | [] -> Some (List.rev seen) 
    | (hd, imp)::rest -> 
        (match Util.unascribe_either hd with 
            | Inl {n=Typ_btvar a} -> 
                if seen |> Util.for_some (function 
                    | Inl b, _ -> bvd_eq a.v b.v
                    | _ -> false)
                then None //not a pattern
                else pat_vars ((Inl a, imp)::seen) rest
            | Inr {n=Exp_bvar x} ->
                if seen |> Util.for_some (function 
                    | Inr y, _ -> bvd_eq x.v y.v
                    | _ -> false)
                then None //not a pattern
                else pat_vars ((Inr x, imp)::seen) rest
            | te -> None) //not a pattern

let decompose_binder (bs:binders) ktec (rebuild_base:binders -> ktec -> 'a) : ((list<ktec> -> 'a) * list<(binders * ktec)>) = 
    let fail () = failwith "Bad reconstruction" in
    let rebuild ktecs = 
        let rec aux new_bs bs ktecs = match bs, ktecs with 
            | [], [ktec] -> rebuild_base (List.rev new_bs) ktec
            | (Inl a, imp)::rest, K k::rest' -> aux ((Inl ({a with sort=k}), imp)::new_bs) rest rest'
            | (Inr x, imp)::rest, T t::rest' -> aux ((Inr ({x with sort=t}), imp)::new_bs) rest rest'
            | _ -> fail () in
        aux [] bs ktecs in
          
    let rec mk_b_ktecs (binders, b_ktecs) = function 
        | [] -> List.rev ((binders, ktec)::b_ktecs)
        | hd::rest ->
            let b_ktec = match fst hd with 
                | Inl a -> (binders, K a.sort)
                | Inr x -> (binders, T x.sort) in
            let binders' = if is_null_binder hd then binders else binders@[hd] in
            mk_b_ktecs (binders', b_ktec::b_ktecs) rest in

    rebuild, mk_b_ktecs ([], []) bs
 
let rec decompose_kind env k : (list<ktec> -> knd) * list<(binders * ktec)> = 
    let fail () = failwith "Bad reconstruction" in
    let k0 = k in
    let k = Util.compress_kind k in 
    match k.n with
        | Kind_type 
        | Kind_effect -> 
            let rebuild = function 
                | [] -> k
                | _ -> fail () in 
            rebuild, []

        | Kind_arrow(bs, k) -> 
          decompose_binder bs (K k) (fun bs -> function 
            | K k -> mk_Kind_arrow(bs, k) k0.pos
            | _ -> fail ())

        | Kind_abbrev(_, k) -> 
          decompose_kind env k
        
        | _ -> failwith "Impossible"

let rec decompose_typ env t : (list<ktec> -> typ) * (typ -> bool) * list<(binders * ktec)> =
    let fail () = failwith "Bad reconstruction" in
    let t = Util.compress_typ t in
    match t.n with 
        | Typ_app(hd, args) ->
          let rebuild args' = 
            let args = List.map2 (fun x y -> match x, y with
                | (Inl _, imp), T t -> Inl t, imp
                | (Inr _, imp), E e -> Inr e, imp
                | _ -> fail ()) args args' in
            mk_Typ_app(hd, args) t.tk t.pos in
          let b_ktecs = args |> List.map (function (Inl t, _) -> [], T t | (Inr e, _) -> [], E e) in
          let matches t' =
            let hd', _ = Util.head_and_args t' in
            head_matches env hd hd' <> MisMatch in
          rebuild, matches, b_ktecs

        | Typ_ascribed(t, _) -> 
          decompose_typ env t
        
        | Typ_fun(bs, c) -> 
          let rebuild, b_ktecs = 
              decompose_binder bs (C c) (fun bs -> function 
                | C c -> mk_Typ_fun(bs, c) ktype t.pos
                | _ -> fail ()) in
          let matches t = match (Util.compress_typ t).n with 
            | Typ_fun _ -> true
            | _ -> false in
          rebuild, matches, b_ktecs

        | _ -> 
          let rebuild = function
            | [] -> t
            | _ -> fail () in
          rebuild, (fun t -> true), []

let rec solve (top:bool) (env:Tc.Env.env) probs : solution = 
//    printfn "Solving TODO:\n%s;;" (List.map prob_to_string probs.attempting |> String.concat "\n\t");
    match probs.attempting with 
       | hd::tl -> 
        let probs = {probs with attempting=tl} in
         (match hd with 
            | KProb (rel, k1, k2) -> solve_k top env rel k1 k2 probs
            | TProb (rel, t1, t2) -> solve_t top env rel t1 t2 probs
            | EProb (rel, e1, e2) -> solve_e top env rel e1 e2 probs
            | CProb (rel, c1, c2) -> solve_c top env rel c1 c2 probs)
       | [] ->
         match probs.deferred with 
            | [] -> Success (probs.subst, probs.guard) //Yay ... done!
            | _ -> 
              let ctr = List.length probs.subst in 
              let attempt, rest = probs.deferred |> List.partition (fun (c, t, _) -> c < ctr) in
              match attempt with 
                 | [] -> Failed probs.deferred //no progress made to help with solving deferred problems; fail
                 | _ -> solve top env {probs with attempting=attempt |> List.map reattempt; deferred=rest} 

and imitate env probs ((u,k), ps, xs, (h, _, qs)) = 
//U p1..pn =?= h q1..qm
//extend_subst: (U -> \x1..xn. h (G1(x1..xn), ..., Gm(x1..xm)))
//sub-problems: Gi(p1..pn) =?= qi
    let r = Env.get_range env in
    let gs_xs, sub_probs = qs |> List.map (function 
        | binders, K ki -> 
            let gi_xs, gi = new_kvar r (xs@binders) in
            let gi_ps = mk_Kind_uvar(gi, ps@Util.args_of_non_null_binders binders) r in //xs are all non-null
            K gi_xs, KProb(EQ, gi_ps, ki)

        | binders, T ti -> 
            let gi_xs, gi = new_tvar r (xs@binders) ti.tk in
            let gi_ps = mk_Typ_app(gi, ps@Util.args_of_non_null_binders binders) ti.tk ti.pos in
            T gi_xs, TProb(EQ, gi_ps, ti)
        
        | binders, C ci -> 
            let gi_xs, gi = new_cvar r (xs@binders) (Util.comp_result ci) in //TODO: Also imitate the result type?
            let gi_ps = mk_Flex(mk_Typ_app(gi, ps@Util.args_of_non_null_binders binders) (Const.kunary ktype keffect) r, Util.comp_result ci) in
            C gi_xs, CProb(EQ, gi_ps, ci)

        | _, E ei -> 
            let gi_xs, gi = new_evar r xs ei.tk in
            let gi_ps = mk_Exp_app(gi, ps) ei.tk r in
            E gi_xs, EProb(EQ, gi_ps, ei)) |> List.unzip in

    let im = mk_Typ_lam(xs, h gs_xs) k r in
    //printfn "Imitating %s (%s)" (Print.typ_to_string im) (Print.tag_of_typ im);
    let probs = extend_subst (UT((u,k), im)) probs in
    solve false env (attempt sub_probs probs)

and imitate_k top env probs (u, ps, xs, (h, qs)) = 
//U p1..pn =?= h q1..qm
//extend_subst: (U -> \x1..xn. h (G1(x1..xn), ..., Gm(x1..xm)))
//sub-problems: Gi(p1..pn) =?= qi
    let r = Env.get_range env in 
    let gs_xs, sub_probs = qs |> List.map (function 
        | _, C _ 
        | _, E _ -> failwith "Impossible"

        | binders, K ki -> 
          let gi_xs, gi = new_kvar r (xs@binders) in
          let gi_ps = mk_Kind_uvar(gi, (ps@Util.args_of_non_null_binders binders)) r in
          K gi_xs, KProb(EQ, gi_ps, ki)

        | _, T ti ->  //TODO: why ignore binders here?
          let gi_xs, gi = new_tvar r xs ti.tk in
          let gi_ps = mk_Typ_app(gi, ps) ti.tk r in
          T gi_xs, TProb(EQ, gi_ps, ti)) |> List.unzip in

    let im = mk_Kind_lam(xs, h gs_xs) r in
    let probs = extend_subst (UK(u, im)) probs in 
    solve false env (attempt sub_probs probs)

and project env probs i (u, ps, xs, ((h:list<ktec> -> typ), (matches:typ -> bool), (qs:list<(binders*ktec)>))) =
//U p1..pn =?= h q1..qm
//extend subst: U -> \x1..xn. xi(G1(x1...xn) ... Gk(x1..xm)) ... where k is the arity of ti
//sub-problems: pi(G1(p1..pn)..Gk(p1..pn)) =?= h q1..qm
    let r = Env.get_range env in
    let pi = List.nth ps i in
    let rec gs k = match (Util.compress_kind k).n with 
        | Kind_delayed _
        | Kind_lam _
        | Kind_unknown
        | Kind_effect -> failwith "Impossible"
        | Kind_uvar((uv,_)) -> failwith "Impossible" //??? TODO ...what to do here ... default to Kind_type and proceed?
        | Kind_type -> [], []
        | Kind_abbrev(_, k) -> gs k
        | Kind_arrow(bs, k) -> 
          let rec aux subst bs = match bs with 
            | [] -> gs (Util.subst_kind subst k)
            | hd::tl -> 
                let gi_xs, gi_ps, subst = match fst hd with 
                    | Inl a -> 
                        let k_a = Util.subst_kind subst a.sort in
                        let gi_xs, gi = new_tvar r xs k_a in
                        let gi_xs = Tc.Normalize.eta_expand env gi_xs in
                        let gi_ps = mk_Typ_app(gi, ps) k_a r in
                        let subst = if is_null_binder hd then subst else Inl(a.v, gi_xs)::subst in
                        targ gi_xs, targ gi_ps, subst

                    | Inr x ->  
                        let t_x = Util.subst_typ subst x.sort in 
                        let gi_xs, gi = new_evar r xs t_x in
                        let gi_xs = Tc.Normalize.eta_expand_exp env gi_xs in
                        let gi_ps = mk_Exp_app(gi, ps) t_x r in
                        let subst = if is_null_binder hd then subst else Inr(x.v, gi_xs)::subst in
                        varg gi_xs, varg gi_ps, subst in
                let gi_xs', gi_ps' = aux subst tl in
                gi_xs::gi_xs', gi_ps::gi_ps' in
          aux [] bs in

    match fst pi, fst <| List.nth xs i with 
        | Inl pi, Inl xi -> 
            if not <| matches pi then giveup_noex probs
            else let g_xs, g_ps = gs xi.sort in 
                 let xi = btvar_to_typ xi in
                 let proj = mk_Typ_lam(xs, mk_Typ_app(xi, g_xs) ktype r) (snd u) r in
                 let sub = TProb(EQ, mk_Typ_app(xi, g_ps) ktype r, h <| List.map snd qs) in
                 let _ = printfn "Projecting %s" (Print.typ_to_string proj) in
                 let probs = extend_subst (UT(u, proj)) probs in
                 solve false env {probs with attempting=sub::probs.attempting}
        | _ -> giveup_noex probs

and solve_k (top:bool) (env:Env.env) rel k1 k2 probs : solution = 
    if Util.physical_equality k1 k2 then solve top env probs else
    let k1 = compress_k env probs.subst k1 in 
    let k2 = compress_k env probs.subst k2 in 
    if Util.physical_equality k1 k2 then solve top env probs else
    let r = Env.get_range env in 

    match k1.n, k2.n with 
     | Kind_type, Kind_type 
     | Kind_effect, Kind_effect -> solve top env probs

     | Kind_abbrev(_, k1), _ -> solve_k top env rel k1 k2 probs
     | _, Kind_abbrev(_, k2) -> solve_k top env rel k1 k2 probs

     | Kind_arrow(bs1, k1'), Kind_arrow(bs2, k2') -> 
       solve_binders bs1 bs2 rel (KProb(rel, k1, k2)) probs
       (fun subst subprobs -> solve false env (attempt (KProb(rel, k1', Util.subst_kind subst k2')::subprobs) probs)) 
       
     | Kind_uvar(u1, args1), Kind_uvar (u2, args2) -> //flex-flex ... unify, if patterns
       let maybe_vars1 = pat_vars [] args1 in
       let maybe_vars2 = pat_vars [] args2 in
       begin match maybe_vars1, maybe_vars2 with 
            | None, _
            | _, None -> giveup "flex-flex: non patterns" (KProb(rel, k1, k2)) probs
            | Some xs, Some ys -> 
              if Unionfind.equivalent u1 u2 && binders_eq xs ys
              then solve top env probs
              else
                    //U1 xs =?= U2 ys
                    //zs = xs intersect ys, U fresh
                    //U1 = \xs. U zs
                    //U2 = \ys. U zs
                  let zs = intersect_vars xs ys in
                  let u, _ = new_kvar r zs in 
                  let k1 = mk_Kind_lam(xs, u) r in
                  let k2 = mk_Kind_lam(ys, u) r in
                  let probs = extend_subst (UK(u1, k1)) probs |> extend_subst (UK(u2, k2)) in
                  solve top env probs
       end

     | Kind_uvar(u, args), _ -> //flex-rigid: only resolve kind variables to closed kind-lambdas
       let maybe_vars1 = pat_vars [] args in
       begin match maybe_vars1 with 
         | Some xs -> 
           let fvs1 = freevars_of_binders xs in
           let fvs2 = Util.freevars_kind k2 in
           let uvs2 = Util.uvars_in_kind k2 in
           if Util.set_is_subset_of fvs2.ftvs fvs1.ftvs
              && Util.set_is_subset_of fvs2.fxvs fvs1.fxvs
              && not(Util.set_mem u uvs2.uvars_k)
           then let k1 = mk_Kind_lam(xs, k2) r in //Solve in one-step
                solve top env (extend_subst (UK(u, k1)) probs)
           else (printfn "Imitating ... ";
                 imitate_k top env probs (u, xs |> Util.args_of_non_null_binders, xs, decompose_kind env k2) )
        | None -> 
           giveup (Util.format1 "flex-rigid: not a pattern (args=%s)" (Print.args_to_string args)) (KProb(rel, k1, k2)) probs
       end
          
     | _, Kind_uvar _ -> //rigid-flex ... re-orient
       solve_k top env EQ k2 k1 probs

     | Kind_delayed _, _ 
     | Kind_unknown, _
     | _, Kind_delayed _ 
     | _, Kind_unknown -> failwith "Impossible"

     | _ -> giveup "head mismatch (k-1)" (KProb(rel, k1, k2)) probs

and solve_binders (bs1:binders) (bs2:binders) rel orig probs rhs =
   let rec aux subprobs subst bs1 bs2 = match bs1, bs2 with 
        | [], [] -> rhs subst subprobs
        | hd1::tl1, hd2::tl2 -> 
            let s' = subst_binder hd1 hd2 subst in
            begin match fst hd1, fst hd2 with 
                | Inl a, Inl b -> aux (KProb(rel, Util.subst_kind subst b.sort, a.sort)::subprobs) s' tl1 tl2 
                | Inr x, Inr y -> aux (TProb(rel, Util.subst_typ subst y.sort, x.sort)::subprobs) s' tl1 tl2
                | _ -> giveup "arrow mismatch" orig probs
            end
        | _ -> giveup "arrow-kind arity" orig probs in
       aux [] [] bs1 bs2

and solve_t_flex_flex top env orig (t1, u1, k1, args1) (t2, u2, k2, args2) probs = 
    let maybe_pat_vars1 = pat_vars [] args1 in
    let maybe_pat_vars2 = pat_vars [] args2 in
    let r = t2.pos in
    begin match maybe_pat_vars1, maybe_pat_vars2 with 
        | None, _
        | _, None -> solve top env (defer "flex/flex not patterns" orig probs) //defer
        | Some xs, Some ys -> 
            if (Unionfind.equivalent u1 u2 && binders_eq xs ys)
            then solve top env probs
            else 
                //U1 xs =?= U2 ys
                //zs = xs intersect ys, U fresh
                //U1 = \x1 x2. U zs
                //U2 = \y1 y2 y3. U zs
                let zs = intersect_vars xs ys in
                let u_zs, _ = new_tvar r zs t2.tk in
                let sub1 = mk_Typ_lam(xs, u_zs) k1 r in
                let sub2 = mk_Typ_lam(ys, u_zs) k2 r in
                //let _ = printfn "Flex-flex %s, %s" (Print.typ_to_string sub1) (Print.typ_to_string sub2) in
                let probs = extend_subst (UT((u1,k1), sub1)) probs |> extend_subst (UT((u2,k2), sub2)) in
                solve false env probs
    end

and solve_t_flex_rigid top env orig (t1, uv, k, args_lhs) t2 probs = 
      let maybe_pat_vars = pat_vars [] args_lhs in
        let subterms ps = 
            let xs = ps |> List.map (function 
                | Inl pi, imp -> Inl <| Util.bvd_to_bvar_s (Util.new_bvd None) pi.tk, imp
                | Inr pi, imp -> Inr <| Util.bvd_to_bvar_s (Util.new_bvd None) pi.tk, imp) in
            (uv,k), ps, xs, decompose_typ env t2 in

        let rec imitate_or_project n st i = 
            if i >= n then giveup "flex-rigid case failed all backtracking attempts" orig probs
            else if i = -1 
            then match imitate env probs st with
                   | Failed _ -> imitate_or_project n st (i + 1) //backtracking point
                   | sol -> sol
            else match project env probs i st with
                   | Failed _ -> imitate_or_project n st (i + 1) //backtracking point
                   | sol -> sol in

        let check_head fvs1 t2 =
            let fvs_hd = Util.head_and_args t2 |> fst |> Util.freevars_typ in
            Util.fvs_included fvs_hd fvs1 in
            
        let imitate fvs1 t2 = (* -1 means begin by imitating *)
            let fvs_hd = Util.head_and_args t2 |> fst |> Util.freevars_typ in
            if Util.fvs_included fvs_hd fvs1
            then -1
            else 0 in

        begin match maybe_pat_vars with 
            | Some vars -> 
              let t2 = sn env t2 in 
              let fvs1 = Util.freevars_typ t1 in
              let fvs2 = Util.freevars_typ t2 in
              let uvs = Util.uvars_in_typ t2 in 
              let occurs_ok = not (Util.set_mem (uv,k) uvs.uvars_t) in 
              if not occurs_ok 
              then giveup (Util.format2 "occurs-check failed (%s occurs in {%s})" (Print.uvar_t_to_string (uv,k)) (Util.set_elements uvs.uvars_t |> List.map Print.uvar_t_to_string |> String.concat ", "))
                          orig probs
              else if Util.fvs_included fvs2 fvs1
              then //fast solution for flex-pattern/rigid case
                   let sol = match vars with 
                    | [] -> t2
                    | _ -> mk_Typ_lam(vars, t2) k t1.pos in
                   //let _ = if debug env then printfn "Fast solution for %s \t -> \t %s" (Print.typ_to_string t1) (Print.typ_to_string sol) in
                   solve top env (extend_subst (UT((uv,k), sol)) probs)
              else if check_head fvs1 t2 
              then imitate_or_project (List.length args_lhs) (subterms args_lhs) -1
              else giveup "head-symbol is free" orig probs
            | None -> if check_head (Util.freevars_typ t1) t2
                      then imitate_or_project (List.length args_lhs) (subterms args_lhs) (imitate (Util.freevars_typ t1) t2)
                      else giveup "head-symbol is free" orig probs
        end

  
and solve_t (top:bool) (env:Env.env) rel t1 t2 probs : solution = 
    if Util.physical_equality t1 t2 then solve top env probs else
    let t1 = compress env probs.subst t1 in
    let t2 = compress env probs.subst t2 in 
//    printfn "Attempting %s" (prob_to_string (TProb(rel, t1, t2)));
//    printfn "Tag t1 = %s, t2 = %s" (Print.tag_of_typ t1) (Print.tag_of_typ t2);
    if Util.physical_equality t1 t2 then solve top env probs else
    let r = Env.get_range env in
    match t1.n, t2.n with
      | Typ_ascribed(t, _), _
      | Typ_meta(Meta_pattern(t, _)), _ 
      | Typ_meta(Meta_named(t, _)), _ -> solve_t top env rel t t2 probs

      | _, Typ_ascribed(t, _)
      | _, Typ_meta(Meta_pattern(t, _))
      | _, Typ_meta(Meta_named(t, _)) -> solve_t top env rel t1 t probs

      (* flex-flex *)
      | Typ_uvar (u1, k1), Typ_uvar(u2, k2) -> 
        solve_t_flex_flex top env (TProb(rel, t1, t2)) (t1, u1, k1, []) (t2, u2, k2, []) probs
      | Typ_app({n=Typ_uvar(u1, k1)}, args1), Typ_uvar(u2, k2) -> 
        solve_t_flex_flex top env (TProb(rel, t1, t2)) (t1, u1, k1, args1) (t2, u2, k2, []) probs
      | Typ_uvar(u1, k1), Typ_app({n=Typ_uvar(u2, k2)}, args2) -> 
        solve_t_flex_flex top env (TProb(rel, t1, t2)) (t1, u1, k1, []) (t2, u2, k2, args2) probs
      | Typ_app({n=Typ_uvar(u1, k1)}, args1), Typ_app({n=Typ_uvar(u2, k2)}, args2) -> //flex-flex ... defer, unless they are both patterns
        solve_t_flex_flex top env (TProb(rel, t1, t2)) (t1, u1, k1, args1) (t2, u2, k2, args2) probs

      | Typ_btvar a, Typ_btvar b -> 
        if Util.bvd_eq a.v b.v 
        then solve top env probs
        else giveup "unequal type variables" (TProb(rel, t1, t2)) probs

      | Typ_fun(bs1, c1), Typ_fun(bs2, c2) ->
        solve_binders bs1 bs2 rel (TProb(rel, t1, t2)) probs
        (fun subst subprobs -> solve false env (attempt (CProb(rel, c1, Util.subst_comp subst c2)::subprobs) probs))

      | Typ_lam(bs1, t1'), Typ_lam(bs2, t2') -> 
        solve_binders bs1 bs2 rel (TProb(rel, t1, t2)) probs
        (fun subst subprobs -> solve false env (attempt (TProb(rel, t1', Util.subst_typ subst t2')::subprobs) probs))

      | Typ_refine(x1, phi1), Typ_refine(x2, phi2) -> 
        let x1 = v_binder x1 in
        let x2 = v_binder x2 in 
        solve_binders [x1] [x2] rel (TProb(rel, t1, t2)) probs 
        (fun subst subprobs -> 
            match rel with
               | EQ -> solve false env (attempt (TProb(rel, phi1, Util.subst_typ subst phi2)::subprobs) probs)
               | SUB -> (* but if either phi1 or phi2 are patterns, why not solve it by equating? *)
                let g = NonTrivial <| mk_Typ_lam([x1], Util.mk_imp phi1 (Util.subst_typ subst phi2)) (mk_Kind_arrow([x1], ktype) r) r in
                let probs = guard env top g probs in
                solve false env (attempt subprobs probs))
  
      (* flex-rigid *)
      | Typ_uvar(uv, k), _ -> 
        solve_t_flex_rigid top env (TProb(rel, t1, t2)) (t1, uv, k, []) t2 probs
      | Typ_app({n=Typ_uvar(uv,k)}, args_lhs), _ -> 
        solve_t_flex_rigid top env (TProb(rel, t1, t2)) (t1, uv, k, args_lhs) t2 probs

      | _, Typ_uvar _ 
      | _, Typ_app({n=Typ_uvar _}, _) -> //rigid-flex
        solve_t top env EQ t2 t1 probs //re-orient

      | Typ_refine(x, phi1), _ ->
        if rel=EQ
        then giveup "refinement subtyping is not applicable" (TProb(rel, t1, t2)) probs //but t2 may be able to take delta steps
        else solve_t top env rel x.sort t2 probs

      | _, Typ_refine(x, phi2) -> 
        if rel=EQ
        then giveup "refinement subtyping is not applicable" (TProb(rel, t1, t2)) probs //but t1 may be able to take delta steps
        else let g = NonTrivial <| mk_Typ_lam([v_binder (bvd_to_bvar_s x.v t1)], phi2) (mk_Kind_arrow([null_v_binder t1], ktype) r) r in
             solve_t top env rel t1 x.sort (guard env top g probs)   
      
      | Typ_btvar _, _
      | Typ_const _, _
      | Typ_app _, _
      | _, Typ_btvar _
      | _, Typ_const _ 
      | _, Typ_app _ -> 
         let m, o = head_matches_delta env t1 t2 in
         begin match m, o  with 
            | (MisMatch, _) -> 
                giveup "head mismatch (t-1)" (TProb(rel, t1, t2)) probs        //heads definitely do not match

            | (_, Some (t1, t2)) ->
               //              printfn "Head match with delta %s, %s" (Print.typ_to_string head) (Print.typ_to_string head');
               probs |> solve_t top env rel t1 t2

            | (_, None) -> //head matches head'
                let head, args = Util.head_and_args t1 in
                let head', args' = Util.head_and_args t2 in
                if List.length args = List.length args'
                then let subprobs = List.map2 (fun a a' -> match fst a, fst a' with 
                    | Inl t, Inl t' -> TProb(EQ, t, t')
                    | Inr v, Inr v' -> EProb(EQ, v, v')
                    | _ -> failwith "Impossible" (*terms are well-kinded*)) args args' in
                    let subprobs = match m with 
                        | FullMatch -> subprobs
                        | _ -> TProb(EQ, head, head')::subprobs in
                    solve false env (attempt subprobs probs)
                else giveup (Util.format4 "unequal number of arguments: %s[%s] and %s[%s]" 
                            (Print.typ_to_string head)
                            (Print.args_to_string args)
                            (Print.typ_to_string head')
                            (Print.args_to_string args')) 
                            (TProb(rel, t1, t2)) probs
          end

      | _ -> giveup (Util.format2 "head mismatch (t-2): %s and %s" (Print.tag_of_typ t1) (Print.tag_of_typ t2)) (TProb(rel, t1, t2)) probs

and solve_c (top:bool) (env:Env.env) rel c1 c2 probs : solution =
    if Util.physical_equality c1 c2 then solve top env probs
    else let c1 = comp_comp env probs.subst c1 in
         let c2 = comp_comp env probs.subst c2 in
         let r = Env.get_range env in
         match c1.n, c2.n with
               | Rigid _, _
               | _, Rigid _ -> failwith "Impossible" //already normalized

               | Total _, Flex _ 
               | Comp _, Flex _ ->  //rigid-flex -- reorient
                 solve_c top env rel c2 c1 probs

               | Flex ({n=Typ_app({n=Typ_uvar(uv,k)}, eff_args)}, t1), Total _ 
               | Flex ({n=Typ_app({n=Typ_uvar(uv,k)}, eff_args)}, t1), Comp _ -> //flex-rigid 
                 let maybe_pat_vars = pat_vars [] eff_args in
                 begin match maybe_pat_vars with 
                    | None -> //not a pattern; refuse to solve this case
                      giveup (Printf.sprintf "flex-rigid (2): not a pattern (%s)" (eff_args |> List.map (function Inl t, _ -> Print.tag_of_typ t 
                                                                                                                | Inr e, _ -> Print.tag_of_exp e) |> String.concat ", ")) 
                                                                                  (CProb(rel, c1, c2)) probs
                    | Some vars ->
                      let c2 = Normalize.norm_comp [Beta;SNComp] env c2 in
                      let fvs1 = Util.freevars_comp c1 in
                      let fvs2 = Util.freevars_comp c2 in
                      let uv2 = Util.uvars_in_comp c2 in
                      if Util.set_is_subset_of fvs2.ftvs fvs1.ftvs
                         && Util.set_is_subset_of fvs2.fxvs fvs1.fxvs
                         && not (Util.set_mem  (uv,k) uv2.uvars_c)
                      then //good, we have an eligible pattern ... solve in one step, producing one sub problem
                           //let _ = printfn "Resolving flex %s to %s" (Print.comp_typ_to_string c1) (Print.comp_typ_to_string c2) in
                            let sol = mk_Typ_lam(vars@[null_t_binder ktype], mk_Typ_meta(Meta_comp c2)) k r in
                            let probs = attempt [TProb(rel, t1, Util.comp_result c2)] probs in
                            solve top env (extend_subst (UC((uv,k), sol)) probs)
                      else giveup (Util.format4 "flex-rigid: failed free-variable or occurs check: Uvars %s, {%s}\n fvs2=%s\n fvs1=%s" 
                                        (Unionfind.uvar_id uv |> string_of_int)
                                        (uv2.uvars_c |> Util.set_elements |> List.map (fun (u, _) -> Unionfind.uvar_id u |> Util.string_of_int) |> String.concat ", ")
                                        (Print.freevars_to_string fvs2)
                                        (Print.freevars_to_string fvs1))
                                   (CProb(rel, c1, c2)) probs 
                 end

               | Total t1, Total t2 -> //rigid-rigid 1
                 solve_t false env rel t1 t2 probs
               
               | Total _,  Comp _ -> solve_c top env rel (mk_Comp <| comp_to_comp_typ c1) c2 probs
               | Comp _, Total _ -> solve_c top env rel c1 (mk_Comp <| comp_to_comp_typ c2) probs
               
               | Comp _, Comp _ ->
                 let c1_0, c2_0 = c1, c2 in
                 let c1 = Normalize.weak_norm_comp env c1 in
                 let c2 = Normalize.weak_norm_comp env c2 in
                 let has_uvars t = 
                    let uvs = Util.uvars_in_typ t in
                    Util.set_count uvs.uvars_t > 0 in
                 begin match Tc.Env.monad_leq env c1.effect_name c2.effect_name with
                   | None -> giveup "incompatible monad ordering" (CProb(rel, c1_0, c2_0)) probs
                   | Some edge ->
                     let is_null_wp c2_decl wpc2 = 
                         if not !Options.verify then false
                         else match solve_t false env EQ wpc2 (sn env <| mk_Typ_app(c2_decl.null_wp, [targ c2.result_typ]) wpc2.tk r) empty_worklist with 
                           | Failed _ -> false
                           | Success _ -> true in
                     let wpc1, wpc2 = match c1.effect_args, c2.effect_args with 
                       | (Inl wp1, _)::_, (Inl wp2, _)::_ -> wp1, wp2 
                       | _ -> failwith (Util.format2 "Got effects %s and %s, expected normalized effects" (Print.sli c1.effect_name) (Print.sli c2.effect_name)) in
                     let res_t_prob = TProb(rel, c1.result_typ, c2.result_typ) in
                     //let _ = printfn "Checking sub probs:\n(1) %s" (prob_to_string res_t_prob) in
                        if Util.physical_equality wpc1 wpc2 
                        then (//printfn "Physical equality of wps ... done";
                              solve false env (attempt [res_t_prob] probs))
                        else 
//                             let wpc1 = Tc.Normalize.norm_typ [Beta] env wpc1 in
//                             let wpc2 = Tc.Normalize.norm_typ [Beta] env wpc2 in
                             if false && has_uvars wpc2 //how to decide this test efficiently?
                             then (let prob = TProb(EQ, wpc1, wpc2) in
                                   printfn "wpc2 has uvars ... solving\n(2)%s\n" (prob_to_string env prob);
                                   solve false env (attempt [res_t_prob; prob] probs))
                             else if rel=SUB
                             then let c2_decl : monad_decl = Tc.Env.get_monad_decl env c2.effect_name in
                             let g = 
                               if is_null_wp c2_decl wpc2 
                               then let _ = if debug env then Util.print_string "Using trivial wp ... \n" in
                                    NonTrivial <| mk_Typ_app(c2_decl.trivial, [targ c1.result_typ; targ <| edge.mlift c1.result_typ wpc1]) ktype r 
                               else let wp2_imp_wp1 = mk_Typ_app(c2_decl.wp_binop, 
                                            [targ c2.result_typ; 
                                             targ wpc2; 
                                             targ <| Util.ftv Const.imp_lid (Const.kbin ktype ktype ktype); 
                                             targ <| edge.mlift c1.result_typ wpc1]) wpc2.tk r in
                                    NonTrivial <| mk_Typ_app(c2_decl.wp_as_type, [targ c2.result_typ; targ wp2_imp_wp1]) ktype r  in
                             //printfn "Adding guard %s\n" (guard_to_string env (simplify_guard env g));
                             let probs = guard env top g probs in 
                             solve false env (attempt [res_t_prob] probs)
                        else giveup "Equality of wps---unimplemented" (CProb(rel, c1_0, c2_0)) probs 
                 end

               | Flex ({n=Typ_app({n=Typ_uvar(uv1,k1)}, eff_args1)}, t1),  Flex ({n=Typ_app({n=Typ_uvar(uv2,k2)}, eff_args2)}, t2) -> //flex-flex
                 let maybe_pat_vars1 = pat_vars [] eff_args1 in
                 let maybe_pat_vars2 = pat_vars [] eff_args2 in
                 begin match maybe_pat_vars1, maybe_pat_vars2 with 
                    | None, _
                    | _, None -> giveup "flex-flex: not a pattern" (CProb(rel, c1, c2)) probs
                    | Some xs, Some ys -> 
                       if Unionfind.equivalent uv1 uv2 && binders_eq xs ys
                       then solve false env probs
                       else
                           //F xs =?= G ys
                           //zs = xs intersect ys, U fresh
                           //F = \x1 x2. U zs
                           //G = \y1 y2 y3. U zs
                          let zs = intersect_vars xs ys in
                          let u, _ = new_cvar (Env.get_range env) zs t2 in
                          let u_zs = mk_Typ_meta(Meta_comp u) in
                          let fsub = mk_Typ_lam(xs, u_zs) k1 r in
                          let gsub = mk_Typ_lam(ys, u_zs) k2 r in
                          let probs = extend_subst (UC((uv1,k1), fsub)) probs |> extend_subst (UC((uv2,k2), gsub)) in
                          solve false env (attempt [TProb(rel, t1, t2)] probs)
                 end
                 
               | _ -> failwith "Impossible"

and solve_e (top:bool) (env:Env.env) rel e1 e2 probs : solution = 
    let e1 = compress_e env probs.subst e1 in 
    let e2 = compress_e env probs.subst e2 in
    match e1.n, e2.n with 
    | Exp_bvar x1, Exp_bvar x1' -> 
      if Util.bvd_eq x1.v x1'.v
      then solve top env probs
      else solve top env (guard env top (NonTrivial <| Util.mk_eq e1 e2) probs)

    | Exp_fvar (fv1, _), Exp_fvar (fv1', _) -> 
      if lid_equals fv1.v fv1'.v
      then solve top env probs
      else giveup "free-variables unequal" (EProb(rel, e1, e2)) probs //distinct top-level free vars are never provably equal

    | Exp_constant s1, Exp_constant s1' -> 
      let const_eq s1 s2 = match s1, s2 with 
          | Const_bytearray(b1, _), Const_bytearray(b2, _) -> b1=b2
          | Const_string(b1, _), Const_string(b2, _) -> b1=b2
          | _ -> s1=s2 in
      if const_eq s1 s1'
      then solve top env probs
      else giveup "constants unequal" (EProb(rel, e1, e2)) probs

    | Exp_ascribed(e1, _), _ -> 
      solve_e top env rel e1 e2 probs

    | _, Exp_ascribed(e2, _) -> 
      solve_e top env rel e1 e2 probs

    | Exp_app({n=Exp_uvar(u1,t1); pos=r1}, args1), Exp_app({n=Exp_uvar(u2, t2); pos=r2}, args2) -> //flex-flex: solve only patterns
      let maybe_vars1 = pat_vars [] args1 in
      let maybe_vars2 = pat_vars [] args2 in
      begin match maybe_vars1, maybe_vars2 with 
        | None, _
        | _, None -> solve top env (defer "flex/flex not a pattern" (EProb(rel, e1, e2)) probs) //refuse to solve non-patterns
        | Some xs, Some ys -> 
          if (Unionfind.equivalent u1 u2 && binders_eq xs ys)
          then solve top env probs
          else 
              //U1 xs =?= U2 ys
              //zs = xs intersect ys, U fresh
              //U1 = \x1 x2. U zs
              //U2 = \y1 y2 y3. U zs 
              let zs = intersect_vars xs ys in 
              let u, _ = new_evar (Env.get_range env) zs e2.tk in
              let sub1 = mk_Exp_abs(xs, u) t1 r1 in
              let sub2 = mk_Exp_abs(ys, u) t2 r2 in
              solve top env (extend_subst (UE((u1,t1), sub1)) probs |> extend_subst (UE((u2,t2), sub2))) 
      end

    | Exp_app({n=Exp_uvar(u1,t1); pos=r1}, args1), _ -> //flex-rigid: solve only patterns
      let maybe_vars1 = pat_vars [] args1 in
      begin match maybe_vars1 with 
        | None -> solve top env (defer "flex/rigid not a pattern" (EProb(rel, e1, e2)) probs)
        | Some xs -> 
          let fvs1 = freevars_of_binders xs in 
          let fvs2 = Util.freevars_exp e2 in 
          if Util.set_is_subset_of fvs2.ftvs fvs1.ftvs 
             && Util.set_is_subset_of fvs2.fxvs fvs1.fxvs 
          then // U1 xs =?= e2
               // U1 = \xs. e2
               let sol = mk_Exp_abs(xs, e2) t1 r1 in
               solve top env (extend_subst (UE((u1,t1), sol)) probs)
          else giveup "flex-rigid: free variable/occurs check failed" (EProb(rel, e1, e2)) probs
      end

    | _, Exp_uvar _ -> //rigid-flex ... reorient
     solve_e top env EQ e2 e1 probs

    | _ -> //TODO: check that they at least have the same head? 
     solve top env (guard env top (NonTrivial <| Util.mk_eq e1 e2) probs)  
          
let explain env d = 
    d |> List.iter (fun (_, p, reason) -> 
        Util.fprint2 "Problem:\n%s\nFailed because: %s\n" (prob_to_string env p) reason)

let solve_and_commit env top_t prob err = 
  let sol = solve true env (singleton prob top_t) in
  match sol with 
    | Success (s, guard) -> 
      //printfn "Successs ... got guard %s\n" (guard_to_string env guard);
      commit env s; Some guard
    | Failed d -> 
        explain env d;
        err d

let keq env t k1 k2 : guard = 
  let prob = KProb(EQ, norm_kind [Beta] env k1, norm_kind [Beta] env k2) in
  Util.must <| solve_and_commit env None prob (fun _ -> 
      let r = match t with 
        | None -> Tc.Env.get_range env
        | Some t -> t.pos in
      match t with 
        | None -> raise (Error(Tc.Errors.incompatible_kinds k2 k1, r))
        | Some t -> raise (Error(Tc.Errors.expected_typ_of_kind k2 t k1, r)))
    
let teq env t1 t2 : guard = 
 let prob = TProb(EQ, t1, t2) in //norm_typ [Beta; Eta] env t1, norm_typ [Beta; Eta] env t2) in
 Util.must <| solve_and_commit env (Some t1) prob (fun _ -> 
    raise (Error(Tc.Errors.basic_type_error None t2 t1, Tc.Env.get_range env)))

let subkind env k1 k2 : guard = 
 let prob  = KProb(SUB, whnf_k env k1, whnf_k env k2) in
 Util.must <| solve_and_commit env None prob (fun _ -> 
    raise (Error(Tc.Errors.incompatible_kinds k1 k2, Tc.Env.get_range env)))

let try_subtype env t1 t2 = 
 if debug env then printfn "try_subtype of %s : %s and %s : %s\n" (Print.typ_to_string t1) (Print.kind_to_string t1.tk) (Print.typ_to_string t2) (Print.kind_to_string t2.tk);
 let res = solve_and_commit env (Some t1) (TProb(SUB, t1, t2))//norm_typ [Beta; Eta] env t1, norm_typ [Beta; Eta] env t2))
 (fun _ -> None) in
 if debug env then printfn "...done"; res

  
let subtype env t1 t2 : guard = 
  match try_subtype env t1 t2 with
    | Some f -> f
    | None -> 
         Util.fprint2 "Incompatible types %s\nand %s\n" (Print.typ_to_string t1) (Print.typ_to_string t2);
         raise (Error(Tc.Errors.basic_type_error None t2 t1, Tc.Env.get_range env))

let trivial_subtype env eopt t1 t2 = 
  let f = try_subtype env t1 t2 in 
  match f with 
    | Some Trivial -> ()
    | None 
    | Some (NonTrivial _) ->  
      let r = Tc.Env.get_range env in
      raise (Error(Tc.Errors.basic_type_error eopt t2 t1, r))

let sub_comp env c1 c2 = 
  solve_and_commit env None (CProb(SUB, c1, c2))
  (fun _ -> None)
