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


(*helper function implementation*)