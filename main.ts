var price_num1 = 1n;
var price_num2 = 1n;
var price_num3 = 1n;

var token_1 = 1000n;
var token_2 = 1000n;
var token_3 = 1000n;

const token_pool = 3000n;

let utility_function = function(x:bigint, y:bigint, z:bigint):bigint{
    return ( (x*y*z) - (x+y+z)/3n); 
}

let price = function(amount_token1 : bigint, amount_token2 : bigint, amount_token3: bigint)
{
    var val = utility_function(amount_token1, amount_token2, amount_token3);

    price_num1 = val*token_1/token_pool;
    price_num2 = val*token_2/token_pool;
    price_num3 = val*token_3/token_pool;

}

let tokenWallet = function() : bigint[]
{
    return [token_1, token_2, token_3];
}

let valueWallet = function() : bigint
{
    return (price_num1*token_1 + price_num2*token_2 + price_num3*token_3);
}

let valueOfEach = function() : bigint[]
{
    return [price_num1*token_1 + price_num2*token_2 + price_num3*token_3];
}
