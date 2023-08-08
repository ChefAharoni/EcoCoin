# Municipality
[Git Source](https://bitbucket.org/aa-lsue/ecocoin/blob/27cc1410ed5efb28550c12324e78cb96e5927fc2/src/Municipality.sol)


## State Variables
### MuniAddrToZipCode

```solidity
mapping(address => string) public MuniAddrToZipCode;
```


### numMunicipalities

```solidity
uint256 public numMunicipalities = 0;
```


## Functions
### muniOnly

Check in functions so only municipalities can perform actions.

*.*


```solidity
modifier muniOnly();
```

### addMuni

Adds a municipality to the mappings.

*Should be called only by another municipality using a modifier muniOnly() from Municipality contract.*

*This function should be called ON the municipalities mapping.*

*i.e. municipalities.addMuni(_municipalityAddr, _municipalityZipCode) muniOnly().*


```solidity
function addMuni(address _municipalityAddr, string memory _municipalityZipCode)
    public
    muniOnly
    returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_municipalityAddr`|`address`| Address of the municipality to add.|
|`_municipalityZipCode`|`string`| Zip code of the municipality to add.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|string   ZipCode of the municipality added.|


### updateMuniZipCode

Updates MuniAddrToZipCode mapping.

*Could be called only once, by the contract owner.*

*There's no check for calling by an owner, but this function should be called when contract is deployed.*


```solidity
function updateMuniZipCode(address _municipalityAddr, string memory _municipalityZipCode)
    external
    returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_municipalityAddr`|`address`| Address of the municipality to add.|
|`_municipalityZipCode`|`string`| Zip code of the municipality to add.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|string  ZipCode of the municipality added.|


### incrementNumMunicipalities


```solidity
function incrementNumMunicipalities() external;
```

## Events
### AddedMunicipality

```solidity
event AddedMunicipality(address indexed municipalityAddr, string indexed municipalityZipCode, address indexed addedBy);
```

## Errors
### Municipality__GenesisMunicipalityHasBeenSet_MappingIsNotEmpty

```solidity
error Municipality__GenesisMunicipalityHasBeenSet_MappingIsNotEmpty();
```

### Municipality__NotMunicipality

```solidity
error Municipality__NotMunicipality(address);
```

