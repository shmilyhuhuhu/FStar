module LowStar.BufferCompat
include LowStar.Buffer

module HS = FStar.HyperStack
module HST = FStar.HyperStack.ST
module U32 = FStar.UInt32
module G = FStar.Ghost
module Seq = FStar.Seq

unfold
let rcreate_post_mem_common
  (#a: Type)
  (r: HS.rid)
  (len: nat)
  (b: buffer a)
  (h0 h1: HS.mem)
  (s:Seq.seq a)
= alloc_post_mem_common b h0 h1 s /\ frameOf b == r /\ length b == len

inline_for_extraction
let rfree
  (#a: Type)
  (b: buffer a)
: HST.ST unit
  (requires (fun h0 -> live h0 b /\ freeable b))
  (ensures (fun h0 _ h1 ->
    (not (g_is_null b)) /\
    Map.domain (HS.get_hmap h1) `Set.equal` Map.domain (HS.get_hmap h0) /\ 
    (HS.get_tip h1) == (HS.get_tip h0) /\
    modifies (loc_addr_of_buffer b) h0 h1 /\
    HS.live_region h1 (frameOf b)
  ))
= free b

inline_for_extraction
let rcreate
  (#a: Type)
  (r: HS.rid)
  (init: a)
  (len: U32.t)
: HST.ST (buffer a)
  (requires (fun h -> HST.is_eternal_region r /\ U32.v len > 0))
  (ensures (fun h b h' ->
    rcreate_post_mem_common r (U32.v len) b h h' (Seq.create (U32.v len) init) /\
    recallable b
  ))
= let b = gcmalloc r init len in
  b

inline_for_extraction
let rcreate_mm
  (#a: Type)
  (r: HS.rid)
  (init: a)
  (len: U32.t)
: HST.ST (buffer a)
  (requires (fun h -> HST.is_eternal_region r /\ U32.v len > 0))
  (ensures (fun h b h' ->
    rcreate_post_mem_common r (U32.v len) b h h' (Seq.create (U32.v len) init) /\
    freeable b
  ))
= malloc r init len

inline_for_extraction
let create
  (#a: Type)
  (init: a)
  (len: U32.t)
: HST.StackInline (buffer a)
  (requires (fun h -> U32.v len > 0))
  (ensures (fun h b h' ->
    rcreate_post_mem_common (HS.get_tip h) (U32.v len) b h h' (Seq.create (U32.v len) init)
  ))
= alloca init len

unfold let createL_pre (#a: Type0) (init: list a) : GTot Type0 =
  alloca_of_list_pre init

let createL
  (#a: Type0)
  (init: list a)
: HST.StackInline (buffer a)
  (requires (fun h -> createL_pre #a init))
  (ensures (fun h b h' ->
    let len = FStar.List.Tot.length init in
    rcreate_post_mem_common (HS.get_tip h) len b h h' (Seq.seq_of_list init) /\
    length b == normalize_term (List.Tot.length init)
  ))
= alloca_of_list init
