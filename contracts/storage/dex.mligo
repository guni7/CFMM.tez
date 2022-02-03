// ITTDex.ligo


type dex_storage = {
    entered: bool;
    pairs_count : nat; // renamme to trip count
    tokens : (nat, tokens_info) big_map; // tokens info
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
type token_type = Fa12 | Fa2 ; // check if this is valid syntax
 
type token_to_token_route_params is
[@layout:comb]
record [
swaps : list(swap_slice_type); (* swap operations list*)
amount_in : nat; (* amount of tokens to be exchanged *)
min_amount_out : nat; (* min amount of tokens received to accept exchange *)
receiver : address; (* tokens receiver *)
]

type token = {
    swaps : list(swap_slice_type)
    amount_in : nat;
    min_amount_out : nat;
    receiver : address;
}

type swap_slice_type is record [
    pair                  : tokens_info; (* exchange pair info *)
    operation             : swap_type; (* exchange operation *)
]

// IFactory.ligo

type exchange_storage is record [
  counter             : nat;
  baker_validator     : address;
  token_list          : big_map(nat, token_identifier); (* all the tokens list *)
  token_to_exchange   : big_map(token_identifier, address); (* token to exchange pairs *)
  dex_lambdas         : big_map(nat, dex_func); (* map with exchange-related functions code *)
  token_lambdas       : big_map(nat, token_func); (* map with token-related functions code *)
  voters              : big_map(address, vote_info); (* voting info per user *)
  vetos               : big_map(key_hash, timestamp); (* time until the banned delegates can't be chosen *)
  votes               : big_map(key_hash, nat); (* votes per candidate *)
  user_rewards        : big_map(address, user_reward_info); (* rawards info per account *)
  metadata            : big_map(string, bytes); (* metadata storage according to TZIP-016 *)
  ledger              : big_map(address, account_info); (* account info per address *)
]


type exchange_storage {
  counter : nat;
  token_list : (nat, token_identifier) big_map;
  token_to_exchange : (token_identifier, address) big_map;
}