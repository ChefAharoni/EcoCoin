// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";

// "EcoCoin", "ECC"
contract EcoCoin is ERC20 {
  // To set the owner of the token; used for managing roles.
  address owner = msg.sender;

  function getOwner() public view returns (address){
    // Returns the address of the owner.
    return owner;
  }

  // constructor() { address owner = msg.sender; }

  constructor(string memory name, string memory symbol)
  ERC20(name, symbol) {
      // ERC20 tokens by default have 18 decimals
      // number of tokens minted = n * 10^18
      uint256 n = 1000;  // Number of tokens to create; I think this is the amount each user gets when adding the token - if so, it needs to be changed to 0.
      _mint(msg.sender, n * 10**uint(decimals()));  // Decimals function return 18 == 18 decimal places
}
        function decimals() override public pure returns (uint8) {
        return 0;  // No decimal places for the token; 2 tokens for a bottle, 10~ tokens equivalent to one usd.
    }

 }