# Spender
[Git Source](https://bitbucket.org/aa-lsue/ecocoin/blob/27cc1410ed5efb28550c12324e78cb96e5927fc2/src/Spender.sol)


## State Variables
### ecoCoin

```solidity
IEcoCoin private immutable ecoCoin;
```


### depositor

```solidity
Depositor depositor;
```


### shopHandler

```solidity
ShopHandler shopHandler;
```


## Functions
### constructor


```solidity
constructor(address _ecoCoinAddr, address _depositorAddr, address _shopHandlerAddr);
```

### purchaseGoods


```solidity
function purchaseGoods(uint64 shopID, uint256 _spendAmount) public returns (bool);
```

## Events
### GoodsPurchased

```solidity
event GoodsPurchased(uint64 indexed shopID, address shopAddress, address indexed recyAddr, uint256 indexed spendAmount);
```

## Errors
### Spender__InsufficientFundsToSpend

```solidity
error Spender__InsufficientFundsToSpend();
```

### Depositor__RecyclerNotRegistered

```solidity
error Depositor__RecyclerNotRegistered();
```

