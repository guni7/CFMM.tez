type dex_action is
| InitializeExchange      of (nat)  (* sets initial liquidity *)
| TezToTokenPayment       of tez_to_token_payment_params  (* exchanges XTZ to tokens and sends them to receiver *)
| TokenToTezPayment       of token_to_tez_payment_params  (* exchanges tokens to XTZ and sends them to receiver *)
| InvestLiquidity         of (nat)  (* mints min shares after investing tokens and XTZ *)
| DivestLiquidity         of divest_liquidity_params  (* burns shares and sends tokens and XTZ to the owner *)
| Vote                    of vote_params  (* votes for candidate with shares of voter *)
| Veto                    of veto_params  (* vote for banning candidate with shares of voter *)
| WithdrawProfit          of (address)  (* withdraws delegation reward of the sender to receiver address *)

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