// return type of dex_action entrypoints
type dex_action = {
    |   InitializeExchange of nat
    |   AddPair of initialize_params  (* sets initial liquidity *)
}



type dex_storage = {
    entered: bool;
    pairs_count : nat; // renamme to trip count
    tokens : (nat, tokens_info) big_map; // tokens info
    token_to_id : (token_pair, nat) big_map;
    pairs : (nat, pair_info) big_map;
    ledger : ((address * nat), account_info) big_map;

}

type token_to_token_route_params is
  [@layout:comb]
  record [
    swaps                 : list(swap_slice_type); (* swap operations list*)
    amount_in             : nat; (* amount of tokens to be exchanged *)
    min_amount_out        : nat; (* min amount of tokens received to accept exchange *)
    receiver              : address; (* tokens receiver *)
  ]
