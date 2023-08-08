# IEcoCoin
[Git Source](https://bitbucket.org/aa-lsue/ecocoin/blob/27cc1410ed5efb28550c12324e78cb96e5927fc2/src/IEcoCoin.sol)


## Functions
### balanceOf


```solidity
function balanceOf(address _account) external view returns (uint256);
```

### burn


```solidity
function burn(address account, uint256 amount) external;
```

### mint


```solidity
function mint(address _account, uint256 _amount) external;
```

### approve


```solidity
function approve(address spender, uint256 amount) external returns (bool);
```

### transferFrom


```solidity
function transferFrom(address from, address to, uint256 amount) external returns (bool);
```

### updateMachineAddressToID


```solidity
function updateMachineAddressToID(address _machineAddr, uint64 _machineID) external;
```

