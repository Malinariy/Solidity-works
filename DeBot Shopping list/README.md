
# DeBot application

This is an example of a "Shopping List" application. The application consists some contracts:

-contracts of DeBots: Debot_InitList.sol, Debot_FillList.sol, Debot_AtMarket.sol

-smart contract containing shopping list and file containig some structs, interfaces: ShopList.sol and structs_storage.sol 

## How to try DeBot in the Surf
This DeBot is already deployed on blockchain

net.ton.dev
DeBot address: 0:68007aeebb3814a20b45b3ceeb1823b0bc615c83bb7632e2c63a3b7322b0680f

Open the link: https://web.ton.surf/debot?address=0%3A68007aeebb3814a20b45b3ceeb1823b0bc615c83bb7632e2c63a3b7322b0680f&net=devnet&restart=true

## How to build
### Prerequisites
Install tondev globally:
```bash
$ npm i tondev -g
$ tondev tonos-cli install
```
### Compile
```bash
tondev sol compile shopList.sol
```

## How to deploy

### Encrypt data before saving to contract

## Author
- [@Chuk](https://github.com/Malinariy)
