#define CASH_IS_FA2
//#define CASH_IS_FA12

[@inline] let const_fee = 9995n (* 0.05% fee *)
[@inline] let const_fee_denom = 10000n
[@inline] let price_num = 1n
[@inline] let price_denom = 1n

type add_liquidity = {
    owner: address;
    minLiqMinted: nat;
    maxTokenDeposited: nat;
    cashDeposited: nat;
    deadline: timestamp;
}

type remove_liquidity = {
    to_ : address;
    liqBurned: nat;
    minCashWithdrawn: nat;
    minTokenWithdrawn: nat;
    deadline: timestamp;
}

type cash_to_token = {
    to_: address;
    minTokensBought: nat;
    cashSold: nat;
    deadline: timestamp;
}

type token_to_cash = {
    to_: address;
    tokenSold: nat;
    minCashBought: nat;
    deadline: timestamp;
}

//get balance
type update_fa12_pool = nat
type update_fa2_pool = ((address*nat)*nat) list

#if TOKEN_IS_FA2
type update_token_pool_internal = update_fa2_pool
#else
type update_token_pool_internal = update_fa12_pool
#endif

#if CASH_IS_FA2
type update_cash_pool_internal = update_fa2_pool
#endif

#if CASH_IS_FA12
type update_cash_pool_internal = update_fa12_pool
#endif

type entrypoint =
| Default of unit
| AddLiquidity    of add_liquidity
| RemoveLiquidity of remove_liquidity
| CashToToken     of cash_to_token
| TokenToCash     of token_to_cash
| UpdatePools     of unit
| UpdateTokenPoolInternal of update_token_pool_internal
| UpdateCashPoolInternal of update_cash_pool_internal
| SetLiqAddress   of address

type storage = {
    tokenPool: nat;
    cashPool: nat;
    liqTotal: nat;
    pendingPoolUpdates: nat;
    tokenAddress: address;
#if TOKEN_IS_FA2
    tokenId : nat ;
#endif
    cashAddress : address ;
#if CASH_IS_FA2
    cashId : nat ;
#endif
    liqAddress : address ;
}

type result = operation list*storage

//for FA2 token
type token_id = nat
type balance_of = ((address*token_id) list*((((address*nat)*nat) list) contract))
(* FA1.2 *)
type get_balance = address*(nat contract)

#if TOKEN_IS_FA2
type token_contract_transfer = (address*(address*(token_id*nat)) list) list
#else
(*  FA1.2 *)
type token_contract_transfer = address*(address*nat)
#endif

#if CASH_IS_FA2
type cash_contract_transfer = (address*(address*(token_id*nat)) list) list
#else
(* FA12 *)
type cash_contract_transfer = address*(address*nat)
#endif

(* custom entrypoint for LQT FA1.2 *)
type mintOrBurn = { 
    quantity : int ;
    target : address 
}

//ERRORS

[@inline] let error_TOKEN_CONTRACT_MUST_HAVE_A_TRANSFER_ENTRYPOINT  = 0n
[@inline] let error_ASSERTION_VIOLATED_CASH_BOUGHT_SHOULD_BE_LESS_THAN_CASHPOOL = 1n
[@inline] let error_PENDING_POOL_UPDATES_MUST_BE_ZERO       = 2n
[@inline] let error_THE_CURRENT_TIME_MUST_BE_LESS_THAN_THE_DEADLINE = 3n
[@inline] let error_MAX_TOKENS_DEPOSITED_MUST_BE_GREATER_THAN_OR_EQUAL_TO_TOKENS_DEPOSITED = 4n
[@inline] let error_LQT_MINTED_MUST_BE_GREATER_THAN_MIN_LQT_MINTED = 5n
(* 6n *)
[@inline] let error_ONLY_NEW_MANAGER_CAN_ACCEPT = 7n
[@inline] let error_CASH_BOUGHT_MUST_BE_GREATER_THAN_OR_EQUAL_TO_MIN_CASH_BOUGHT = 8n
[@inline] let error_INVALID_TO_ADDRESS = 9n
[@inline] let error_AMOUNT_MUST_BE_ZERO = 10n
[@inline] let error_THE_AMOUNT_OF_CASH_WITHDRAWN_MUST_BE_GREATER_THAN_OR_EQUAL_TO_MIN_CASH_WITHDRAWN = 11n
[@inline] let error_LQT_CONTRACT_MUST_HAVE_A_MINT_OR_BURN_ENTRYPOINT = 12n
[@inline] let error_THE_AMOUNT_OF_TOKENS_WITHDRAWN_MUST_BE_GREATER_THAN_OR_EQUAL_TO_MIN_TOKENS_WITHDRAWN = 13n
[@inline] let error_CANNOT_BURN_MORE_THAN_THE_TOTAL_AMOUNT_OF_LQT = 14n
[@inline] let error_TOKEN_POOL_MINUS_TOKENS_WITHDRAWN_IS_NEGATIVE = 15n
[@inline] let error_CASH_POOL_MINUS_CASH_WITHDRAWN_IS_NEGATIVE = 16n
[@inline] let error_CASH_POOL_MINUS_CASH_BOUGHT_IS_NEGATIVE = 17n
[@inline] let error_TOKENS_BOUGHT_MUST_BE_GREATER_THAN_OR_EQUAL_TO_MIN_TOKENS_BOUGHT = 18n
[@inline] let error_TOKEN_POOL_MINUS_TOKENS_BOUGHT_IS_NEGATIVE = 19n
[@inline] let error_ONLY_MANAGER_CAN_SET_BAKER = 20n
[@inline] let error_ONLY_MANAGER_CAN_SET_MANAGER = 21n
[@inline] let error_BAKER_PERMANENTLY_FROZEN = 22n
[@inline] let error_LQT_ADDRESS_ALREADY_SET = 24n
[@inline] let error_CALL_NOT_FROM_AN_IMPLICIT_ACCOUNT = 25n
(* 26n *)
(* 27n *)
#if TOKEN_IS_FA2
[@inline] let error_INVALID_FA2_TOKEN_CONTRACT_MISSING_BALANCE_OF = 28n
#else
[@inline] let error_INVALID_FA12_TOKEN_CONTRACT_MISSING_GETBALANCE = 28n
#endif
[@inline] let error_THIS_ENTRYPOINT_MAY_ONLY_BE_CALLED_BY_GETBALANCE_OF_TOKENADDRESS = 29n
[@inline] let error_INVALID_FA2_BALANCE_RESPONSE = 30n
[@inline] let error_INVALID_INTERMEDIATE_CONTRACT = 31n
[@inline] let error_THIS_ENTRYPOINT_MAY_ONLY_BE_CALLED_BY_GETBALANCE_OF_CASHADDRESS = 30n
[@inline] let error_TEZ_DEPOSIT_WOULD_BE_BURNED = 32n
#if CASH_IS_FA2
[@inline] let error_INVALID_FA2_CASH_CONTRACT_MISSING_GETBALANCE = 33n
#else
[@inline] let error_INVALID_FA12_CASH_CONTRACT_MISSING_GETBALANCE = 33n
[@inline] let error_MISSING_APPROVE_ENTRYPOINT_IN_CASH_CONTRACT = 34n
#endif


//address

let null_address = ("SOME ADDRESS" : address)

let mutez_to_natural (a:tez) : nat = a/1mutez
let natural_to_mutez (a:nat) : tez = a*1mutez
let is_a_nat (i: int) : nat option = Michelson.is_nat i

let mint_or_burn (storage: storage) (target: address) (quantity: int): operation =

    let liq_admin : mintOrBurn contract =

     match (Tezos.get_entrypoint_opt "%mintOrBurn" storage.liqAddress :  mintOrBurn contract option) with
    | None -> (failwith error_LQT_CONTRACT_MUST_HAVE_A_MINT_OR_BURN_ENTRYPOINT : mintOrBurn contract)
    | Some contract -> contract in
    Tezos.transaction {quantity = quantity ; target = target} 0mutez liq_admin


let token_tranfer (storage: storage) (from: address) (to_: address) (token_amount: nat): operation =
    
    