# CFMM.tez
CFMM between three tokens (FA12 or FA2) based on utility curve of **U(x,y,z) = x*y*z - (x+y+z)/3**. The curve tends to be flat during the mid with the low fluctutations due to change in token quantity. 


<h1>Getting Started </h1>
initialise truffle using 

```
truffle init
```

Local environment to be set up for Tezos testnet, make changes for mnemonics and truffle-config files. Refer -https://trufflesuite.com/docs/tezos/truffle/quickstart.html#using-the-tezos-truffle-box

```
truffle migrate
```


<h1>Curve</h1>

Live curve of the isoutility curve - https://www.desmos.com/calculator/dcmnjltnc1 

![Image of the plot](https://github.com/guni7/CFMM.tez/blob/main/curve1.png?raw=true)

<br>


![Image of the plot](https://github.com/guni7/CFMM.tez/blob/main/curve2.png?raw=true)

<br>


![Image of the plot](https://github.com/guni7/CFMM.tez/blob/main/curve3.png?raw=true)

