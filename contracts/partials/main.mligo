type mintOrBurn =
[@layout:comb]
{ 
  quantity : int ;
  target : address 
}

type result = operation list * storage


type pool = {
    pool_id = nat;
    token_one = nat;
    token_one_address = address;
    token_one_amount = nat;
    token_two = nat;
    token_two_address = address;
    token_two_amount = nat;
    token_three = nat
    token_three_address = address;
    token_three_amount = nat;
}

type storage = {
    pool =  (nat, pool) big_map;
    lqtAddress : address;
}

type token_to_token =
  [@layout:comb]
  { outputDexterContract : address ;
    minTokensBought : nat ;
    [@annot:to] to_ : address ;
    tokensSold : nat ;
    deadline : timestamp ;
  }

type swap = 
    [@layout:comb]
    {
        token_in_id = nat;
        token_out_id = nat;
        token_out_amount = nat;  (*  *)
    }

type calculate_in_amount = 
    [@layout:comb]
    {
        token_in_id = nat;
        token_out_id = nat;
        token_out_amount;
    }


let add_liquidity ( param: add_liquidity ) (storage : storage ) : result =  
    let {
        owner = owner
    } = param;


let swap (param: swap) (storage : storage) : result =
    let {
        token_in_id = token_in_id
        token_out_id = token_out_id
        token_out_amount = token_out_amount
    } = param in 





let calculate_in_amount (param : calculate_in_amount ) (storage : storage) : nat = 
    let {
        token_in_id = token_in_id
        token_out_id = token_out_id
        token_out_amount = token_out_amount
    } = param in 

    // get 
    let {
        token_one_id = token_one_id
        token_
    }

    let token_in_amount = 
    


let main ((entrypoint, storage) : entrypoint * storage ): result = 
    match entrypoint with 
|   AddLiquidity param -> add_liquidity param storage
|   RemoveLiquidity param -> remove_liquidity param storage 
|   Swap param -> swap param storage 
