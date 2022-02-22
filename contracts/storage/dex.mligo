// ITTDex.ligo


type dex_storage = {
    entered: bool;
    pairs_count : nat; (* renamme to trip count *)
    tokens : (nat, tokens_info) big_map; (*tokens info*) 
    token_to_id : (token_pair, nat) big_map;
    pairs : (nat, pair_info) big_map;
    ledger : ((address * nat), account_info) big_map;
}

type tokens_info = {
    token_a_address : address;
    token_b_address : address;
    token_c_address : address;
    token_a_id : nat;
    token_b_id : nat;
    token_c_id : nat;
    token_a_type : token_type;
    token_b_type : token_type;
    token_c_type : token_type;
}
type token_type = 
  | Fa12 
  | Fa2 ; (*check if this is valid syntax*)

type token = {
    swaps : swap_slice_type list;
    amount_in : nat;
    min_amount_out : nat;
    receiver : address;
}

type pair_info = {
  token_a_pool : nat; (* token A reserves in the pool *)
  token_b_pool : nat; (* token B reserves in the pool *)
  token_c_pool : nat; (* token C reserves in the pool *)
  total_supply : nat; (* total shares count *)
}

// IFactory.ligo


type exchange_storage {
  counter : nat;
  token_list : (nat, token_identifier) big_map;
  token_to_exchange : (token_identifier, address) big_map;
}

type initialize_params = {
    pair : tokens_info;
    token_a_in : nat;
    token_b_in : nat;
    token_c_in : nat;
}

type swap_type = {
  | Sell
  | Buy
}

type swap_slice_type = {
  pair: tokens_info;
  operation: swap_type;
}

type swap_side is record [
  pool                    : nat; (* pair identifier*)
  token                   : address; (* token address*)
  id                      : nat; (* token aidentifier *)
  standard                : token_type; (* token standard *)
]

type swap_side = {
  pool : nat;
  token : address;
  id : nat;
  standard : token_type;
}

type account_info = {
  balance : nat;
  frozen_balance : nat;
  allowances : address set; (* add conditions to check if FA1.2 or FA2 and set allowances accordingly*)
}

type internal_swap_type = {
  s : dex_storage;
  amount_in : nat;
  tokan_address_in : address;
  token_id_in : nat;
  operation : option operation;
  sender : address;
  receiver : address;
}

let internal_token_to_token_swap(tmp * params : internal_swap_type * swap_slice_type): return = {

  (* check preconditions *)
    if params.pair.token_a_address = params.pair.token_b_address
    and params.pair.token_a_id >= params.pair.token_b_id
    then failwith("Dex/wrong-token-id") else skip;
    if params.pair.token_a_address > params.pair.token_b_address
    then failwith("Dex/wrong-pair") else skip;

  
  if params.pair.token_a_address = params.pair.token_b_address and params.pair.token_a_id
    (* get pair info*)
    const res : (pair_info * nat) = get_pair(params.pair, tmp.s);
}

let get_pair(key * s : tokens_info * dex_storage) : (pair_info * nat) = 

  (* figure out bytes.pack and unpack *)
  let token_bytes : token_pair = Bytes.pack key in

  let token_id : nat = match s.token_to_id[token_bytes] with 
    | None -> s.pairs_count
    | Some (instance) -> instance
  in
  let pair : pair_info = match s.pairs[token_id] with 
    | None -> {
      token_a_pool = 0n;
      token_b_pool = 0n;
      token_c_pool = 0n;
      total_supply = 0n;
    }
    | Some(instance) -> instance
  in
    (pair, token_id)