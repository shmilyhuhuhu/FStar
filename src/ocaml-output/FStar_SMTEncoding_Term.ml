open Prims
let (escape : Prims.string -> Prims.string) =
  fun s  -> FStar_Util.replace_char s 39 95 
type sort =
  | Bool_sort 
  | Int_sort 
  | String_sort 
  | Term_sort 
  | Fuel_sort 
  | BitVec_sort of Prims.int 
  | Array of (sort,sort) FStar_Pervasives_Native.tuple2 
  | Arrow of (sort,sort) FStar_Pervasives_Native.tuple2 
  | Sort of Prims.string 
let (uu___is_Bool_sort : sort -> Prims.bool) =
  fun projectee  ->
    match projectee with | Bool_sort  -> true | uu____50 -> false
  
let (uu___is_Int_sort : sort -> Prims.bool) =
  fun projectee  ->
    match projectee with | Int_sort  -> true | uu____61 -> false
  
let (uu___is_String_sort : sort -> Prims.bool) =
  fun projectee  ->
    match projectee with | String_sort  -> true | uu____72 -> false
  
let (uu___is_Term_sort : sort -> Prims.bool) =
  fun projectee  ->
    match projectee with | Term_sort  -> true | uu____83 -> false
  
let (uu___is_Fuel_sort : sort -> Prims.bool) =
  fun projectee  ->
    match projectee with | Fuel_sort  -> true | uu____94 -> false
  
let (uu___is_BitVec_sort : sort -> Prims.bool) =
  fun projectee  ->
    match projectee with | BitVec_sort _0 -> true | uu____107 -> false
  
let (__proj__BitVec_sort__item___0 : sort -> Prims.int) =
  fun projectee  -> match projectee with | BitVec_sort _0 -> _0 
let (uu___is_Array : sort -> Prims.bool) =
  fun projectee  ->
    match projectee with | Array _0 -> true | uu____134 -> false
  
let (__proj__Array__item___0 :
  sort -> (sort,sort) FStar_Pervasives_Native.tuple2) =
  fun projectee  -> match projectee with | Array _0 -> _0 
let (uu___is_Arrow : sort -> Prims.bool) =
  fun projectee  ->
    match projectee with | Arrow _0 -> true | uu____170 -> false
  
let (__proj__Arrow__item___0 :
  sort -> (sort,sort) FStar_Pervasives_Native.tuple2) =
  fun projectee  -> match projectee with | Arrow _0 -> _0 
let (uu___is_Sort : sort -> Prims.bool) =
  fun projectee  ->
    match projectee with | Sort _0 -> true | uu____203 -> false
  
let (__proj__Sort__item___0 : sort -> Prims.string) =
  fun projectee  -> match projectee with | Sort _0 -> _0 
let rec (strSort : sort -> Prims.string) =
  fun x  ->
    match x with
    | Bool_sort  -> "Bool"
    | Int_sort  -> "Int"
    | Term_sort  -> "Term"
    | String_sort  -> "FString"
    | Fuel_sort  -> "Fuel"
    | BitVec_sort n1 ->
        let uu____231 = FStar_Util.string_of_int n1  in
        FStar_Util.format1 "(_ BitVec %s)" uu____231
    | Array (s1,s2) ->
        let uu____236 = strSort s1  in
        let uu____238 = strSort s2  in
        FStar_Util.format2 "(Array %s %s)" uu____236 uu____238
    | Arrow (s1,s2) ->
        let uu____243 = strSort s1  in
        let uu____245 = strSort s2  in
        FStar_Util.format2 "(%s -> %s)" uu____243 uu____245
    | Sort s -> s
  
type op =
  | TrueOp 
  | FalseOp 
  | Not 
  | And 
  | Or 
  | Imp 
  | Iff 
  | Eq 
  | LT 
  | LTE 
  | GT 
  | GTE 
  | Add 
  | Sub 
  | Div 
  | Mul 
  | Minus 
  | Mod 
  | BvAnd 
  | BvXor 
  | BvOr 
  | BvAdd 
  | BvSub 
  | BvShl 
  | BvShr 
  | BvUdiv 
  | BvMod 
  | BvMul 
  | BvUlt 
  | BvUext of Prims.int 
  | NatToBv of Prims.int 
  | BvToNat 
  | ITE 
  | Var of Prims.string 
let (uu___is_TrueOp : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | TrueOp  -> true | uu____277 -> false
  
let (uu___is_FalseOp : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | FalseOp  -> true | uu____288 -> false
  
let (uu___is_Not : op -> Prims.bool) =
  fun projectee  -> match projectee with | Not  -> true | uu____299 -> false 
let (uu___is_And : op -> Prims.bool) =
  fun projectee  -> match projectee with | And  -> true | uu____310 -> false 
let (uu___is_Or : op -> Prims.bool) =
  fun projectee  -> match projectee with | Or  -> true | uu____321 -> false 
let (uu___is_Imp : op -> Prims.bool) =
  fun projectee  -> match projectee with | Imp  -> true | uu____332 -> false 
let (uu___is_Iff : op -> Prims.bool) =
  fun projectee  -> match projectee with | Iff  -> true | uu____343 -> false 
let (uu___is_Eq : op -> Prims.bool) =
  fun projectee  -> match projectee with | Eq  -> true | uu____354 -> false 
let (uu___is_LT : op -> Prims.bool) =
  fun projectee  -> match projectee with | LT  -> true | uu____365 -> false 
let (uu___is_LTE : op -> Prims.bool) =
  fun projectee  -> match projectee with | LTE  -> true | uu____376 -> false 
let (uu___is_GT : op -> Prims.bool) =
  fun projectee  -> match projectee with | GT  -> true | uu____387 -> false 
let (uu___is_GTE : op -> Prims.bool) =
  fun projectee  -> match projectee with | GTE  -> true | uu____398 -> false 
let (uu___is_Add : op -> Prims.bool) =
  fun projectee  -> match projectee with | Add  -> true | uu____409 -> false 
let (uu___is_Sub : op -> Prims.bool) =
  fun projectee  -> match projectee with | Sub  -> true | uu____420 -> false 
let (uu___is_Div : op -> Prims.bool) =
  fun projectee  -> match projectee with | Div  -> true | uu____431 -> false 
let (uu___is_Mul : op -> Prims.bool) =
  fun projectee  -> match projectee with | Mul  -> true | uu____442 -> false 
let (uu___is_Minus : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | Minus  -> true | uu____453 -> false
  
let (uu___is_Mod : op -> Prims.bool) =
  fun projectee  -> match projectee with | Mod  -> true | uu____464 -> false 
let (uu___is_BvAnd : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvAnd  -> true | uu____475 -> false
  
let (uu___is_BvXor : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvXor  -> true | uu____486 -> false
  
let (uu___is_BvOr : op -> Prims.bool) =
  fun projectee  -> match projectee with | BvOr  -> true | uu____497 -> false 
let (uu___is_BvAdd : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvAdd  -> true | uu____508 -> false
  
let (uu___is_BvSub : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvSub  -> true | uu____519 -> false
  
let (uu___is_BvShl : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvShl  -> true | uu____530 -> false
  
let (uu___is_BvShr : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvShr  -> true | uu____541 -> false
  
let (uu___is_BvUdiv : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvUdiv  -> true | uu____552 -> false
  
let (uu___is_BvMod : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvMod  -> true | uu____563 -> false
  
let (uu___is_BvMul : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvMul  -> true | uu____574 -> false
  
let (uu___is_BvUlt : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvUlt  -> true | uu____585 -> false
  
let (uu___is_BvUext : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvUext _0 -> true | uu____598 -> false
  
let (__proj__BvUext__item___0 : op -> Prims.int) =
  fun projectee  -> match projectee with | BvUext _0 -> _0 
let (uu___is_NatToBv : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | NatToBv _0 -> true | uu____622 -> false
  
let (__proj__NatToBv__item___0 : op -> Prims.int) =
  fun projectee  -> match projectee with | NatToBv _0 -> _0 
let (uu___is_BvToNat : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | BvToNat  -> true | uu____644 -> false
  
let (uu___is_ITE : op -> Prims.bool) =
  fun projectee  -> match projectee with | ITE  -> true | uu____655 -> false 
let (uu___is_Var : op -> Prims.bool) =
  fun projectee  ->
    match projectee with | Var _0 -> true | uu____668 -> false
  
let (__proj__Var__item___0 : op -> Prims.string) =
  fun projectee  -> match projectee with | Var _0 -> _0 
type qop =
  | Forall 
  | Exists 
let (uu___is_Forall : qop -> Prims.bool) =
  fun projectee  ->
    match projectee with | Forall  -> true | uu____690 -> false
  
let (uu___is_Exists : qop -> Prims.bool) =
  fun projectee  ->
    match projectee with | Exists  -> true | uu____701 -> false
  
type term' =
  | Integer of Prims.string 
  | BoundV of Prims.int 
  | FreeV of (Prims.string,sort) FStar_Pervasives_Native.tuple2 
  | App of (op,term Prims.list) FStar_Pervasives_Native.tuple2 
  | Quant of
  (qop,term Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
  sort Prims.list,term) FStar_Pervasives_Native.tuple5 
  | Let of (term Prims.list,term) FStar_Pervasives_Native.tuple2 
  | Labeled of (term,Prims.string,FStar_Range.range)
  FStar_Pervasives_Native.tuple3 
  | LblPos of (term,Prims.string) FStar_Pervasives_Native.tuple2 
and term =
  {
  tm: term' ;
  freevars:
    (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list
      FStar_Syntax_Syntax.memo
    ;
  rng: FStar_Range.range }
let (uu___is_Integer : term' -> Prims.bool) =
  fun projectee  ->
    match projectee with | Integer _0 -> true | uu____849 -> false
  
let (__proj__Integer__item___0 : term' -> Prims.string) =
  fun projectee  -> match projectee with | Integer _0 -> _0 
let (uu___is_BoundV : term' -> Prims.bool) =
  fun projectee  ->
    match projectee with | BoundV _0 -> true | uu____873 -> false
  
let (__proj__BoundV__item___0 : term' -> Prims.int) =
  fun projectee  -> match projectee with | BoundV _0 -> _0 
let (uu___is_FreeV : term' -> Prims.bool) =
  fun projectee  ->
    match projectee with | FreeV _0 -> true | uu____901 -> false
  
let (__proj__FreeV__item___0 :
  term' -> (Prims.string,sort) FStar_Pervasives_Native.tuple2) =
  fun projectee  -> match projectee with | FreeV _0 -> _0 
let (uu___is_App : term' -> Prims.bool) =
  fun projectee  ->
    match projectee with | App _0 -> true | uu____942 -> false
  
let (__proj__App__item___0 :
  term' -> (op,term Prims.list) FStar_Pervasives_Native.tuple2) =
  fun projectee  -> match projectee with | App _0 -> _0 
let (uu___is_Quant : term' -> Prims.bool) =
  fun projectee  ->
    match projectee with | Quant _0 -> true | uu____999 -> false
  
let (__proj__Quant__item___0 :
  term' ->
    (qop,term Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
      sort Prims.list,term) FStar_Pervasives_Native.tuple5)
  = fun projectee  -> match projectee with | Quant _0 -> _0 
let (uu___is_Let : term' -> Prims.bool) =
  fun projectee  ->
    match projectee with | Let _0 -> true | uu____1082 -> false
  
let (__proj__Let__item___0 :
  term' -> (term Prims.list,term) FStar_Pervasives_Native.tuple2) =
  fun projectee  -> match projectee with | Let _0 -> _0 
let (uu___is_Labeled : term' -> Prims.bool) =
  fun projectee  ->
    match projectee with | Labeled _0 -> true | uu____1127 -> false
  
let (__proj__Labeled__item___0 :
  term' ->
    (term,Prims.string,FStar_Range.range) FStar_Pervasives_Native.tuple3)
  = fun projectee  -> match projectee with | Labeled _0 -> _0 
let (uu___is_LblPos : term' -> Prims.bool) =
  fun projectee  ->
    match projectee with | LblPos _0 -> true | uu____1173 -> false
  
let (__proj__LblPos__item___0 :
  term' -> (term,Prims.string) FStar_Pervasives_Native.tuple2) =
  fun projectee  -> match projectee with | LblPos _0 -> _0 
let (__proj__Mkterm__item__tm : term -> term') =
  fun projectee  -> match projectee with | { tm; freevars; rng;_} -> tm 
let (__proj__Mkterm__item__freevars :
  term ->
    (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list
      FStar_Syntax_Syntax.memo)
  =
  fun projectee  -> match projectee with | { tm; freevars; rng;_} -> freevars 
let (__proj__Mkterm__item__rng : term -> FStar_Range.range) =
  fun projectee  -> match projectee with | { tm; freevars; rng;_} -> rng 
type pat = term
type fv = (Prims.string,sort) FStar_Pervasives_Native.tuple2
type fvs = (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list
type caption = Prims.string FStar_Pervasives_Native.option
type binders = (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list
type constructor_field =
  (Prims.string,sort,Prims.bool) FStar_Pervasives_Native.tuple3
type constructor_t =
  (Prims.string,constructor_field Prims.list,sort,Prims.int,Prims.bool)
    FStar_Pervasives_Native.tuple5
type constructors = constructor_t Prims.list
type fact_db_id =
  | Name of FStar_Ident.lid 
  | Namespace of FStar_Ident.lid 
  | Tag of Prims.string 
let (uu___is_Name : fact_db_id -> Prims.bool) =
  fun projectee  ->
    match projectee with | Name _0 -> true | uu____1376 -> false
  
let (__proj__Name__item___0 : fact_db_id -> FStar_Ident.lid) =
  fun projectee  -> match projectee with | Name _0 -> _0 
let (uu___is_Namespace : fact_db_id -> Prims.bool) =
  fun projectee  ->
    match projectee with | Namespace _0 -> true | uu____1396 -> false
  
let (__proj__Namespace__item___0 : fact_db_id -> FStar_Ident.lid) =
  fun projectee  -> match projectee with | Namespace _0 -> _0 
let (uu___is_Tag : fact_db_id -> Prims.bool) =
  fun projectee  ->
    match projectee with | Tag _0 -> true | uu____1417 -> false
  
let (__proj__Tag__item___0 : fact_db_id -> Prims.string) =
  fun projectee  -> match projectee with | Tag _0 -> _0 
type assumption =
  {
  assumption_term: term ;
  assumption_caption: caption ;
  assumption_name: Prims.string ;
  assumption_fact_ids: fact_db_id Prims.list }
let (__proj__Mkassumption__item__assumption_term : assumption -> term) =
  fun projectee  ->
    match projectee with
    | { assumption_term; assumption_caption; assumption_name;
        assumption_fact_ids;_} -> assumption_term
  
let (__proj__Mkassumption__item__assumption_caption : assumption -> caption)
  =
  fun projectee  ->
    match projectee with
    | { assumption_term; assumption_caption; assumption_name;
        assumption_fact_ids;_} -> assumption_caption
  
let (__proj__Mkassumption__item__assumption_name :
  assumption -> Prims.string) =
  fun projectee  ->
    match projectee with
    | { assumption_term; assumption_caption; assumption_name;
        assumption_fact_ids;_} -> assumption_name
  
let (__proj__Mkassumption__item__assumption_fact_ids :
  assumption -> fact_db_id Prims.list) =
  fun projectee  ->
    match projectee with
    | { assumption_term; assumption_caption; assumption_name;
        assumption_fact_ids;_} -> assumption_fact_ids
  
type decl =
  | DefPrelude 
  | DeclFun of (Prims.string,sort Prims.list,sort,caption)
  FStar_Pervasives_Native.tuple4 
  | DefineFun of (Prims.string,sort Prims.list,sort,term,caption)
  FStar_Pervasives_Native.tuple5 
  | Assume of assumption 
  | Caption of Prims.string 
  | Eval of term 
  | Echo of Prims.string 
  | RetainAssumptions of Prims.string Prims.list 
  | Push 
  | Pop 
  | CheckSat 
  | GetUnsatCore 
  | SetOption of (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2 
  | GetStatistics 
  | GetReasonUnknown 
let (uu___is_DefPrelude : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | DefPrelude  -> true | uu____1595 -> false
  
let (uu___is_DeclFun : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | DeclFun _0 -> true | uu____1618 -> false
  
let (__proj__DeclFun__item___0 :
  decl ->
    (Prims.string,sort Prims.list,sort,caption)
      FStar_Pervasives_Native.tuple4)
  = fun projectee  -> match projectee with | DeclFun _0 -> _0 
let (uu___is_DefineFun : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | DefineFun _0 -> true | uu____1684 -> false
  
let (__proj__DefineFun__item___0 :
  decl ->
    (Prims.string,sort Prims.list,sort,term,caption)
      FStar_Pervasives_Native.tuple5)
  = fun projectee  -> match projectee with | DefineFun _0 -> _0 
let (uu___is_Assume : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | Assume _0 -> true | uu____1743 -> false
  
let (__proj__Assume__item___0 : decl -> assumption) =
  fun projectee  -> match projectee with | Assume _0 -> _0 
let (uu___is_Caption : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | Caption _0 -> true | uu____1764 -> false
  
let (__proj__Caption__item___0 : decl -> Prims.string) =
  fun projectee  -> match projectee with | Caption _0 -> _0 
let (uu___is_Eval : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | Eval _0 -> true | uu____1787 -> false
  
let (__proj__Eval__item___0 : decl -> term) =
  fun projectee  -> match projectee with | Eval _0 -> _0 
let (uu___is_Echo : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | Echo _0 -> true | uu____1808 -> false
  
let (__proj__Echo__item___0 : decl -> Prims.string) =
  fun projectee  -> match projectee with | Echo _0 -> _0 
let (uu___is_RetainAssumptions : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | RetainAssumptions _0 -> true | uu____1834 -> false
  
let (__proj__RetainAssumptions__item___0 : decl -> Prims.string Prims.list) =
  fun projectee  -> match projectee with | RetainAssumptions _0 -> _0 
let (uu___is_Push : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | Push  -> true | uu____1862 -> false
  
let (uu___is_Pop : decl -> Prims.bool) =
  fun projectee  -> match projectee with | Pop  -> true | uu____1873 -> false 
let (uu___is_CheckSat : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | CheckSat  -> true | uu____1884 -> false
  
let (uu___is_GetUnsatCore : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | GetUnsatCore  -> true | uu____1895 -> false
  
let (uu___is_SetOption : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | SetOption _0 -> true | uu____1913 -> false
  
let (__proj__SetOption__item___0 :
  decl -> (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2) =
  fun projectee  -> match projectee with | SetOption _0 -> _0 
let (uu___is_GetStatistics : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | GetStatistics  -> true | uu____1950 -> false
  
let (uu___is_GetReasonUnknown : decl -> Prims.bool) =
  fun projectee  ->
    match projectee with | GetReasonUnknown  -> true | uu____1961 -> false
  
type decls_t = decl Prims.list
type error_label =
  (fv,Prims.string,FStar_Range.range) FStar_Pervasives_Native.tuple3
type error_labels = error_label Prims.list
let (fv_eq : fv -> fv -> Prims.bool) =
  fun x  ->
    fun y  ->
      (FStar_Pervasives_Native.fst x) = (FStar_Pervasives_Native.fst y)
  
let fv_sort :
  'Auu____1996 'Auu____1997 .
    ('Auu____1996,'Auu____1997) FStar_Pervasives_Native.tuple2 ->
      'Auu____1997
  = fun x  -> FStar_Pervasives_Native.snd x 
let (freevar_eq : term -> term -> Prims.bool) =
  fun x  ->
    fun y  ->
      match ((x.tm), (y.tm)) with
      | (FreeV x1,FreeV y1) -> fv_eq x1 y1
      | uu____2036 -> false
  
let (freevar_sort : term -> sort) =
  fun uu___119_2047  ->
    match uu___119_2047 with
    | { tm = FreeV x; freevars = uu____2049; rng = uu____2050;_} -> fv_sort x
    | uu____2066 -> failwith "impossible"
  
let (fv_of_term : term -> fv) =
  fun uu___120_2073  ->
    match uu___120_2073 with
    | { tm = FreeV fv; freevars = uu____2075; rng = uu____2076;_} -> fv
    | uu____2091 -> failwith "impossible"
  
let rec (freevars :
  term -> (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list) =
  fun t  ->
    match t.tm with
    | Integer uu____2113 -> []
    | BoundV uu____2120 -> []
    | FreeV fv -> [fv]
    | App (uu____2143,tms) -> FStar_List.collect freevars tms
    | Quant (uu____2154,uu____2155,uu____2156,uu____2157,t1) -> freevars t1
    | Labeled (t1,uu____2178,uu____2179) -> freevars t1
    | LblPos (t1,uu____2183) -> freevars t1
    | Let (es,body) -> FStar_List.collect freevars (body :: es)
  
let (free_variables : term -> fvs) =
  fun t  ->
    let uu____2203 = FStar_ST.op_Bang t.freevars  in
    match uu____2203 with
    | FStar_Pervasives_Native.Some b -> b
    | FStar_Pervasives_Native.None  ->
        let fvs =
          let uu____2280 = freevars t  in
          FStar_Util.remove_dups fv_eq uu____2280  in
        (FStar_ST.op_Colon_Equals t.freevars
           (FStar_Pervasives_Native.Some fvs);
         fvs)
  
let (qop_to_string : qop -> Prims.string) =
  fun uu___121_2344  ->
    match uu___121_2344 with | Forall  -> "forall" | Exists  -> "exists"
  
let (op_to_string : op -> Prims.string) =
  fun uu___122_2354  ->
    match uu___122_2354 with
    | TrueOp  -> "true"
    | FalseOp  -> "false"
    | Not  -> "not"
    | And  -> "and"
    | Or  -> "or"
    | Imp  -> "implies"
    | Iff  -> "iff"
    | Eq  -> "="
    | LT  -> "<"
    | LTE  -> "<="
    | GT  -> ">"
    | GTE  -> ">="
    | Add  -> "+"
    | Sub  -> "-"
    | Div  -> "div"
    | Mul  -> "*"
    | Minus  -> "-"
    | Mod  -> "mod"
    | ITE  -> "ite"
    | BvAnd  -> "bvand"
    | BvXor  -> "bvxor"
    | BvOr  -> "bvor"
    | BvAdd  -> "bvadd"
    | BvSub  -> "bvsub"
    | BvShl  -> "bvshl"
    | BvShr  -> "bvlshr"
    | BvUdiv  -> "bvudiv"
    | BvMod  -> "bvurem"
    | BvMul  -> "bvmul"
    | BvUlt  -> "bvult"
    | BvToNat  -> "bv2int"
    | BvUext n1 ->
        let uu____2389 = FStar_Util.string_of_int n1  in
        FStar_Util.format1 "(_ zero_extend %s)" uu____2389
    | NatToBv n1 ->
        let uu____2394 = FStar_Util.string_of_int n1  in
        FStar_Util.format1 "(_ int2bv %s)" uu____2394
    | Var s -> s
  
let (weightToSmt : Prims.int FStar_Pervasives_Native.option -> Prims.string)
  =
  fun uu___123_2408  ->
    match uu___123_2408 with
    | FStar_Pervasives_Native.None  -> ""
    | FStar_Pervasives_Native.Some i ->
        let uu____2418 = FStar_Util.string_of_int i  in
        FStar_Util.format1 ":weight %s\n" uu____2418
  
let rec (hash_of_term' : term' -> Prims.string) =
  fun t  ->
    match t with
    | Integer i -> i
    | BoundV i ->
        let uu____2438 = FStar_Util.string_of_int i  in
        Prims.strcat "@" uu____2438
    | FreeV x ->
        let uu____2447 =
          let uu____2449 = strSort (FStar_Pervasives_Native.snd x)  in
          Prims.strcat ":" uu____2449  in
        Prims.strcat (FStar_Pervasives_Native.fst x) uu____2447
    | App (op,tms) ->
        let uu____2460 =
          let uu____2462 = op_to_string op  in
          let uu____2464 =
            let uu____2466 =
              let uu____2468 = FStar_List.map hash_of_term tms  in
              FStar_All.pipe_right uu____2468 (FStar_String.concat " ")  in
            Prims.strcat uu____2466 ")"  in
          Prims.strcat uu____2462 uu____2464  in
        Prims.strcat "(" uu____2460
    | Labeled (t1,r1,r2) ->
        let uu____2485 = hash_of_term t1  in
        let uu____2487 =
          let uu____2489 = FStar_Range.string_of_range r2  in
          Prims.strcat r1 uu____2489  in
        Prims.strcat uu____2485 uu____2487
    | LblPos (t1,r) ->
        let uu____2495 =
          let uu____2497 = hash_of_term t1  in
          Prims.strcat uu____2497
            (Prims.strcat " :lblpos " (Prims.strcat r ")"))
           in
        Prims.strcat "(! " uu____2495
    | Quant (qop,pats,wopt,sorts,body) ->
        let uu____2525 =
          let uu____2527 =
            let uu____2529 =
              let uu____2531 =
                let uu____2533 = FStar_List.map strSort sorts  in
                FStar_All.pipe_right uu____2533 (FStar_String.concat " ")  in
              let uu____2543 =
                let uu____2545 =
                  let uu____2547 = hash_of_term body  in
                  let uu____2549 =
                    let uu____2551 =
                      let uu____2553 = weightToSmt wopt  in
                      let uu____2555 =
                        let uu____2557 =
                          let uu____2559 =
                            let uu____2561 =
                              FStar_All.pipe_right pats
                                (FStar_List.map
                                   (fun pats1  ->
                                      let uu____2580 =
                                        FStar_List.map hash_of_term pats1  in
                                      FStar_All.pipe_right uu____2580
                                        (FStar_String.concat " ")))
                               in
                            FStar_All.pipe_right uu____2561
                              (FStar_String.concat "; ")
                             in
                          Prims.strcat uu____2559 "))"  in
                        Prims.strcat " " uu____2557  in
                      Prims.strcat uu____2553 uu____2555  in
                    Prims.strcat " " uu____2551  in
                  Prims.strcat uu____2547 uu____2549  in
                Prims.strcat ")(! " uu____2545  in
              Prims.strcat uu____2531 uu____2543  in
            Prims.strcat " (" uu____2529  in
          Prims.strcat (qop_to_string qop) uu____2527  in
        Prims.strcat "(" uu____2525
    | Let (es,body) ->
        let uu____2607 =
          let uu____2609 =
            let uu____2611 = FStar_List.map hash_of_term es  in
            FStar_All.pipe_right uu____2611 (FStar_String.concat " ")  in
          let uu____2621 =
            let uu____2623 =
              let uu____2625 = hash_of_term body  in
              Prims.strcat uu____2625 ")"  in
            Prims.strcat ") " uu____2623  in
          Prims.strcat uu____2609 uu____2621  in
        Prims.strcat "(let (" uu____2607

and (hash_of_term : term -> Prims.string) = fun tm  -> hash_of_term' tm.tm

let (mkBoxFunctions :
  Prims.string -> (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2)
  = fun s  -> (s, (Prims.strcat s "_proj_0")) 
let (boxIntFun : (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2)
  = mkBoxFunctions "BoxInt" 
let (boxBoolFun : (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2)
  = mkBoxFunctions "BoxBool" 
let (boxStringFun :
  (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2) =
  mkBoxFunctions "BoxString" 
let (boxBitVecFun :
  Prims.int -> (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2) =
  fun sz  ->
    let uu____2686 =
      let uu____2688 = FStar_Util.string_of_int sz  in
      Prims.strcat "BoxBitVec" uu____2688  in
    mkBoxFunctions uu____2686
  
let (isInjective : Prims.string -> Prims.bool) =
  fun s  ->
    if (FStar_String.length s) >= (Prims.parse_int "3")
    then
      (let uu____2705 =
         FStar_String.substring s (Prims.parse_int "0") (Prims.parse_int "3")
          in
       uu____2705 = "Box") &&
        (let uu____2712 =
           let uu____2714 = FStar_String.list_of_string s  in
           FStar_List.existsML (fun c  -> c = 46) uu____2714  in
         Prims.op_Negation uu____2712)
    else false
  
let (mk : term' -> FStar_Range.range -> term) =
  fun t  ->
    fun r  ->
      let uu____2738 = FStar_Util.mk_ref FStar_Pervasives_Native.None  in
      { tm = t; freevars = uu____2738; rng = r }
  
let (mkTrue : FStar_Range.range -> term) = fun r  -> mk (App (TrueOp, [])) r 
let (mkFalse : FStar_Range.range -> term) =
  fun r  -> mk (App (FalseOp, [])) r 
let (mkInteger : Prims.string -> FStar_Range.range -> term) =
  fun i  ->
    fun r  ->
      let uu____2815 =
        let uu____2816 = FStar_Util.ensure_decimal i  in Integer uu____2816
         in
      mk uu____2815 r
  
let (mkInteger' : Prims.int -> FStar_Range.range -> term) =
  fun i  ->
    fun r  ->
      let uu____2831 = FStar_Util.string_of_int i  in mkInteger uu____2831 r
  
let (mkBoundV : Prims.int -> FStar_Range.range -> term) =
  fun i  -> fun r  -> mk (BoundV i) r 
let (mkFreeV :
  (Prims.string,sort) FStar_Pervasives_Native.tuple2 ->
    FStar_Range.range -> term)
  = fun x  -> fun r  -> mk (FreeV x) r 
let (mkApp' :
  (op,term Prims.list) FStar_Pervasives_Native.tuple2 ->
    FStar_Range.range -> term)
  = fun f  -> fun r  -> mk (App f) r 
let (mkApp :
  (Prims.string,term Prims.list) FStar_Pervasives_Native.tuple2 ->
    FStar_Range.range -> term)
  =
  fun uu____2906  ->
    fun r  -> match uu____2906 with | (s,args) -> mk (App ((Var s), args)) r
  
let (mkNot : term -> FStar_Range.range -> term) =
  fun t  ->
    fun r  ->
      match t.tm with
      | App (TrueOp ,uu____2936) -> mkFalse r
      | App (FalseOp ,uu____2941) -> mkTrue r
      | uu____2946 -> mkApp' (Not, [t]) r
  
let (mkAnd :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  fun uu____2962  ->
    fun r  ->
      match uu____2962 with
      | (t1,t2) ->
          (match ((t1.tm), (t2.tm)) with
           | (App (TrueOp ,uu____2970),uu____2971) -> t2
           | (uu____2976,App (TrueOp ,uu____2977)) -> t1
           | (App (FalseOp ,uu____2982),uu____2983) -> mkFalse r
           | (uu____2988,App (FalseOp ,uu____2989)) -> mkFalse r
           | (App (And ,ts1),App (And ,ts2)) ->
               mkApp' (And, (FStar_List.append ts1 ts2)) r
           | (uu____3006,App (And ,ts2)) -> mkApp' (And, (t1 :: ts2)) r
           | (App (And ,ts1),uu____3015) ->
               mkApp' (And, (FStar_List.append ts1 [t2])) r
           | uu____3022 -> mkApp' (And, [t1; t2]) r)
  
let (mkOr :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  fun uu____3042  ->
    fun r  ->
      match uu____3042 with
      | (t1,t2) ->
          (match ((t1.tm), (t2.tm)) with
           | (App (TrueOp ,uu____3050),uu____3051) -> mkTrue r
           | (uu____3056,App (TrueOp ,uu____3057)) -> mkTrue r
           | (App (FalseOp ,uu____3062),uu____3063) -> t2
           | (uu____3068,App (FalseOp ,uu____3069)) -> t1
           | (App (Or ,ts1),App (Or ,ts2)) ->
               mkApp' (Or, (FStar_List.append ts1 ts2)) r
           | (uu____3086,App (Or ,ts2)) -> mkApp' (Or, (t1 :: ts2)) r
           | (App (Or ,ts1),uu____3095) ->
               mkApp' (Or, (FStar_List.append ts1 [t2])) r
           | uu____3102 -> mkApp' (Or, [t1; t2]) r)
  
let (mkImp :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  fun uu____3122  ->
    fun r  ->
      match uu____3122 with
      | (t1,t2) ->
          (match ((t1.tm), (t2.tm)) with
           | (uu____3130,App (TrueOp ,uu____3131)) -> mkTrue r
           | (App (FalseOp ,uu____3136),uu____3137) -> mkTrue r
           | (App (TrueOp ,uu____3142),uu____3143) -> t2
           | (uu____3148,App (Imp ,t1'::t2'::[])) ->
               let uu____3153 =
                 let uu____3160 =
                   let uu____3163 = mkAnd (t1, t1') r  in [uu____3163; t2']
                    in
                 (Imp, uu____3160)  in
               mkApp' uu____3153 r
           | uu____3166 -> mkApp' (Imp, [t1; t2]) r)
  
let (mk_bin_op :
  op ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term)
  =
  fun op  ->
    fun uu____3191  ->
      fun r  -> match uu____3191 with | (t1,t2) -> mkApp' (op, [t1; t2]) r
  
let (mkMinus : term -> FStar_Range.range -> term) =
  fun t  -> fun r  -> mkApp' (Minus, [t]) r 
let (mkNatToBv : Prims.int -> term -> FStar_Range.range -> term) =
  fun sz  -> fun t  -> fun r  -> mkApp' ((NatToBv sz), [t]) r 
let (mkBvUext : Prims.int -> term -> FStar_Range.range -> term) =
  fun sz  -> fun t  -> fun r  -> mkApp' ((BvUext sz), [t]) r 
let (mkBvToNat : term -> FStar_Range.range -> term) =
  fun t  -> fun r  -> mkApp' (BvToNat, [t]) r 
let (mkBvAnd :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op BvAnd 
let (mkBvXor :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op BvXor 
let (mkBvOr :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op BvOr 
let (mkBvAdd :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op BvAdd 
let (mkBvSub :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op BvSub 
let (mkBvShl :
  Prims.int ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term)
  =
  fun sz  ->
    fun uu____3351  ->
      fun r  ->
        match uu____3351 with
        | (t1,t2) ->
            let uu____3360 =
              let uu____3367 =
                let uu____3370 =
                  let uu____3373 = mkNatToBv sz t2 r  in [uu____3373]  in
                t1 :: uu____3370  in
              (BvShl, uu____3367)  in
            mkApp' uu____3360 r
  
let (mkBvShr :
  Prims.int ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term)
  =
  fun sz  ->
    fun uu____3395  ->
      fun r  ->
        match uu____3395 with
        | (t1,t2) ->
            let uu____3404 =
              let uu____3411 =
                let uu____3414 =
                  let uu____3417 = mkNatToBv sz t2 r  in [uu____3417]  in
                t1 :: uu____3414  in
              (BvShr, uu____3411)  in
            mkApp' uu____3404 r
  
let (mkBvUdiv :
  Prims.int ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term)
  =
  fun sz  ->
    fun uu____3439  ->
      fun r  ->
        match uu____3439 with
        | (t1,t2) ->
            let uu____3448 =
              let uu____3455 =
                let uu____3458 =
                  let uu____3461 = mkNatToBv sz t2 r  in [uu____3461]  in
                t1 :: uu____3458  in
              (BvUdiv, uu____3455)  in
            mkApp' uu____3448 r
  
let (mkBvMod :
  Prims.int ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term)
  =
  fun sz  ->
    fun uu____3483  ->
      fun r  ->
        match uu____3483 with
        | (t1,t2) ->
            let uu____3492 =
              let uu____3499 =
                let uu____3502 =
                  let uu____3505 = mkNatToBv sz t2 r  in [uu____3505]  in
                t1 :: uu____3502  in
              (BvMod, uu____3499)  in
            mkApp' uu____3492 r
  
let (mkBvMul :
  Prims.int ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term)
  =
  fun sz  ->
    fun uu____3527  ->
      fun r  ->
        match uu____3527 with
        | (t1,t2) ->
            let uu____3536 =
              let uu____3543 =
                let uu____3546 =
                  let uu____3549 = mkNatToBv sz t2 r  in [uu____3549]  in
                t1 :: uu____3546  in
              (BvMul, uu____3543)  in
            mkApp' uu____3536 r
  
let (mkBvUlt :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op BvUlt 
let (mkIff :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op Iff 
let (mkEq :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  fun uu____3591  ->
    fun r  ->
      match uu____3591 with
      | (t1,t2) ->
          (match ((t1.tm), (t2.tm)) with
           | (App (Var f1,s1::[]),App (Var f2,s2::[])) when
               (f1 = f2) && (isInjective f1) -> mk_bin_op Eq (s1, s2) r
           | uu____3610 -> mk_bin_op Eq (t1, t2) r)
  
let (mkLT :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op LT 
let (mkLTE :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op LTE 
let (mkGT :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op GT 
let (mkGTE :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op GTE 
let (mkAdd :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op Add 
let (mkSub :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op Sub 
let (mkDiv :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op Div 
let (mkMul :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op Mul 
let (mkMod :
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term) =
  mk_bin_op Mod 
let (mkITE :
  (term,term,term) FStar_Pervasives_Native.tuple3 ->
    FStar_Range.range -> term)
  =
  fun uu____3747  ->
    fun r  ->
      match uu____3747 with
      | (t1,t2,t3) ->
          (match t1.tm with
           | App (TrueOp ,uu____3758) -> t2
           | App (FalseOp ,uu____3763) -> t3
           | uu____3768 ->
               (match ((t2.tm), (t3.tm)) with
                | (App (TrueOp ,uu____3769),App (TrueOp ,uu____3770)) ->
                    mkTrue r
                | (App (TrueOp ,uu____3779),uu____3780) ->
                    let uu____3785 =
                      let uu____3790 = mkNot t1 t1.rng  in (uu____3790, t3)
                       in
                    mkImp uu____3785 r
                | (uu____3791,App (TrueOp ,uu____3792)) -> mkImp (t1, t2) r
                | (uu____3797,uu____3798) -> mkApp' (ITE, [t1; t2; t3]) r))
  
let (mkCases : term Prims.list -> FStar_Range.range -> term) =
  fun t  ->
    fun r  ->
      match t with
      | [] -> failwith "Impos"
      | hd1::tl1 ->
          FStar_List.fold_left (fun out  -> fun t1  -> mkAnd (out, t1) r) hd1
            tl1
  
let (check_pattern_ok : term -> term FStar_Pervasives_Native.option) =
  fun t  ->
    let rec aux t1 =
      match t1.tm with
      | Integer uu____3854 -> FStar_Pervasives_Native.None
      | BoundV uu____3856 -> FStar_Pervasives_Native.None
      | FreeV uu____3858 -> FStar_Pervasives_Native.None
      | Let (tms,tm) -> aux_l (tm :: tms)
      | App (head1,terms) ->
          let head_ok =
            match head1 with
            | Var uu____3879 -> true
            | TrueOp  -> true
            | FalseOp  -> true
            | Not  -> false
            | And  -> false
            | Or  -> false
            | Imp  -> false
            | Iff  -> false
            | Eq  -> false
            | LT  -> true
            | LTE  -> true
            | GT  -> true
            | GTE  -> true
            | Add  -> true
            | Sub  -> true
            | Div  -> true
            | Mul  -> true
            | Minus  -> true
            | Mod  -> true
            | BvAnd  -> false
            | BvXor  -> false
            | BvOr  -> false
            | BvAdd  -> false
            | BvSub  -> false
            | BvShl  -> false
            | BvShr  -> false
            | BvUdiv  -> false
            | BvMod  -> false
            | BvMul  -> false
            | BvUlt  -> false
            | BvUext uu____3911 -> false
            | NatToBv uu____3914 -> false
            | BvToNat  -> false
            | ITE  -> false  in
          if Prims.op_Negation head_ok
          then FStar_Pervasives_Native.Some t1
          else aux_l terms
      | Labeled (t2,uu____3925,uu____3926) -> aux t2
      | Quant uu____3929 -> FStar_Pervasives_Native.Some t1
      | LblPos uu____3949 -> FStar_Pervasives_Native.Some t1
    
    and aux_l ts =
      match ts with
      | [] -> FStar_Pervasives_Native.None
      | t1::ts1 ->
          let uu____3964 = aux t1  in
          (match uu____3964 with
           | FStar_Pervasives_Native.Some t2 ->
               FStar_Pervasives_Native.Some t2
           | FStar_Pervasives_Native.None  -> aux_l ts1)
     in aux t
  
let rec (print_smt_term : term -> Prims.string) =
  fun t  ->
    match t.tm with
    | Integer n1 -> FStar_Util.format1 "(Integer %s)" n1
    | BoundV n1 ->
        let uu____3999 = FStar_Util.string_of_int n1  in
        FStar_Util.format1 "(BoundV %s)" uu____3999
    | FreeV fv ->
        FStar_Util.format1 "(FreeV %s)" (FStar_Pervasives_Native.fst fv)
    | App (op,l) ->
        let uu____4016 = op_to_string op  in
        let uu____4018 = print_smt_term_list l  in
        FStar_Util.format2 "(%s %s)" uu____4016 uu____4018
    | Labeled (t1,r1,r2) ->
        let uu____4026 = print_smt_term t1  in
        FStar_Util.format2 "(Labeled '%s' %s)" r1 uu____4026
    | LblPos (t1,s) ->
        let uu____4033 = print_smt_term t1  in
        FStar_Util.format2 "(LblPos %s %s)" s uu____4033
    | Quant (qop,l,uu____4038,uu____4039,t1) ->
        let uu____4059 = print_smt_term_list_list l  in
        let uu____4061 = print_smt_term t1  in
        FStar_Util.format3 "(%s %s %s)" (qop_to_string qop) uu____4059
          uu____4061
    | Let (es,body) ->
        let uu____4070 = print_smt_term_list es  in
        let uu____4072 = print_smt_term body  in
        FStar_Util.format2 "(let %s %s)" uu____4070 uu____4072

and (print_smt_term_list : term Prims.list -> Prims.string) =
  fun l  ->
    let uu____4079 = FStar_List.map print_smt_term l  in
    FStar_All.pipe_right uu____4079 (FStar_String.concat " ")

and (print_smt_term_list_list : term Prims.list Prims.list -> Prims.string) =
  fun l  ->
    FStar_List.fold_left
      (fun s  ->
         fun l1  ->
           let uu____4106 =
             let uu____4108 =
               let uu____4110 = print_smt_term_list l1  in
               Prims.strcat uu____4110 " ] "  in
             Prims.strcat "; [ " uu____4108  in
           Prims.strcat s uu____4106) "" l

let (mkQuant :
  FStar_Range.range ->
    Prims.bool ->
      (qop,term Prims.list Prims.list,Prims.int
                                        FStar_Pervasives_Native.option,
        sort Prims.list,term) FStar_Pervasives_Native.tuple5 -> term)
  =
  fun r  ->
    fun check_pats  ->
      fun uu____4150  ->
        match uu____4150 with
        | (qop,pats,wopt,vars,body) ->
            let all_pats_ok pats1 =
              if Prims.op_Negation check_pats
              then pats1
              else
                (let uu____4219 =
                   FStar_Util.find_map pats1
                     (fun x  -> FStar_Util.find_map x check_pattern_ok)
                    in
                 match uu____4219 with
                 | FStar_Pervasives_Native.None  -> pats1
                 | FStar_Pervasives_Native.Some p ->
                     ((let uu____4234 =
                         let uu____4240 =
                           let uu____4242 = print_smt_term p  in
                           FStar_Util.format1
                             "Pattern (%s) contains illegal symbols; dropping it"
                             uu____4242
                            in
                         (FStar_Errors.Warning_SMTPatternMissingBoundVar,
                           uu____4240)
                          in
                       FStar_Errors.log_issue r uu____4234);
                      []))
               in
            if (FStar_List.length vars) = (Prims.parse_int "0")
            then body
            else
              (match body.tm with
               | App (TrueOp ,uu____4253) -> body
               | uu____4258 ->
                   let uu____4259 =
                     let uu____4260 =
                       let uu____4280 = all_pats_ok pats  in
                       (qop, uu____4280, wopt, vars, body)  in
                     Quant uu____4260  in
                   mk uu____4259 r)
  
let (mkLet :
  (term Prims.list,term) FStar_Pervasives_Native.tuple2 ->
    FStar_Range.range -> term)
  =
  fun uu____4309  ->
    fun r  ->
      match uu____4309 with
      | (es,body) ->
          if (FStar_List.length es) = (Prims.parse_int "0")
          then body
          else mk (Let (es, body)) r
  
let (abstr : fv Prims.list -> term -> term) =
  fun fvs  ->
    fun t  ->
      let nvars = FStar_List.length fvs  in
      let index_of1 fv =
        let uu____4355 = FStar_Util.try_find_index (fv_eq fv) fvs  in
        match uu____4355 with
        | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
        | FStar_Pervasives_Native.Some i ->
            FStar_Pervasives_Native.Some
              (nvars - (i + (Prims.parse_int "1")))
         in
      let rec aux ix t1 =
        let uu____4388 = FStar_ST.op_Bang t1.freevars  in
        match uu____4388 with
        | FStar_Pervasives_Native.Some [] -> t1
        | uu____4447 ->
            (match t1.tm with
             | Integer uu____4457 -> t1
             | BoundV uu____4459 -> t1
             | FreeV x ->
                 let uu____4467 = index_of1 x  in
                 (match uu____4467 with
                  | FStar_Pervasives_Native.None  -> t1
                  | FStar_Pervasives_Native.Some i ->
                      mkBoundV (i + ix) t1.rng)
             | App (op,tms) ->
                 let uu____4481 =
                   let uu____4488 = FStar_List.map (aux ix) tms  in
                   (op, uu____4488)  in
                 mkApp' uu____4481 t1.rng
             | Labeled (t2,r1,r2) ->
                 let uu____4498 =
                   let uu____4499 =
                     let uu____4507 = aux ix t2  in (uu____4507, r1, r2)  in
                   Labeled uu____4499  in
                 mk uu____4498 t2.rng
             | LblPos (t2,r) ->
                 let uu____4513 =
                   let uu____4514 =
                     let uu____4520 = aux ix t2  in (uu____4520, r)  in
                   LblPos uu____4514  in
                 mk uu____4513 t2.rng
             | Quant (qop,pats,wopt,vars,body) ->
                 let n1 = FStar_List.length vars  in
                 let uu____4546 =
                   let uu____4566 =
                     FStar_All.pipe_right pats
                       (FStar_List.map (FStar_List.map (aux (ix + n1))))
                      in
                   let uu____4587 = aux (ix + n1) body  in
                   (qop, uu____4566, wopt, vars, uu____4587)  in
                 mkQuant t1.rng false uu____4546
             | Let (es,body) ->
                 let uu____4608 =
                   FStar_List.fold_left
                     (fun uu____4628  ->
                        fun e  ->
                          match uu____4628 with
                          | (ix1,l) ->
                              let uu____4652 =
                                let uu____4655 = aux ix1 e  in uu____4655 ::
                                  l
                                 in
                              ((ix1 + (Prims.parse_int "1")), uu____4652))
                     (ix, []) es
                    in
                 (match uu____4608 with
                  | (ix1,es_rev) ->
                      let uu____4671 =
                        let uu____4678 = aux ix1 body  in
                        ((FStar_List.rev es_rev), uu____4678)  in
                      mkLet uu____4671 t1.rng))
         in
      aux (Prims.parse_int "0") t
  
let (inst : term Prims.list -> term -> term) =
  fun tms  ->
    fun t  ->
      let tms1 = FStar_List.rev tms  in
      let n1 = FStar_List.length tms1  in
      let rec aux shift t1 =
        match t1.tm with
        | Integer uu____4714 -> t1
        | FreeV uu____4716 -> t1
        | BoundV i ->
            if ((Prims.parse_int "0") <= (i - shift)) && ((i - shift) < n1)
            then FStar_List.nth tms1 (i - shift)
            else t1
        | App (op,tms2) ->
            let uu____4738 =
              let uu____4745 = FStar_List.map (aux shift) tms2  in
              (op, uu____4745)  in
            mkApp' uu____4738 t1.rng
        | Labeled (t2,r1,r2) ->
            let uu____4755 =
              let uu____4756 =
                let uu____4764 = aux shift t2  in (uu____4764, r1, r2)  in
              Labeled uu____4756  in
            mk uu____4755 t2.rng
        | LblPos (t2,r) ->
            let uu____4770 =
              let uu____4771 =
                let uu____4777 = aux shift t2  in (uu____4777, r)  in
              LblPos uu____4771  in
            mk uu____4770 t2.rng
        | Quant (qop,pats,wopt,vars,body) ->
            let m = FStar_List.length vars  in
            let shift1 = shift + m  in
            let uu____4809 =
              let uu____4829 =
                FStar_All.pipe_right pats
                  (FStar_List.map (FStar_List.map (aux shift1)))
                 in
              let uu____4846 = aux shift1 body  in
              (qop, uu____4829, wopt, vars, uu____4846)  in
            mkQuant t1.rng false uu____4809
        | Let (es,body) ->
            let uu____4863 =
              FStar_List.fold_left
                (fun uu____4883  ->
                   fun e  ->
                     match uu____4883 with
                     | (ix,es1) ->
                         let uu____4907 =
                           let uu____4910 = aux shift e  in uu____4910 :: es1
                            in
                         ((shift + (Prims.parse_int "1")), uu____4907))
                (shift, []) es
               in
            (match uu____4863 with
             | (shift1,es_rev) ->
                 let uu____4926 =
                   let uu____4933 = aux shift1 body  in
                   ((FStar_List.rev es_rev), uu____4933)  in
                 mkLet uu____4926 t1.rng)
         in
      aux (Prims.parse_int "0") t
  
let (subst : term -> fv -> term -> term) =
  fun t  ->
    fun fv  ->
      fun s  -> let uu____4953 = abstr [fv] t  in inst [s] uu____4953
  
let (mkQuant' :
  FStar_Range.range ->
    (qop,term Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
      fv Prims.list,term) FStar_Pervasives_Native.tuple5 -> term)
  =
  fun r  ->
    fun uu____4983  ->
      match uu____4983 with
      | (qop,pats,wopt,vars,body) ->
          let uu____5026 =
            let uu____5046 =
              FStar_All.pipe_right pats
                (FStar_List.map (FStar_List.map (abstr vars)))
               in
            let uu____5063 = FStar_List.map fv_sort vars  in
            let uu____5067 = abstr vars body  in
            (qop, uu____5046, wopt, uu____5063, uu____5067)  in
          mkQuant r true uu____5026
  
let (mkForall :
  FStar_Range.range ->
    (pat Prims.list Prims.list,fvs,term) FStar_Pervasives_Native.tuple3 ->
      term)
  =
  fun r  ->
    fun uu____5098  ->
      match uu____5098 with
      | (pats,vars,body) ->
          mkQuant' r (Forall, pats, FStar_Pervasives_Native.None, vars, body)
  
let (mkForall'' :
  FStar_Range.range ->
    (pat Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
      sort Prims.list,term) FStar_Pervasives_Native.tuple4 -> term)
  =
  fun r  ->
    fun uu____5157  ->
      match uu____5157 with
      | (pats,wopt,sorts,body) ->
          mkQuant r true (Forall, pats, wopt, sorts, body)
  
let (mkForall' :
  FStar_Range.range ->
    (pat Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
      fvs,term) FStar_Pervasives_Native.tuple4 -> term)
  =
  fun r  ->
    fun uu____5232  ->
      match uu____5232 with
      | (pats,wopt,vars,body) -> mkQuant' r (Forall, pats, wopt, vars, body)
  
let (mkExists :
  FStar_Range.range ->
    (pat Prims.list Prims.list,fvs,term) FStar_Pervasives_Native.tuple3 ->
      term)
  =
  fun r  ->
    fun uu____5295  ->
      match uu____5295 with
      | (pats,vars,body) ->
          mkQuant' r (Exists, pats, FStar_Pervasives_Native.None, vars, body)
  
let (mkLet' :
  ((fv,term) FStar_Pervasives_Native.tuple2 Prims.list,term)
    FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term)
  =
  fun uu____5346  ->
    fun r  ->
      match uu____5346 with
      | (bindings,body) ->
          let uu____5372 = FStar_List.split bindings  in
          (match uu____5372 with
           | (vars,es) ->
               let uu____5391 =
                 let uu____5398 = abstr vars body  in (es, uu____5398)  in
               mkLet uu____5391 r)
  
let (norng : FStar_Range.range) = FStar_Range.dummyRange 
let (mkDefineFun :
  (Prims.string,fv Prims.list,sort,term,caption)
    FStar_Pervasives_Native.tuple5 -> decl)
  =
  fun uu____5420  ->
    match uu____5420 with
    | (nm,vars,s,tm,c) ->
        let uu____5445 =
          let uu____5459 = FStar_List.map fv_sort vars  in
          let uu____5463 = abstr vars tm  in
          (nm, uu____5459, s, uu____5463, c)  in
        DefineFun uu____5445
  
let (constr_id_of_sort : sort -> Prims.string) =
  fun sort  ->
    let uu____5474 = strSort sort  in
    FStar_Util.format1 "%s_constr_id" uu____5474
  
let (fresh_token :
  (Prims.string,sort) FStar_Pervasives_Native.tuple2 -> Prims.int -> decl) =
  fun uu____5492  ->
    fun id1  ->
      match uu____5492 with
      | (tok_name,sort) ->
          let a_name = Prims.strcat "fresh_token_" tok_name  in
          let a =
            let uu____5508 =
              let uu____5509 =
                let uu____5514 = mkInteger' id1 norng  in
                let uu____5515 =
                  let uu____5516 =
                    let uu____5524 = constr_id_of_sort sort  in
                    let uu____5526 =
                      let uu____5529 = mkApp (tok_name, []) norng  in
                      [uu____5529]  in
                    (uu____5524, uu____5526)  in
                  mkApp uu____5516 norng  in
                (uu____5514, uu____5515)  in
              mkEq uu____5509 norng  in
            let uu____5536 = escape a_name  in
            {
              assumption_term = uu____5508;
              assumption_caption =
                (FStar_Pervasives_Native.Some "fresh token");
              assumption_name = uu____5536;
              assumption_fact_ids = []
            }  in
          Assume a
  
let (fresh_constructor :
  FStar_Range.range ->
    (Prims.string,sort Prims.list,sort,Prims.int)
      FStar_Pervasives_Native.tuple4 -> decl)
  =
  fun rng  ->
    fun uu____5562  ->
      match uu____5562 with
      | (name,arg_sorts,sort,id1) ->
          let id2 = FStar_Util.string_of_int id1  in
          let bvars =
            FStar_All.pipe_right arg_sorts
              (FStar_List.mapi
                 (fun i  ->
                    fun s  ->
                      let uu____5602 =
                        let uu____5608 =
                          let uu____5610 = FStar_Util.string_of_int i  in
                          Prims.strcat "x_" uu____5610  in
                        (uu____5608, s)  in
                      mkFreeV uu____5602 norng))
             in
          let bvar_names = FStar_List.map fv_of_term bvars  in
          let capp = mkApp (name, bvars) norng  in
          let cid_app =
            let uu____5632 =
              let uu____5640 = constr_id_of_sort sort  in
              (uu____5640, [capp])  in
            mkApp uu____5632 norng  in
          let a_name = Prims.strcat "constructor_distinct_" name  in
          let a =
            let uu____5649 =
              let uu____5650 =
                let uu____5661 =
                  let uu____5662 =
                    let uu____5667 = mkInteger id2 norng  in
                    (uu____5667, cid_app)  in
                  mkEq uu____5662 norng  in
                ([[capp]], bvar_names, uu____5661)  in
              mkForall rng uu____5650  in
            let uu____5676 = escape a_name  in
            {
              assumption_term = uu____5649;
              assumption_caption =
                (FStar_Pervasives_Native.Some "Constructor distinct");
              assumption_name = uu____5676;
              assumption_fact_ids = []
            }  in
          Assume a
  
let (injective_constructor :
  FStar_Range.range ->
    (Prims.string,constructor_field Prims.list,sort)
      FStar_Pervasives_Native.tuple3 -> decls_t)
  =
  fun rng  ->
    fun uu____5699  ->
      match uu____5699 with
      | (name,fields,sort) ->
          let n_bvars = FStar_List.length fields  in
          let bvar_name i =
            let uu____5728 = FStar_Util.string_of_int i  in
            Prims.strcat "x_" uu____5728  in
          let bvar_index i = n_bvars - (i + (Prims.parse_int "1"))  in
          let bvar i s =
            let uu____5763 = let uu____5769 = bvar_name i  in (uu____5769, s)
               in
            mkFreeV uu____5763  in
          let bvars =
            FStar_All.pipe_right fields
              (FStar_List.mapi
                 (fun i  ->
                    fun uu____5802  ->
                      match uu____5802 with
                      | (uu____5812,s,uu____5814) ->
                          let uu____5819 = bvar i s  in uu____5819 norng))
             in
          let bvar_names = FStar_List.map fv_of_term bvars  in
          let capp = mkApp (name, bvars) norng  in
          let uu____5841 =
            FStar_All.pipe_right fields
              (FStar_List.mapi
                 (fun i  ->
                    fun uu____5879  ->
                      match uu____5879 with
                      | (name1,s,projectible) ->
                          let cproj_app = mkApp (name1, [capp]) norng  in
                          let proj_name =
                            DeclFun
                              (name1, [sort], s,
                                (FStar_Pervasives_Native.Some "Projector"))
                             in
                          if projectible
                          then
                            let a =
                              let uu____5912 =
                                let uu____5913 =
                                  let uu____5924 =
                                    let uu____5925 =
                                      let uu____5930 =
                                        let uu____5931 = bvar i s  in
                                        uu____5931 norng  in
                                      (cproj_app, uu____5930)  in
                                    mkEq uu____5925 norng  in
                                  ([[capp]], bvar_names, uu____5924)  in
                                mkForall rng uu____5913  in
                              let uu____5944 =
                                escape
                                  (Prims.strcat "projection_inverse_" name1)
                                 in
                              {
                                assumption_term = uu____5912;
                                assumption_caption =
                                  (FStar_Pervasives_Native.Some
                                     "Projection inverse");
                                assumption_name = uu____5944;
                                assumption_fact_ids = []
                              }  in
                            [proj_name; Assume a]
                          else [proj_name]))
             in
          FStar_All.pipe_right uu____5841 FStar_List.flatten
  
let (constructor_to_decl : FStar_Range.range -> constructor_t -> decls_t) =
  fun rng  ->
    fun uu____5965  ->
      match uu____5965 with
      | (name,fields,sort,id1,injective) ->
          let injective1 = injective || true  in
          let field_sorts =
            FStar_All.pipe_right fields
              (FStar_List.map
                 (fun uu____6011  ->
                    match uu____6011 with
                    | (uu____6020,sort1,uu____6022) -> sort1))
             in
          let cdecl =
            DeclFun
              (name, field_sorts, sort,
                (FStar_Pervasives_Native.Some "Constructor"))
             in
          let cid = fresh_constructor rng (name, field_sorts, sort, id1)  in
          let disc =
            let disc_name = Prims.strcat "is-" name  in
            let xfv = ("x", sort)  in
            let xx = mkFreeV xfv norng  in
            let disc_eq =
              let uu____6052 =
                let uu____6057 =
                  let uu____6058 =
                    let uu____6066 = constr_id_of_sort sort  in
                    (uu____6066, [xx])  in
                  mkApp uu____6058 norng  in
                let uu____6071 =
                  let uu____6072 = FStar_Util.string_of_int id1  in
                  mkInteger uu____6072 norng  in
                (uu____6057, uu____6071)  in
              mkEq uu____6052 norng  in
            let uu____6074 =
              let uu____6090 =
                FStar_All.pipe_right fields
                  (FStar_List.mapi
                     (fun i  ->
                        fun uu____6153  ->
                          match uu____6153 with
                          | (proj,s,projectible) ->
                              if projectible
                              then
                                let uu____6193 = mkApp (proj, [xx]) norng  in
                                (uu____6193, [])
                              else
                                (let fi =
                                   let uu____6217 =
                                     let uu____6219 =
                                       FStar_Util.string_of_int i  in
                                     Prims.strcat "f_" uu____6219  in
                                   (uu____6217, s)  in
                                 let uu____6223 = mkFreeV fi norng  in
                                 (uu____6223, [fi]))))
                 in
              FStar_All.pipe_right uu____6090 FStar_List.split  in
            match uu____6074 with
            | (proj_terms,ex_vars) ->
                let ex_vars1 = FStar_List.flatten ex_vars  in
                let disc_inv_body =
                  let uu____6314 =
                    let uu____6319 = mkApp (name, proj_terms) norng  in
                    (xx, uu____6319)  in
                  mkEq uu____6314 norng  in
                let disc_inv_body1 =
                  match ex_vars1 with
                  | [] -> disc_inv_body
                  | uu____6329 ->
                      mkExists norng ([], ex_vars1, disc_inv_body)
                   in
                let disc_ax = mkAnd (disc_eq, disc_inv_body1) norng  in
                let def =
                  mkDefineFun
                    (disc_name, [xfv], Bool_sort, disc_ax,
                      (FStar_Pervasives_Native.Some
                         "Discriminator definition"))
                   in
                def
             in
          let projs =
            if injective1
            then injective_constructor rng (name, fields, sort)
            else []  in
          let uu____6361 =
            let uu____6364 =
              let uu____6365 =
                FStar_Util.format1 "<start constructor %s>" name  in
              Caption uu____6365  in
            uu____6364 :: cdecl :: cid :: projs  in
          let uu____6368 =
            let uu____6371 =
              let uu____6374 =
                let uu____6375 =
                  FStar_Util.format1 "</end constructor %s>" name  in
                Caption uu____6375  in
              [uu____6374]  in
            FStar_List.append [disc] uu____6371  in
          FStar_List.append uu____6361 uu____6368
  
let (name_binders_inner :
  Prims.string FStar_Pervasives_Native.option ->
    (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list ->
      Prims.int ->
        sort Prims.list ->
          ((Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list,
            Prims.string Prims.list,Prims.int) FStar_Pervasives_Native.tuple3)
  =
  fun prefix_opt  ->
    fun outer_names  ->
      fun start  ->
        fun sorts  ->
          let uu____6442 =
            FStar_All.pipe_right sorts
              (FStar_List.fold_left
                 (fun uu____6506  ->
                    fun s  ->
                      match uu____6506 with
                      | (names1,binders,n1) ->
                          let prefix1 =
                            match s with
                            | Term_sort  -> "@x"
                            | uu____6571 -> "@u"  in
                          let prefix2 =
                            match prefix_opt with
                            | FStar_Pervasives_Native.None  -> prefix1
                            | FStar_Pervasives_Native.Some p ->
                                Prims.strcat p prefix1
                             in
                          let nm =
                            let uu____6582 = FStar_Util.string_of_int n1  in
                            Prims.strcat prefix2 uu____6582  in
                          let names2 = (nm, s) :: names1  in
                          let b =
                            let uu____6600 = strSort s  in
                            FStar_Util.format2 "(%s %s)" nm uu____6600  in
                          (names2, (b :: binders),
                            (n1 + (Prims.parse_int "1"))))
                 (outer_names, [], start))
             in
          match uu____6442 with
          | (names1,binders,n1) -> (names1, (FStar_List.rev binders), n1)
  
let (name_macro_binders :
  sort Prims.list ->
    ((Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list,Prims.string
                                                                    Prims.list)
      FStar_Pervasives_Native.tuple2)
  =
  fun sorts  ->
    let uu____6706 =
      name_binders_inner (FStar_Pervasives_Native.Some "__") []
        (Prims.parse_int "0") sorts
       in
    match uu____6706 with
    | (names1,binders,n1) -> ((FStar_List.rev names1), binders)
  
let (termToSmt : Prims.bool -> Prims.string -> term -> Prims.string) =
  fun print_ranges  ->
    fun enclosing_name  ->
      fun t  ->
        let next_qid =
          let ctr = FStar_Util.mk_ref (Prims.parse_int "0")  in
          fun depth  ->
            let n1 = FStar_ST.op_Bang ctr  in
            FStar_Util.incr ctr;
            if n1 = (Prims.parse_int "0")
            then enclosing_name
            else
              (let uu____6905 = FStar_Util.string_of_int n1  in
               FStar_Util.format2 "%s.%s" enclosing_name uu____6905)
           in
        let remove_guard_free pats =
          FStar_All.pipe_right pats
            (FStar_List.map
               (fun ps  ->
                  FStar_All.pipe_right ps
                    (FStar_List.map
                       (fun tm  ->
                          match tm.tm with
                          | App
                              (Var
                               "Prims.guard_free",{ tm = BoundV uu____6951;
                                                    freevars = uu____6952;
                                                    rng = uu____6953;_}::[])
                              -> tm
                          | App (Var "Prims.guard_free",p::[]) -> p
                          | uu____6971 -> tm))))
           in
        let rec aux' depth n1 names1 t1 =
          let aux1 = aux (depth + (Prims.parse_int "1"))  in
          match t1.tm with
          | Integer i -> i
          | BoundV i ->
              let uu____7047 = FStar_List.nth names1 i  in
              FStar_All.pipe_right uu____7047 FStar_Pervasives_Native.fst
          | FreeV x -> FStar_Pervasives_Native.fst x
          | App (op,[]) -> op_to_string op
          | App (op,tms) ->
              let uu____7076 = op_to_string op  in
              let uu____7078 =
                let uu____7080 = FStar_List.map (aux1 n1 names1) tms  in
                FStar_All.pipe_right uu____7080 (FStar_String.concat "\n")
                 in
              FStar_Util.format2 "(%s %s)" uu____7076 uu____7078
          | Labeled (t2,uu____7092,uu____7093) -> aux1 n1 names1 t2
          | LblPos (t2,s) ->
              let uu____7100 = aux1 n1 names1 t2  in
              FStar_Util.format2 "(! %s :lblpos %s)" uu____7100 s
          | Quant (qop,pats,wopt,sorts,body) ->
              let qid = next_qid ()  in
              let uu____7128 =
                name_binders_inner FStar_Pervasives_Native.None names1 n1
                  sorts
                 in
              (match uu____7128 with
               | (names2,binders,n2) ->
                   let binders1 =
                     FStar_All.pipe_right binders (FStar_String.concat " ")
                      in
                   let pats1 = remove_guard_free pats  in
                   let pats_str =
                     match pats1 with
                     | []::[] -> ";;no pats"
                     | [] -> ";;no pats"
                     | uu____7196 ->
                         let uu____7201 =
                           FStar_All.pipe_right pats1
                             (FStar_List.map
                                (fun pats2  ->
                                   let uu____7220 =
                                     let uu____7222 =
                                       FStar_List.map
                                         (fun p  ->
                                            let uu____7230 = aux1 n2 names2 p
                                               in
                                            FStar_Util.format1 "%s"
                                              uu____7230) pats2
                                        in
                                     FStar_String.concat " " uu____7222  in
                                   FStar_Util.format1 "\n:pattern (%s)"
                                     uu____7220))
                            in
                         FStar_All.pipe_right uu____7201
                           (FStar_String.concat "\n")
                      in
                   let uu____7240 =
                     let uu____7244 =
                       let uu____7248 =
                         let uu____7252 = aux1 n2 names2 body  in
                         let uu____7254 =
                           let uu____7258 = weightToSmt wopt  in
                           [uu____7258; pats_str; qid]  in
                         uu____7252 :: uu____7254  in
                       binders1 :: uu____7248  in
                     (qop_to_string qop) :: uu____7244  in
                   FStar_Util.format "(%s (%s)\n (! %s\n %s\n%s\n:qid %s))"
                     uu____7240)
          | Let (es,body) ->
              let uu____7274 =
                FStar_List.fold_left
                  (fun uu____7317  ->
                     fun e  ->
                       match uu____7317 with
                       | (names0,binders,n0) ->
                           let nm =
                             let uu____7380 = FStar_Util.string_of_int n0  in
                             Prims.strcat "@lb" uu____7380  in
                           let names01 = (nm, Term_sort) :: names0  in
                           let b =
                             let uu____7399 = aux1 n1 names1 e  in
                             FStar_Util.format2 "(%s %s)" nm uu____7399  in
                           (names01, (b :: binders),
                             (n0 + (Prims.parse_int "1")))) (names1, [], n1)
                  es
                 in
              (match uu____7274 with
               | (names2,binders,n2) ->
                   let uu____7453 = aux1 n2 names2 body  in
                   FStar_Util.format2 "(let (%s)\n%s)"
                     (FStar_String.concat " " binders) uu____7453)
        
        and aux depth n1 names1 t1 =
          let s = aux' depth n1 names1 t1  in
          if print_ranges && (t1.rng <> norng)
          then
            let uu____7469 = FStar_Range.string_of_range t1.rng  in
            let uu____7471 = FStar_Range.string_of_use_range t1.rng  in
            FStar_Util.format3 "\n;; def=%s; use=%s\n%s\n" uu____7469
              uu____7471 s
          else s
         in aux (Prims.parse_int "0") (Prims.parse_int "0") [] t
  
let (caption_to_string :
  Prims.string FStar_Pervasives_Native.option -> Prims.string) =
  fun uu___124_7487  ->
    match uu___124_7487 with
    | FStar_Pervasives_Native.None  -> ""
    | FStar_Pervasives_Native.Some c ->
        let c1 =
          let uu____7499 =
            FStar_All.pipe_right (FStar_String.split [10] c)
              (FStar_List.map FStar_Util.trim_string)
             in
          FStar_All.pipe_right uu____7499 (FStar_String.concat " ")  in
        Prims.strcat ";;;;;;;;;;;;;;;;" (Prims.strcat c1 "\n")
  
let rec (declToSmt' : Prims.bool -> Prims.string -> decl -> Prims.string) =
  fun print_ranges  ->
    fun z3options  ->
      fun decl  ->
        match decl with
        | DefPrelude  -> mkPrelude z3options
        | Caption c ->
            let uu____7571 = FStar_Options.log_queries ()  in
            if uu____7571
            then
              let uu____7575 =
                let uu____7577 =
                  FStar_All.pipe_right (FStar_Util.splitlines c)
                    (FStar_List.map
                       (fun s  -> Prims.strcat "; " (Prims.strcat s "\n")))
                   in
                FStar_All.pipe_right uu____7577 (FStar_String.concat "")  in
              Prims.strcat "\n" uu____7575
            else ""
        | DeclFun (f,argsorts,retsort,c) ->
            let l = FStar_List.map strSort argsorts  in
            let uu____7618 = caption_to_string c  in
            let uu____7620 = strSort retsort  in
            FStar_Util.format4 "%s(declare-fun %s (%s) %s)" uu____7618 f
              (FStar_String.concat " " l) uu____7620
        | DefineFun (f,arg_sorts,retsort,body,c) ->
            let uu____7635 = name_macro_binders arg_sorts  in
            (match uu____7635 with
             | (names1,binders) ->
                 let body1 =
                   let uu____7674 =
                     FStar_List.map (fun x  -> mkFreeV x norng) names1  in
                   inst uu____7674 body  in
                 let uu____7689 = caption_to_string c  in
                 let uu____7691 = strSort retsort  in
                 let uu____7693 =
                   let uu____7695 = escape f  in
                   termToSmt print_ranges uu____7695 body1  in
                 FStar_Util.format5 "%s(define-fun %s (%s) %s\n %s)"
                   uu____7689 f (FStar_String.concat " " binders) uu____7691
                   uu____7693)
        | Assume a ->
            let fact_ids_to_string ids =
              FStar_All.pipe_right ids
                (FStar_List.map
                   (fun uu___125_7722  ->
                      match uu___125_7722 with
                      | Name n1 ->
                          let uu____7725 = FStar_Ident.text_of_lid n1  in
                          Prims.strcat "Name " uu____7725
                      | Namespace ns ->
                          let uu____7729 = FStar_Ident.text_of_lid ns  in
                          Prims.strcat "Namespace " uu____7729
                      | Tag t -> Prims.strcat "Tag " t))
               in
            let fids =
              let uu____7737 = FStar_Options.log_queries ()  in
              if uu____7737
              then
                let uu____7741 =
                  let uu____7743 = fact_ids_to_string a.assumption_fact_ids
                     in
                  FStar_String.concat "; " uu____7743  in
                FStar_Util.format1 ";;; Fact-ids: %s\n" uu____7741
              else ""  in
            let n1 = a.assumption_name  in
            let uu____7754 = caption_to_string a.assumption_caption  in
            let uu____7756 = termToSmt print_ranges n1 a.assumption_term  in
            FStar_Util.format4 "%s%s(assert (! %s\n:named %s))" uu____7754
              fids uu____7756 n1
        | Eval t ->
            let uu____7760 = termToSmt print_ranges "eval" t  in
            FStar_Util.format1 "(eval %s)" uu____7760
        | Echo s -> FStar_Util.format1 "(echo \"%s\")" s
        | RetainAssumptions uu____7767 -> ""
        | CheckSat  ->
            "(echo \"<result>\")\n(check-sat)\n(echo \"</result>\")"
        | GetUnsatCore  ->
            "(echo \"<unsat-core>\")\n(get-unsat-core)\n(echo \"</unsat-core>\")"
        | Push  -> "(push)"
        | Pop  -> "(pop)"
        | SetOption (s,v1) -> FStar_Util.format2 "(set-option :%s %s)" s v1
        | GetStatistics  ->
            "(echo \"<statistics>\")\n(get-info :all-statistics)\n(echo \"</statistics>\")"
        | GetReasonUnknown  ->
            "(echo \"<reason-unknown>\")\n(get-info :reason-unknown)\n(echo \"</reason-unknown>\")"

and (declToSmt : Prims.string -> decl -> Prims.string) =
  fun z3options  -> fun decl  -> declToSmt' true z3options decl

and (declToSmt_no_caps : Prims.string -> decl -> Prims.string) =
  fun z3options  -> fun decl  -> declToSmt' false z3options decl

and (mkPrelude : Prims.string -> Prims.string) =
  fun z3options  ->
    let basic =
      Prims.strcat z3options
        "(declare-sort FString)\n(declare-fun FString_constr_id (FString) Int)\n\n(declare-sort Term)\n(declare-fun Term_constr_id (Term) Int)\n(declare-datatypes () ((Fuel \n(ZFuel) \n(SFuel (prec Fuel)))))\n(declare-fun MaxIFuel () Fuel)\n(declare-fun MaxFuel () Fuel)\n(declare-fun PreType (Term) Term)\n(declare-fun Valid (Term) Bool)\n(declare-fun HasTypeFuel (Fuel Term Term) Bool)\n(define-fun HasTypeZ ((x Term) (t Term)) Bool\n(HasTypeFuel ZFuel x t))\n(define-fun HasType ((x Term) (t Term)) Bool\n(HasTypeFuel MaxIFuel x t))\n;;fuel irrelevance\n(assert (forall ((f Fuel) (x Term) (t Term))\n(! (= (HasTypeFuel (SFuel f) x t)\n(HasTypeZ x t))\n:pattern ((HasTypeFuel (SFuel f) x t)))))\n(declare-fun NoHoist (Term Bool) Bool)\n;;no-hoist\n(assert (forall ((dummy Term) (b Bool))\n(! (= (NoHoist dummy b)\nb)\n:pattern ((NoHoist dummy b)))))\n(define-fun  IsTyped ((x Term)) Bool\n(exists ((t Term)) (HasTypeZ x t)))\n(declare-fun ApplyTF (Term Fuel) Term)\n(declare-fun ApplyTT (Term Term) Term)\n(declare-fun Rank (Term) Int)\n(declare-fun Closure (Term) Term)\n(declare-fun ConsTerm (Term Term) Term)\n(declare-fun ConsFuel (Fuel Term) Term)\n(declare-fun Tm_uvar (Int) Term)\n(define-fun Reify ((x Term)) Term x)\n(assert (forall ((t Term))\n(! (iff (exists ((e Term)) (HasType e t))\n(Valid t))\n:pattern ((Valid t)))))\n(declare-fun Prims.precedes (Term Term Term Term) Term)\n(declare-fun Range_const (Int) Term)\n(declare-fun _mul (Int Int) Int)\n(declare-fun _div (Int Int) Int)\n(declare-fun _mod (Int Int) Int)\n(declare-fun __uu__PartialApp () Term)\n(assert (forall ((x Int) (y Int)) (! (= (_mul x y) (* x y)) :pattern ((_mul x y)))))\n(assert (forall ((x Int) (y Int)) (! (= (_div x y) (div x y)) :pattern ((_div x y)))))\n(assert (forall ((x Int) (y Int)) (! (= (_mod x y) (mod x y)) :pattern ((_mod x y)))))"
       in
    let constrs =
      [("FString_const", [("FString_const_proj_0", Int_sort, true)],
         String_sort, (Prims.parse_int "0"), true);
      ("Tm_type", [], Term_sort, (Prims.parse_int "2"), true);
      ("Tm_arrow", [("Tm_arrow_id", Int_sort, true)], Term_sort,
        (Prims.parse_int "3"), false);
      ("Tm_unit", [], Term_sort, (Prims.parse_int "6"), true);
      ((FStar_Pervasives_Native.fst boxIntFun),
        [((FStar_Pervasives_Native.snd boxIntFun), Int_sort, true)],
        Term_sort, (Prims.parse_int "7"), true);
      ((FStar_Pervasives_Native.fst boxBoolFun),
        [((FStar_Pervasives_Native.snd boxBoolFun), Bool_sort, true)],
        Term_sort, (Prims.parse_int "8"), true);
      ((FStar_Pervasives_Native.fst boxStringFun),
        [((FStar_Pervasives_Native.snd boxStringFun), String_sort, true)],
        Term_sort, (Prims.parse_int "9"), true);
      ("LexCons",
        [("LexCons_0", Term_sort, true);
        ("LexCons_1", Term_sort, true);
        ("LexCons_2", Term_sort, true)], Term_sort, (Prims.parse_int "11"),
        true)]
       in
    let bcons =
      let uu____7903 =
        let uu____7907 =
          FStar_All.pipe_right constrs
            (FStar_List.collect (constructor_to_decl norng))
           in
        FStar_All.pipe_right uu____7907
          (FStar_List.map (declToSmt z3options))
         in
      FStar_All.pipe_right uu____7903 (FStar_String.concat "\n")  in
    let lex_ordering =
      "\n(define-fun is-Prims.LexCons ((t Term)) Bool \n(is-LexCons t))\n(declare-fun Prims.lex_t () Term)\n(assert (forall ((t1 Term) (t2 Term) (x1 Term) (x2 Term) (y1 Term) (y2 Term))\n(iff (Valid (Prims.precedes Prims.lex_t Prims.lex_t (LexCons t1 x1 x2) (LexCons t2 y1 y2)))\n(or (Valid (Prims.precedes t1 t2 x1 y1))\n(and (= x1 y1)\n(Valid (Prims.precedes Prims.lex_t Prims.lex_t x2 y2)))))))\n(assert (forall ((t1 Term) (t2 Term) (e1 Term) (e2 Term))\n(! (iff (Valid (Prims.precedes t1 t2 e1 e2))\n(Valid (Prims.precedes Prims.lex_t Prims.lex_t e1 e2)))\n:pattern (Prims.precedes t1 t2 e1 e2))))\n(assert (forall ((t1 Term) (t2 Term))\n(! (iff (Valid (Prims.precedes Prims.lex_t Prims.lex_t t1 t2)) \n(< (Rank t1) (Rank t2)))\n:pattern ((Prims.precedes Prims.lex_t Prims.lex_t t1 t2)))))\n"
       in
    Prims.strcat basic (Prims.strcat bcons lex_ordering)

let (mkBvConstructor : Prims.int -> decls_t) =
  fun sz  ->
    let uu____7936 =
      let uu____7937 =
        let uu____7939 = boxBitVecFun sz  in
        FStar_Pervasives_Native.fst uu____7939  in
      let uu____7948 =
        let uu____7951 =
          let uu____7952 =
            let uu____7954 = boxBitVecFun sz  in
            FStar_Pervasives_Native.snd uu____7954  in
          (uu____7952, (BitVec_sort sz), true)  in
        [uu____7951]  in
      (uu____7937, uu____7948, Term_sort, ((Prims.parse_int "12") + sz),
        true)
       in
    FStar_All.pipe_right uu____7936 (constructor_to_decl norng)
  
let (__range_c : Prims.int FStar_ST.ref) =
  FStar_Util.mk_ref (Prims.parse_int "0") 
let (mk_Range_const : unit -> term) =
  fun uu____7995  ->
    let i = FStar_ST.op_Bang __range_c  in
    (let uu____8020 =
       let uu____8022 = FStar_ST.op_Bang __range_c  in
       uu____8022 + (Prims.parse_int "1")  in
     FStar_ST.op_Colon_Equals __range_c uu____8020);
    (let uu____8067 =
       let uu____8075 = let uu____8078 = mkInteger' i norng  in [uu____8078]
          in
       ("Range_const", uu____8075)  in
     mkApp uu____8067 norng)
  
let (mk_Term_type : term) = mkApp ("Tm_type", []) norng 
let (mk_Term_app : term -> term -> FStar_Range.range -> term) =
  fun t1  -> fun t2  -> fun r  -> mkApp ("Tm_app", [t1; t2]) r 
let (mk_Term_uvar : Prims.int -> FStar_Range.range -> term) =
  fun i  ->
    fun r  ->
      let uu____8121 =
        let uu____8129 = let uu____8132 = mkInteger' i norng  in [uu____8132]
           in
        ("Tm_uvar", uu____8129)  in
      mkApp uu____8121 r
  
let (mk_Term_unit : term) = mkApp ("Tm_unit", []) norng 
let (elim_box : Prims.bool -> Prims.string -> Prims.string -> term -> term) =
  fun cond  ->
    fun u  ->
      fun v1  ->
        fun t  ->
          match t.tm with
          | App (Var v',t1::[]) when (v1 = v') && cond -> t1
          | uu____8175 -> mkApp (u, [t]) t.rng
  
let (maybe_elim_box : Prims.string -> Prims.string -> term -> term) =
  fun u  ->
    fun v1  ->
      fun t  ->
        let uu____8199 = FStar_Options.smtencoding_elim_box ()  in
        elim_box uu____8199 u v1 t
  
let (boxInt : term -> term) =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.fst boxIntFun)
      (FStar_Pervasives_Native.snd boxIntFun) t
  
let (unboxInt : term -> term) =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.snd boxIntFun)
      (FStar_Pervasives_Native.fst boxIntFun) t
  
let (boxBool : term -> term) =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.fst boxBoolFun)
      (FStar_Pervasives_Native.snd boxBoolFun) t
  
let (unboxBool : term -> term) =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.snd boxBoolFun)
      (FStar_Pervasives_Native.fst boxBoolFun) t
  
let (boxString : term -> term) =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.fst boxStringFun)
      (FStar_Pervasives_Native.snd boxStringFun) t
  
let (unboxString : term -> term) =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.snd boxStringFun)
      (FStar_Pervasives_Native.fst boxStringFun) t
  
let (boxBitVec : Prims.int -> term -> term) =
  fun sz  ->
    fun t  ->
      let uu____8274 =
        let uu____8276 = boxBitVecFun sz  in
        FStar_Pervasives_Native.fst uu____8276  in
      let uu____8285 =
        let uu____8287 = boxBitVecFun sz  in
        FStar_Pervasives_Native.snd uu____8287  in
      elim_box true uu____8274 uu____8285 t
  
let (unboxBitVec : Prims.int -> term -> term) =
  fun sz  ->
    fun t  ->
      let uu____8310 =
        let uu____8312 = boxBitVecFun sz  in
        FStar_Pervasives_Native.snd uu____8312  in
      let uu____8321 =
        let uu____8323 = boxBitVecFun sz  in
        FStar_Pervasives_Native.fst uu____8323  in
      elim_box true uu____8310 uu____8321 t
  
let (boxTerm : sort -> term -> term) =
  fun sort  ->
    fun t  ->
      match sort with
      | Int_sort  -> boxInt t
      | Bool_sort  -> boxBool t
      | String_sort  -> boxString t
      | BitVec_sort sz -> boxBitVec sz t
      | uu____8346 -> FStar_Exn.raise FStar_Util.Impos
  
let (unboxTerm : sort -> term -> term) =
  fun sort  ->
    fun t  ->
      match sort with
      | Int_sort  -> unboxInt t
      | Bool_sort  -> unboxBool t
      | String_sort  -> unboxString t
      | BitVec_sort sz -> unboxBitVec sz t
      | uu____8360 -> FStar_Exn.raise FStar_Util.Impos
  
let (getBoxedInteger : term -> Prims.int FStar_Pervasives_Native.option) =
  fun t  ->
    match t.tm with
    | App (Var s,t2::[]) when s = (FStar_Pervasives_Native.fst boxIntFun) ->
        (match t2.tm with
         | Integer n1 ->
             let uu____8386 = FStar_Util.int_of_string n1  in
             FStar_Pervasives_Native.Some uu____8386
         | uu____8389 -> FStar_Pervasives_Native.None)
    | uu____8391 -> FStar_Pervasives_Native.None
  
let (mk_PreType : term -> term) = fun t  -> mkApp ("PreType", [t]) t.rng 
let (mk_Valid : term -> term) =
  fun t  ->
    match t.tm with
    | App
        (Var
         "Prims.b2t",{
                       tm = App
                         (Var "Prims.op_Equality",uu____8409::t1::t2::[]);
                       freevars = uu____8412; rng = uu____8413;_}::[])
        -> mkEq (t1, t2) t.rng
    | App
        (Var
         "Prims.b2t",{
                       tm = App
                         (Var "Prims.op_disEquality",uu____8429::t1::t2::[]);
                       freevars = uu____8432; rng = uu____8433;_}::[])
        -> let uu____8449 = mkEq (t1, t2) norng  in mkNot uu____8449 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_LessThanOrEqual",t1::t2::[]);
                       freevars = uu____8452; rng = uu____8453;_}::[])
        ->
        let uu____8469 =
          let uu____8474 = unboxInt t1  in
          let uu____8475 = unboxInt t2  in (uu____8474, uu____8475)  in
        mkLTE uu____8469 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_LessThan",t1::t2::[]);
                       freevars = uu____8478; rng = uu____8479;_}::[])
        ->
        let uu____8495 =
          let uu____8500 = unboxInt t1  in
          let uu____8501 = unboxInt t2  in (uu____8500, uu____8501)  in
        mkLT uu____8495 t.rng
    | App
        (Var
         "Prims.b2t",{
                       tm = App
                         (Var "Prims.op_GreaterThanOrEqual",t1::t2::[]);
                       freevars = uu____8504; rng = uu____8505;_}::[])
        ->
        let uu____8521 =
          let uu____8526 = unboxInt t1  in
          let uu____8527 = unboxInt t2  in (uu____8526, uu____8527)  in
        mkGTE uu____8521 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_GreaterThan",t1::t2::[]);
                       freevars = uu____8530; rng = uu____8531;_}::[])
        ->
        let uu____8547 =
          let uu____8552 = unboxInt t1  in
          let uu____8553 = unboxInt t2  in (uu____8552, uu____8553)  in
        mkGT uu____8547 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_AmpAmp",t1::t2::[]);
                       freevars = uu____8556; rng = uu____8557;_}::[])
        ->
        let uu____8573 =
          let uu____8578 = unboxBool t1  in
          let uu____8579 = unboxBool t2  in (uu____8578, uu____8579)  in
        mkAnd uu____8573 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_BarBar",t1::t2::[]);
                       freevars = uu____8582; rng = uu____8583;_}::[])
        ->
        let uu____8599 =
          let uu____8604 = unboxBool t1  in
          let uu____8605 = unboxBool t2  in (uu____8604, uu____8605)  in
        mkOr uu____8599 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_Negation",t1::[]);
                       freevars = uu____8607; rng = uu____8608;_}::[])
        -> let uu____8624 = unboxBool t1  in mkNot uu____8624 t1.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "FStar.BV.bvult",t0::t1::t2::[]);
                       freevars = uu____8628; rng = uu____8629;_}::[])
        when
        let uu____8645 = getBoxedInteger t0  in FStar_Util.is_some uu____8645
        ->
        let sz =
          let uu____8652 = getBoxedInteger t0  in
          match uu____8652 with
          | FStar_Pervasives_Native.Some sz -> sz
          | uu____8660 -> failwith "impossible"  in
        let uu____8666 =
          let uu____8671 = unboxBitVec sz t1  in
          let uu____8672 = unboxBitVec sz t2  in (uu____8671, uu____8672)  in
        mkBvUlt uu____8666 t.rng
    | App
        (Var
         "Prims.equals",uu____8673::{
                                      tm = App
                                        (Var "FStar.BV.bvult",t0::t1::t2::[]);
                                      freevars = uu____8677;
                                      rng = uu____8678;_}::uu____8679::[])
        when
        let uu____8695 = getBoxedInteger t0  in FStar_Util.is_some uu____8695
        ->
        let sz =
          let uu____8702 = getBoxedInteger t0  in
          match uu____8702 with
          | FStar_Pervasives_Native.Some sz -> sz
          | uu____8710 -> failwith "impossible"  in
        let uu____8716 =
          let uu____8721 = unboxBitVec sz t1  in
          let uu____8722 = unboxBitVec sz t2  in (uu____8721, uu____8722)  in
        mkBvUlt uu____8716 t.rng
    | App (Var "Prims.b2t",t1::[]) ->
        let uu___126_8727 = unboxBool t1  in
        {
          tm = (uu___126_8727.tm);
          freevars = (uu___126_8727.freevars);
          rng = (t.rng)
        }
    | uu____8728 -> mkApp ("Valid", [t]) t.rng
  
let (mk_HasType : term -> term -> term) =
  fun v1  -> fun t  -> mkApp ("HasType", [v1; t]) t.rng 
let (mk_HasTypeZ : term -> term -> term) =
  fun v1  -> fun t  -> mkApp ("HasTypeZ", [v1; t]) t.rng 
let (mk_IsTyped : term -> term) = fun v1  -> mkApp ("IsTyped", [v1]) norng 
let (mk_HasTypeFuel : term -> term -> term -> term) =
  fun f  ->
    fun v1  ->
      fun t  ->
        let uu____8789 = FStar_Options.unthrottle_inductives ()  in
        if uu____8789
        then mk_HasType v1 t
        else mkApp ("HasTypeFuel", [f; v1; t]) t.rng
  
let (mk_HasTypeWithFuel :
  term FStar_Pervasives_Native.option -> term -> term -> term) =
  fun f  ->
    fun v1  ->
      fun t  ->
        match f with
        | FStar_Pervasives_Native.None  -> mk_HasType v1 t
        | FStar_Pervasives_Native.Some f1 -> mk_HasTypeFuel f1 v1 t
  
let (mk_NoHoist : term -> term -> term) =
  fun dummy  -> fun b  -> mkApp ("NoHoist", [dummy; b]) b.rng 
let (mk_Destruct : term -> FStar_Range.range -> term) =
  fun v1  -> mkApp ("Destruct", [v1]) 
let (mk_Rank : term -> FStar_Range.range -> term) =
  fun x  -> mkApp ("Rank", [x]) 
let (mk_tester : Prims.string -> term -> term) =
  fun n1  -> fun t  -> mkApp ((Prims.strcat "is-" n1), [t]) t.rng 
let (mk_ApplyTF : term -> term -> term) =
  fun t  -> fun t'  -> mkApp ("ApplyTF", [t; t']) t.rng 
let (mk_ApplyTT : term -> term -> FStar_Range.range -> term) =
  fun t  -> fun t'  -> fun r  -> mkApp ("ApplyTT", [t; t']) r 
let (kick_partial_app : term -> term) =
  fun t  ->
    let uu____8922 =
      let uu____8923 = mkApp ("__uu__PartialApp", []) t.rng  in
      mk_ApplyTT uu____8923 t t.rng  in
    FStar_All.pipe_right uu____8922 mk_Valid
  
let (mk_String_const : Prims.int -> FStar_Range.range -> term) =
  fun i  ->
    fun r  ->
      let uu____8941 =
        let uu____8949 = let uu____8952 = mkInteger' i norng  in [uu____8952]
           in
        ("FString_const", uu____8949)  in
      mkApp uu____8941 r
  
let (mk_Precedes : term -> term -> term -> term -> FStar_Range.range -> term)
  =
  fun x1  ->
    fun x2  ->
      fun x3  ->
        fun x4  ->
          fun r  ->
            let uu____8983 = mkApp ("Prims.precedes", [x1; x2; x3; x4]) r  in
            FStar_All.pipe_right uu____8983 mk_Valid
  
let (mk_LexCons : term -> term -> term -> FStar_Range.range -> term) =
  fun x1  ->
    fun x2  -> fun x3  -> fun r  -> mkApp ("LexCons", [x1; x2; x3]) r
  
let rec (n_fuel : Prims.int -> term) =
  fun n1  ->
    if n1 = (Prims.parse_int "0")
    then mkApp ("ZFuel", []) norng
    else
      (let uu____9030 =
         let uu____9038 =
           let uu____9041 = n_fuel (n1 - (Prims.parse_int "1"))  in
           [uu____9041]  in
         ("SFuel", uu____9038)  in
       mkApp uu____9030 norng)
  
let (fuel_2 : term) = n_fuel (Prims.parse_int "2") 
let (fuel_100 : term) = n_fuel (Prims.parse_int "100") 
let (mk_and_opt :
  term FStar_Pervasives_Native.option ->
    term FStar_Pervasives_Native.option ->
      FStar_Range.range -> term FStar_Pervasives_Native.option)
  =
  fun p1  ->
    fun p2  ->
      fun r  ->
        match (p1, p2) with
        | (FStar_Pervasives_Native.Some p11,FStar_Pervasives_Native.Some p21)
            ->
            let uu____9089 = mkAnd (p11, p21) r  in
            FStar_Pervasives_Native.Some uu____9089
        | (FStar_Pervasives_Native.Some p,FStar_Pervasives_Native.None ) ->
            FStar_Pervasives_Native.Some p
        | (FStar_Pervasives_Native.None ,FStar_Pervasives_Native.Some p) ->
            FStar_Pervasives_Native.Some p
        | (FStar_Pervasives_Native.None ,FStar_Pervasives_Native.None ) ->
            FStar_Pervasives_Native.None
  
let (mk_and_opt_l :
  term FStar_Pervasives_Native.option Prims.list ->
    FStar_Range.range -> term FStar_Pervasives_Native.option)
  =
  fun pl  ->
    fun r  ->
      FStar_List.fold_right (fun p  -> fun out  -> mk_and_opt p out r) pl
        FStar_Pervasives_Native.None
  
let (mk_and_l : term Prims.list -> FStar_Range.range -> term) =
  fun l  ->
    fun r  ->
      let uu____9152 = mkTrue r  in
      FStar_List.fold_right (fun p1  -> fun p2  -> mkAnd (p1, p2) r) l
        uu____9152
  
let (mk_or_l : term Prims.list -> FStar_Range.range -> term) =
  fun l  ->
    fun r  ->
      let uu____9172 = mkFalse r  in
      FStar_List.fold_right (fun p1  -> fun p2  -> mkOr (p1, p2) r) l
        uu____9172
  
let (mk_haseq : term -> term) =
  fun t  ->
    let uu____9183 = mkApp ("Prims.hasEq", [t]) t.rng  in mk_Valid uu____9183
  