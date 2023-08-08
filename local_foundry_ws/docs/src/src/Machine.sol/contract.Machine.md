# Machine
[Git Source](https://bitbucket.org/aa-lsue/ecocoin/blob/27cc1410ed5efb28550c12324e78cb96e5927fc2/src/Machine.sol)


## State Variables
### exchangeMachines

```solidity
exchangeMachine[] public exchangeMachines;
```


### exMachineAddressToID

```solidity
mapping(address => uint64) public exMachineAddressToID;
```


### exMachineIDToAddress

```solidity
mapping(uint64 => address) public exMachineIDToAddress;
```


### i_CoolDownInterval

```solidity
uint256 private immutable i_CoolDownInterval;
```


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


### municipality

```solidity
Municipality municipality;
```


## Functions
### machineOnly

Modifier that lets only a machine to perform certain actions.

*Checks if the machine exists in the exMachineAddresstoID mapping.*


```solidity
modifier machineOnly();
```

### muniOnly

Check in functions so only municipalities can perform actions.

*.*


```solidity
modifier muniOnly();
```

### constructor


```solidity
constructor(address _ecoCoinAddr, address _depositorAddr, address _shopHandlerAddr, address _municipalityAddr);
```

### createMachine

Create a new exchange machine.

*Address of machine should be created prior to calling this function.*


```solidity
function createMachine(address _exMAddress, string memory _exMZip) public muniOnly returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256  ID of the new exchange machine.|


### _depositTokens

Deposits tokens into the recycler's account, according to the amount of bottles deposited.

*DANGEROUS IMPLEMENTATION!!!*

*Currently this function has no limitations on who can call it; currently this is okay since we're assuming that in "realistic" implementation, only the machine will have access to this function.*

*Maybe it's all okay, because in a realistic scenario, we can assume that the recycler will only have to these functions when he's at a physical machine.*


```solidity
function _depositTokens(address exMachineAddress, address _recyAddr, uint256 _amtBottles) private returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`exMachineAddress`|`address`|Address of the machine that will be used for minting and transferring.|
|`_recyAddr`|`address`| Address of the recycler.|
|`_amtBottles`|`uint256`| Amount of bottles to deposit.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool  True if the operation was successful.|


### depositBottles

Lets a recycler deposits bottles through a machine and receive tokens in exchange.

*Verification of depositions should be entered in the future.*

*As of right now, when depositing bottles, user must specify the machine ID. This is a little bit complicated for the user, but I'm assuming that there will be several machines at each ZipCode, so I don't want to rely soley on that.*

*Please implement a front end feature to get all machines in a zip code, using the array of all exchange machines (exchangeMachines).*

*Should be called only be a registered depositor.*

*Since there is no "real" verification of bottles, this function can be easily exploited, since anyone can call it and mint infinite tokens.*


```solidity
function depositBottles(uint64 _exMachineID, uint64 _bottles) public returns (bool, string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_exMachineID`|`uint64`| ID of the exchange machine to be used.|
|`_bottles`|`uint64`| Amount of bottles to deposit.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool  True if successfully deposited, false otherwise.|
|`<none>`|`string`|string  String indication of success / failure.|


### redeemTokens

Allows shops to redeem their tokens.

*We are assuming the machine is encyrtped and trusted, so we're automating the process of redeeming tokens.*


```solidity
function redeemTokens(uint64 _exMachineID, string memory _cashAppUsername, uint64 _tokensAmt) public returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_exMachineID`|`uint64`| ID of the exchange machine to be used.|
|`_cashAppUsername`|`string`||
|`_tokensAmt`|`uint64`| Amount of tokens to redeem.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool  True if successfully deposited, false otherwise.|


### transferRealMoney

Transfers real money (RM) to the shop; currently a mock function.

*.*


```solidity
function transferRealMoney(uint64 _exMachineID, address _shopAddress, string memory _cashAppUsername, uint64 _tokensAmt)
    private
    pure
    returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_exMachineID`|`uint64`|  ID of the exchange machine to be used.|
|`_shopAddress`|`address`| Address of the shop that's associated with the redeemed tokens.|
|`_cashAppUsername`|`string`|CashApp username of the shop, RM will be transferred to this username.|
|`_tokensAmt`|`uint64`| Amount of redeemed tokens to be converterd as a transfer of real money (RM).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|string  Success message of the transfer.|


## Events
### AddedExchangeMachine

```solidity
event AddedExchangeMachine(address indexed exMachineAddress, string indexed exMachineZipCode, address indexed addedBy);
```

### DepositedBottles

```solidity
event DepositedBottles(
    uint64 indexed exMachineID,
    address exMachineAddress,
    address indexed recyAddr,
    uint64 recyID,
    uint64 indexed bottles
);
```

### DepositedTokens

```solidity
event DepositedTokens(
    address exMachineAddress, uint64 indexed exMachineID, address indexed recyAddress, uint256 indexed tokens
);
```

### RedeemedTokens

```solidity
event RedeemedTokens(
    address exMachineAddress,
    uint64 indexed exMachineID,
    address indexed shopAddress,
    uint256 indexed tokens,
    string cashAppUsername
);
```

## Errors
### Depositor__RecyclerNotRegistered

```solidity
error Depositor__RecyclerNotRegistered();
```

### ShopHandler__ShopNotRegisteredOrApproved

```solidity
error ShopHandler__ShopNotRegisteredOrApproved();
```

### Machine__CallerIsNotMachine

```solidity
error Machine__CallerIsNotMachine();
```

### Machine__BottlesNumberToDepositMustBeGreaterThanZero

```solidity
error Machine__BottlesNumberToDepositMustBeGreaterThanZero();
```

### Machine__CannotDepositMoreThan200BottlesAtOnce

```solidity
error Machine__CannotDepositMoreThan200BottlesAtOnce();
```

### Machine__CoolDownTimerHasntPassed

```solidity
error Machine__CoolDownTimerHasntPassed();
```

### Machine__RedeemedTokensMustBeGreaterThanZero

```solidity
error Machine__RedeemedTokensMustBeGreaterThanZero();
```

### Machine__CannotRedeemMoreThan9999TokensAtOnce

```solidity
error Machine__CannotRedeemMoreThan9999TokensAtOnce();
```

### Machine__InsufficientTokensBalanceToRedeem

```solidity
error Machine__InsufficientTokensBalanceToRedeem();
```

### Municipality__NotMunicipality

```solidity
error Municipality__NotMunicipality(address);
```

## Structs
### exchangeMachine

```solidity
struct exchangeMachine {
    uint64 exMachineID;
    string exMachineZipCode;
    address exMachineAddress;
    uint256 exMachineRMBalance;
}
```

