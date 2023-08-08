# ShopHandler
[Git Source](https://bitbucket.org/aa-lsue/ecocoin/blob/27cc1410ed5efb28550c12324e78cb96e5927fc2/src/ShopHandler.sol)

**Author:**
ChefAharoni

Allows shops to register themselves. Used to prevent fraud by random users pretend to be shops and fool users into sending them tokens.

*.*


## State Variables
### ecoCoin

```solidity
IEcoCoin private immutable ecoCoin;
```


### municipality

```solidity
Municipality municipality;
```


### shopAddrToName

```solidity
mapping(address shop => string shopName) shopAddrToName;
```


### shopAddrToID

```solidity
mapping(address shop => uint64 shopID) shopAddrToID;
```


### shops

```solidity
Shop[] public shops;
```


## Functions
### muniOnly

Check in functions so only municipalities can perform actions.

*.*


```solidity
modifier muniOnly();
```

### constructor


```solidity
constructor(address _ecoCoinAddr, address _municipalityAddr);
```

### registerShop

Main function for shops to register themselves.

*Adds a shop to the array of shops, using the Shop struct.*

*The shop's address is the sender's address.*


```solidity
function registerShop(string memory _name, string memory _type, string memory _zipCode)
    public
    returns (address, string memory, string memory, string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_name`|`string`| Name of the shop.|
|`_type`|`string`| Type of the shop: Coffeehouse / Clothes / Restaurant / etc...|
|`_zipCode`|`string`||

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|address  Address of the shop.|
|`<none>`|`string`|string  Name of the shop.|
|`<none>`|`string`|string  Type of the shop.|
|`<none>`|`string`||


### _getIndexByID

Finds an array's index by its ID; should be internal, doesn't work for some reason (maybe because I'm inheriting this contract as instance and not with "is").

*.*


```solidity
function _getIndexByID(uint64 searchID) public view returns (uint64);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`searchID`|`uint64`| ID of the shop to search.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint64`|uint64  Index of the shop in the array.|


### approveShop

Approved a request of a shop to register; only municipality can approve.

*.*


```solidity
function approveShop(uint64 _shopRegisterID, bool _decision) public muniOnly returns (bool, string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_shopRegisterID`|`uint64`| ID of the shop that requested to register.|
|`_decision`|`bool`| Decision of the municipality to approve or deny the request.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool  True if approved, false if denied.|
|`<none>`|`string`|string  Message of approval/denial.|


### removeShop

Remove a role requested by a shop; only municipality can remove a role.

*.*


```solidity
function removeShop(uint64 _shopRmvID, bool _decision) public muniOnly returns (bool, string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_shopRmvID`|`uint64`|  ID of the shop that requested to be removed.|
|`_decision`|`bool`|  Decision of the municipality to approve or deny the request.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool  True if approved, false if denied.|
|`<none>`|`string`|string Message of approval/denial.|


### printShopName


```solidity
function printShopName() public view returns (string memory);
```

### getShops


```solidity
function getShops() external view returns (Shop[] memory);
```

### updateShopBalance


```solidity
function updateShopBalance(uint64 _shopIndex, address _shopAddress) external;
```

### getShopName


```solidity
function getShopName(address _shopAddress) public view returns (string memory);
```

### getIdByAddress

Gets the shop's ID by his address.

*Used for external contracts.*


```solidity
function getIdByAddress(address _shopAddress) external view returns (uint64);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_shopAddress`|`address`| Address of the shop.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint64`|uint64  ID of the shop.|


## Events
### ShopRegistered

```solidity
event ShopRegistered(
    address indexed shopAddress, uint64 indexed shopID, string indexed shopName, string shopType, string shopZipCode
);
```

### ShopApproved

```solidity
event ShopApproved(
    address indexed approverAddress,
    address indexed shopAddress,
    uint64 indexed shopID,
    string shopName,
    string shopType,
    string shopZipCode
);
```

### ShopDenied

```solidity
event ShopDenied(
    address indexed denierAddress,
    address indexed shopAddress,
    uint64 indexed shopID,
    string shopName,
    string shopType,
    string shopZipCode
);
```

### ShopRemoved

```solidity
event ShopRemoved(
    address indexed removerAddress,
    address indexed shopAddress,
    uint64 indexed shopID,
    string shopName,
    string shopType,
    string shopZipCode
);
```

## Errors
### Municipality__NotMunicipality

```solidity
error Municipality__NotMunicipality(address);
```

### ShopHandler__InvalidCommand

```solidity
error ShopHandler__InvalidCommand();
```

## Structs
### Shop

```solidity
struct Shop {
    uint64 shopID;
    address shopAddress;
    string shopName;
    string shopType;
    string shopZipCode;
    uint256 shopBalance;
    bool status;
}
```

