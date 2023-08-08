# EcoCoin
[Git Source](https://bitbucket.org/aa-lsue/ecocoin/blob/27cc1410ed5efb28550c12324e78cb96e5927fc2/src/EcoCoin.sol)

**Inherits:**
ERC20, Ownable

**Author:**
ChefAharoni

0 Decimals, derives basic structure from OpenZeppelin's ERC20 contract.

*Name: "EcoCoin"; Symbol: "ECC"*


## State Variables
### municipality

```solidity
Municipality municipality;
```


### machine

```solidity
Machine machine;
```


### i_genMunicipality

```solidity
Muni.MunicipalityBase public i_genMunicipality;
```


### _exMachineAddressToID

```solidity
mapping(address => uint64) public _exMachineAddressToID;
```


## Functions
### onlyMachine


```solidity
modifier onlyMachine();
```

### constructor


```solidity
constructor(address _municipalityAddr) ERC20("EcoCoin", "ECC") Ownable;
```

### addGenMuni

Adds the genesis municipality.

*Should be called only once, when the contract is deployed.*

*The genesis municipality is the first municipality to be added to the system.*

*Only the contract deployer can call this function.*

*This function is the onlu function that utilizes the onlyOwner modifier from the Ownable contract; owner has no other special permissions.*


```solidity
function addGenMuni(address _genMunicipalityAddr, string memory _genMunicipalityZipCode) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_genMunicipalityAddr`|`address`| Wallet address of the genesis municipality.|
|`_genMunicipalityZipCode`|`string`| Zip code of the genesis municipality.|


### decimals

Overriding the decimals function from the ERC20 contract, setting the decimals of the token to zero (0).


```solidity
function decimals() public pure override returns (uint8);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint8`|uint8  Amount of decimals used for the token.|


### mint

Mints tokens to the specified address.

*No restrictions on who can mint tokens.*


```solidity
function mint(address to, uint256 amount) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`| Address to mint tokens to.|
|`amount`|`uint256`| Amount of tokens to mint.|


### burn

Burns tokens to the specified address.

*No restrictions on who can burn tokens.*


```solidity
function burn(address account, uint256 amount) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`| Address to burn tokens from|
|`amount`|`uint256`| Amount of tokens to burn.|


## Events
### AddedMunicipality

```solidity
event AddedMunicipality(address indexed municipalityAddr, string indexed municipalityZipCode, address indexed addedBy);
```

## Errors
### EcoCoin__genMunicipalityIsSet

```solidity
error EcoCoin__genMunicipalityIsSet();
```

### Machine__SenderNotMachine

```solidity
error Machine__SenderNotMachine(address);
```

