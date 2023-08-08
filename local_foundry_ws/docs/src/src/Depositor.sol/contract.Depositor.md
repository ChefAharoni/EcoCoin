# Depositor
[Git Source](https://bitbucket.org/aa-lsue/ecocoin/blob/27cc1410ed5efb28550c12324e78cb96e5927fc2/src/Depositor.sol)

**Author:**
ChefAharoni

Manages the deposition of bottles.

*Development is not complete, should change the whole method of this contract.*


## State Variables
### ecoCoin

```solidity
IEcoCoin private immutable ecoCoin;
```


### greeners

```solidity
Recylcer[] public greeners;
```


### recyclerToID

```solidity
mapping(address recycler => uint64 recyID) public recyclerToID;
```


## Functions
### constructor


```solidity
constructor(address _ecoCoinAddr);
```

### registerRecycler

Registers the recycler to the system.

*.*


```solidity
function registerRecycler(string memory _name) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_name`|`string`| Name of the recycler.|


### _getGreenerIndexByID

Gets the index of the array by its ID.

*.*


```solidity
function _getGreenerIndexByID(uint64 searchID) public view returns (uint64);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`searchID`|`uint64`| ID of the array to search for.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint64`|uint64  Index of the array in the greeners array.|


### getIdByAddress

Gets the recycler's ID by his address.

*Used for external contracts.*


```solidity
function getIdByAddress(address _recyAddr) external view returns (uint64);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_recyAddr`|`address`| Address of the recycler.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint64`|uint64  ID of the recycler.|


### getGreeners

Gets the array of the greeners to interact with.

*Used for external contracts.*


```solidity
function getGreeners() external view returns (Recylcer[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Recylcer[]`|Recylcer[]  Array of the greeners.|


### updateRecyBalance

Update the balance of the recycler in the greeners array.

*Update of tokens is deriven by the EcoCoin contract, and cannot be set manually.*


```solidity
function updateRecyBalance(uint64 _recyID) public returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_recyID`|`uint64`| ID of the recycler.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool  True if the operation was successful.|


## Events
### RecyclerRegistered

```solidity
event RecyclerRegistered(address indexed recyAddr, uint64 indexed recyID, string indexed recyName);
```

## Errors
### Depositor__RecyclerNotRegistered

```solidity
error Depositor__RecyclerNotRegistered();
```

### Depositor__GreenerID_DoesNotExist

```solidity
error Depositor__GreenerID_DoesNotExist();
```

## Structs
### Recylcer

```solidity
struct Recylcer {
    uint64 ID;
    string recyName;
    address recyAddr;
    uint64 bottlesDepo;
    uint256 recyBalance;
    uint256 lastTimeStamp;
    bool status;
}
```

