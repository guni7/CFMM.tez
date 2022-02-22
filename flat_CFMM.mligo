#define CASH_IS_FA2
//#define CASH_IS_FA12

[@inline] let const_fee = 9995n (* 0.05% fee *)
[@inline] let const_fee_denom = 10000n
[@inline] let price_of_token_1 = 1n
[@inline] let price_of_token_2 = 1n
[@inline] let price_of_token_3 = 1n


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

let ceildiv (numerator : nat) (denominator : nat) : nat = abs ((- numerator) / (int denominator))

let mint_or_burn (storage: storage) (target: address) (quantity: int): operation =

    let liq_admin : mintOrBurn contract =

     match (Tezos.get_entrypoint_opt "%mintOrBurn" storage.liqAddress :  mintOrBurn contract option) with
    | None -> (failwith error_LQT_CONTRACT_MUST_HAVE_A_MINT_OR_BURN_ENTRYPOINT : mintOrBurn contract)
    | Some contract -> contract in
    Tezos.transaction {quantity = quantity ; target = target} 0mutez liq_admin


let token_tranfer (storage: storage) (from: address) (to_: address) (token_amount: nat): operation =

    let token_contract: token_contract_transfer contract =
    match (Tezos.get_entrypoint_opt "%transfer" storage.tokenAddress : token_contract_transfer contract option) with
    | None -> (failwith error_TOKEN_CONTRACT_MUST_HAVE_A_TRANSFER_ENTRYPOINT : token_contract_transfer contract)
    | Some contract -> contract in
#if TOKEN_IS_FA2
    Tezos.transaction [(from, [(to_, (storage.tokenId, token_amount))])] 0mutez token_contract
#else
    Tezos.transaction (from, (to_, token_amount)) 0mutez token_contract
#endif

let cash_tranfer (storage: storage) (from: address) (to_: address) (cash_amount: nat): operation =

    let cash_contract: cash_contract_transfer contract =
     match (Tezos.get_entrypoint_opt "%transfer" storage.cashAddress : cash_contract_transfer contract option) with
    | None -> (failwith error_TOKEN_CONTRACT_MUST_HAVE_A_TRANSFER_ENTRYPOINT : cash_contract_transfer contract)
    | Some contract -> contract in
#if CASH_IS_FA2
    Tezos.transaction [(from, [(to_, (storage.cashId, cash_amount))])] 0mutez cash_contract
#else
    Tezos.transaction (from, (to_, cash_amount)) 0mutez cash_contract
#endif

let add_liquidity (param: add_liquidity) (storage: storage) : result =

    let {
        owner = owner;
        minLiqMinted = minLiqMinted;
        maxTokensDeposited = maxTokensDeposited;
        cashDeposited = cashDeposited;

        deadline = dealine
    } = param in 
    if storage.pendingPoolUpdates > 0n then
        (failwith error_PENDING_POOL_UPDATES_MUST_BE_ZERO : result)
    else if Tezos.now >= deadline then
        (failwith error_THE_CURRENT_TIME_MUST_BE_LESS_THAN_THE_DEADLINE : result)
    else
        let cashPool   : nat = storage.cashPool in
        let liq_minted : nat = cashDeposited * storage.liqTotal / cashPool in
        let tokens_deposited : nat = ceildiv (cacashDeposited * storage.tokenPool) cashPool in

        if tokens_deposited > maxTokensDeposited then
            (failwith error_MAX_TOKENS_DEPOSITED_MUST_BE_GREATER_THAN_OR_EQUAL_TO_TOKENS_DEPOSITED : result)
        else if lqt_minted < minLqtMinted then
            (failwith error_LQT_MINTED_MUST_BE_GREATER_THAN_MIN_LQT_MINTED : result)
        else
            let storage = {storage with
                liqTotal  = storage.liqTotal + liq_minted ;
                tokenPool = storage.tokenPool + tokens_deposited ;
                cashPool  = storage.cashPool + cashDeposited} in

            (* send tokens from sender to self *)
            let op_token = token_transfer storage Tezos.sender Tezos.self_address tokens_deposited in
            (* send cash from sender to self *)
            let op_cash = cash_transfer storage Tezos.sender Tezos.self_address cashDeposited in
            (* mint lqt tokens for them *)
            let op_liq = mint_or_burn storage owner (int liq_minted) in

            ([op_token;
             op_cash;
             op_liq], storage)


let remove_liquidity(param: remove_liquidity) (storage: storage) : result =

    let {
        to_ = to_;
        liqBurned = liqBurned;
        minCashWithdrawn = minCashWithdrawn;
        minTokensWithdrawn = minTokensWithdrawn;
        deadline = deadline;
    } = param in

    if storage.pendingPoolUpdates > 0n then
      (failwith error_PENDING_POOL_UPDATES_MUST_BE_ZERO : result)
    else if Tezos.now >= deadline then
      (failwith error_THE_CURRENT_TIME_MUST_BE_LESS_THAN_THE_DEADLINE : result)
    else if Tezos.amount > 0mutez then
        (failwith error_AMOUNT_MUST_BE_ZERO : result)
    else begin
        let cash_withdrawn : nat = (liqBurned * storage.cashPool) / storage.liqTotal in
        let tokens_withdrawn : nat = (liqBurned * storage.tokenPool) / storage.liqTotal in

        if cash_withdrawn < minCashWithdrawn then
            (failwith error_THE_AMOUNT_OF_CASH_WITHDRAWN_MUST_BE_GREATER_THAN_OR_EQUAL_TO_MIN_CASH_WITHDRAWN : result)
        else if tokens_withdrawn < minTokensWithdrawn  then
            (failwith error_THE_AMOUNT_OF_TOKENS_WITHDRAWN_MUST_BE_GREATER_THAN_OR_EQUAL_TO_MIN_TOKENS_WITHDRAWN : result)
        else begin
            
            let new_liqTotal = match (is_a_nat ( storage.liqTotal - liqBurned)) with
                
                | None -> (failwith error_CANNOT_BURN_MORE_THAN_THE_TOTAL_AMOUNT_OF_LQT : nat)
                | Some n -> n in
            
            let new_tokenPool = match is_a_nat (storage.tokenPool - tokens_withdrawn) with
                | None -> (failwith error_TOKEN_POOL_MINUS_TOKENS_WITHDRAWN_IS_NEGATIVE : nat)
                | Some n -> n in
            let new_cashPool = match is_nat (storage.cashPool - cash_withdrawn) with
                | None -> (failwith error_CASH_POOL_MINUS_CASH_WITHDRAWN_IS_NEGATIVE : nat)
                | Some n -> n in
            let op_liq = mint_or_burn storage Tezos.sender (0 - liqBurned) in
            let op_token = token_transfer storage Tezos.self_address Tezos.sender tokens_withdrawn in
            let op_cash = cash_transfer storage Tezos.self_address to_ cash_withdrawn in
            let storage = {storage with cashPool = new_cashPool ; liqTotal = new_liqTotal ; tokenPool = new_tokenPool} in
            ([op_liq; op_token; op_cash], storage)
        end
    end



let util (x: nat) (y: nat) (z: nat) : nat  =
    let plus = x + y +z in

    let res: int
    res = 1

    while(res*res*res < x*y*z)
    {
        res = res + 1
    }

    let multiply = res in 

    let minus = plus - multiply in


    abs(minus)


let tokensBought (cashPool: nat) (tokenPool: nat) (cashSold:nat) : nat =

    let x = cashPool*price_of_token_1 in 
    let y = cashPool*price_of_token_2 in
    let z = cashPool*price_of_token_3 in

    let result = util x y z in

    abs(result)

let cashBought (cashPool: nat) (tokenPool: nat) (tokenSold: nat) : nat =

    let x = tokenPool*price_of_token_1 in
    let y = tokenPool*price_of_token_2 in
    let z = tokenPool*price_of_token_3 in

    let result = util x y z in

    abs(result)

let cash_to_token (param: cash_to_token) (storage: storage) =

    let 
    {
        to_ = to_;
        cashSold = cashSold;
        deadline = deadline;
    } = param in

    if storage.pendingPoolUpdates > 0n then
        (failwith error_PENDING_POOL_UPDATES_MUST_BE_ZERO : result)
    else if Tezos.now >= deadline then
        (failwith error_THE_CURRENT_TIME_MUST_BE_LESS_THAN_THE_DEADLINE : result)
    else begin
       
        let tokens_bought =
            (let bought = const_fee * (tokensBought storage.cashPool storage.tokenPool cashSold) / const_fee_denom in
            if bought < minTokensBought then
                (failwith error_TOKENS_BOUGHT_MUST_BE_GREATER_THAN_OR_EQUAL_TO_MIN_TOKENS_BOUGHT : nat)
            else
                bought)
        in
        let new_tokenPool = (match is_nat (storage.tokenPool - tokens_bought) with
            | None -> (failwith error_TOKEN_POOL_MINUS_TOKENS_BOUGHT_IS_NEGATIVE : nat)
            | Some difference -> difference) in

        
        let storage = { storage with cashPool = storage.cashPool + cashSold ; tokenPool = new_tokenPool } in
      
        let op_cash = cash_transfer storage Tezos.sender Tezos.self_address cashSold in
      
        let op_token = token_transfer storage Tezos.self_address to_ tokens_bought in
        ([
            op_cash;
            op_token], storage)
    end

let token_to_cash (param: token_to_cash) (storage: storage) =

    let 
    {
        to_ = to_;
        tokensSold = tokensSold;
        minCashBought = minCashBought;
        deadline = deadline;
    } = param in

    if storage.pendingPoolUpdates > 0n then
        (failwith error_PENDING_POOL_UPDATES_MUST_BE_ZERO : result)
    else if Tezos.now >= deadline then
        (failwith error_THE_CURRENT_TIME_MUST_BE_LESS_THAN_THE_DEADLINE : result)
    else if Tezos.amount > 0mutez then
        (failwith error_AMOUNT_MUST_BE_ZERO : result)
    else
       
        let cash_bought =
            let bought = const_fee * (cashBought storage.cashPool storage.tokenPool tokensSold) / const_fee_denom in
                if bought < minCashBought then (failwith error_CASH_BOUGHT_MUST_BE_GREATER_THAN_OR_EQUAL_TO_MIN_CASH_BOUGHT : nat) else bought in
        let op_token = token_transfer storage Tezos.sender Tezos.self_address tokensSold in
        let op_cash = cash_transfer storage Tezos.self_address  to_ cash_bought in
        let new_cashPool = match is_nat (storage.cashPool - cash_bought) with
            | None -> (failwith error_ASSERTION_VIOLATED_CASH_BOUGHT_SHOULD_BE_LESS_THAN_CASHPOOL : nat)
            | Some n -> n in
        let storage = {storage with tokenPool = storage.tokenPool + tokensSold ;
                                    cashPool = new_cashPool} in
        ([op_token; op_cash], storage)


let default_ () : result = 
    (failwith error_TEZ_DEPOSIT_WOULD_BE_BURNED : result)


let set_liq_address (liqAddress: address) (storage: storage) : result =
    if storage.pendingPoolUpdates > 0n then
        (failwith error_PENDING_POOL_UPDATES_MUST_BE_ZERO : result)
    else if Tezos.amount > 0mutez then
        (failwith error_AMOUNT_MUST_BE_ZERO : result)
    else if storage.liqAddress <> null_address then
        (failwith error_LQT_ADDRESS_ALREADY_SET : result)
    else
        (([] : operation list), {storage with liqAddress = liqAddress})
    

let update_pools (storage: storage) : result =
    if Tezos.sender <> Tezos.source then
        (failwith error_CALL_NOT_FROM_AN_IMPLICIT_ACCOUNT : result)
    else if Tezos.amount > 0mutez then
      (failwith error_AMOUNT_MUST_BE_ZERO : result)
    else
      let cfmm_update_token_pool_internal : update_token_pool_internal contract = Tezos.self "%updateTokenPoolInternal"  in
      let cfmm_update_cash_pool_internal : update_cash_pool_internal contract = Tezos.self "%updateCashPoolInternal" in
#if TOKEN_IS_FA2
      let token_balance_of : balance_of contract = (match
        (Tezos.get_entrypoint_opt "%balance_of" storage.tokenAddress : balance_of contract option) with
        | None -> (failwith error_INVALID_FA2_TOKEN_CONTRACT_MISSING_BALANCE_OF : balance_of contract)
        | Some contract -> contract) in
      let op = Tezos.transaction ([(Tezos.self_address, storage.tokenId)], cfmm_update_token_pool_internal) 0mutez token_balance_of in
#else
      let token_get_balance : get_balance contract = (match
        (Tezos.get_entrypoint_opt "%getBalance" storage.tokenAddress : get_balance contract option) with
        | None -> (failwith error_INVALID_FA12_TOKEN_CONTRACT_MISSING_GETBALANCE : get_balance contract)
        | Some contract -> contract) in
      let op = Tezos.transaction (Tezos.self_address, cfmm_update_token_pool_internal) 0mutez token_get_balance in
#endif
      let op_list = [ op ] in
#if CASH_IS_FA12
      let cash_get_balance : get_balance contract = (match
        (Tezos.get_entrypoint_opt "%getBalance" storage.cashAddress : get_balance contract option) with
        | None -> (failwith error_INVALID_FA12_CASH_CONTRACT_MISSING_GETBALANCE : get_balance contract)
        | Some contract -> contract) in
      let op_cash = Tezos.transaction (Tezos.self_address, cfmm_update_cash_pool_internal) 0mutez cash_get_balance in
      let op_list = op_cash :: op_list in
#endif
#if CASH_IS_FA2
      let cash_balance_of : balance_of contract = (match
        (Tezos.get_entrypoint_opt "%balance_of" storage.cashAddress : balance_of contract option) with
        | None -> (failwith error_INVALID_FA2_CASH_CONTRACT_MISSING_GETBALANCE : balance_of contract)
        | Some contract -> contract) in
      let op_cash = Tezos.transaction ([(Tezos.self_address, storage.cashId)], cfmm_update_cash_pool_internal) 0mutez cash_balance_of in
      let op_list = op_cash :: op_list in
#endif
      (op_list, {storage with pendingPoolUpdates = 2n})



[@inline]
let update_fa12_pool_internal (pool_update : update_fa12_pool) : nat =
    pool_update

[@inline]
let update_fa2_pool_internal (pool_update : update_fa2_pool) : nat =
        match pool_update with
        | [] -> (failwith error_INVALID_FA2_BALANCE_RESPONSE : nat)
        | x :: _xs -> x.1

let update_token_pool_internal (pool_update : update_token_pool_internal) (storage : storage) : result =
    if (storage.pendingPoolUpdates = 0n or Tezos.sender <> storage.tokenAddress) then
      (failwith error_THIS_ENTRYPOINT_MAY_ONLY_BE_CALLED_BY_GETBALANCE_OF_TOKENADDRESS : result)
    else
#if TOKEN_IS_FA2
    let pool = update_fa2_pool_internal (pool_update) in
#else
    let pool = update_fa12_pool_internal (pool_update) in
#endif
    let pendingPoolUpdates = abs (storage.pendingPoolUpdates - 1n) in
    (([] : operation list), {storage with tokenPool = pool ; pendingPoolUpdates = pendingPoolUpdates})

let update_cash_pool_internal (pool_update : update_cash_pool_internal) (storage : storage) : result =
    if (storage.pendingPoolUpdates = 0n or Tezos.sender <> storage.cashAddress) then
      (failwith error_THIS_ENTRYPOINT_MAY_ONLY_BE_CALLED_BY_GETBALANCE_OF_CASHADDRESS : result)
    else
#if CASH_IS_FA2
    let pool = update_fa2_pool_internal (pool_update) in
#else
    let pool = update_fa12_pool_internal (pool_update) in
#endif
    let pendingPoolUpdates = abs (storage.pendingPoolUpdates - 1) in
    (([] : operation list), {storage with cashPool = pool ; pendingPoolUpdates = pendingPoolUpdates})


let main ((entrypoint, storage) : entrypoint * storage) : result =
    match entrypoint with
    | Default -> default_ ()
    | AddLiquidity param ->
        add_liquidity param storage
    | RemoveLiquidity param ->
        remove_liquidity param storage
    | UpdateCashPoolInternal cash_pool ->
        update_cash_pool_internal cash_pool storage
    | UpdatePools  ->
        update_pools storage
    | CashToToken param ->
        (cash_to_token param storage)
    | TokenToCash param ->
        (token_to_cash param storage)
    | UpdateTokenPoolInternal token_pool ->
        update_token_pool_internal token_pool storage
    | SetLiqAddress param ->
        set_liq_address param storage