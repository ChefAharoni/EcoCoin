// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";
// later implement here the ownable contract by openzeppelin, for ease of management.

// "EcoCoin", "ECC"
contract EcoCoin is ERC20{
  // To set the tokenOwner of the token; used for managing roles.
  address tokenOwner = msg.sender;

  function getTokenOwner() public view returns (address){
    // Returns the address of the tokenOwner.
    return tokenOwner;
  }

  function mintTokens() public {
    require (msg.sender == tokenOwner, "Only the token owner can mint tokens!");
    // ERC20 tokens by default have 18 decimals
    // number of tokens minted = n * 10^18
    uint256 n = 1000;  // Number of tokens to create; I think this is the amount each user gets when adding the token - if so, it needs to be changed to 0.
    _mint(msg.sender, n * 10**uint(decimals()));  // Decimals function return 18 == 18 decimal places
  }

  constructor() ERC20("EcoCoin", "ECC") {
    // These actions are executed immediately when the contract is deployed.

    // ERC20 tokens by default have 18 decimals
    // number of tokens minted = n * 10^18
    uint256 n = 1000;  // Number of tokens to create; I think this is the amount each user gets when adding the token - if so, it needs to be changed to 0.
    _mint(msg.sender, n * 10**uint(decimals()));  // Decimals function return 18 == 18 decimal places

  }

  function transferFunds(address sender, address recipient, uint amount) public returns (bool) {
    _transfer(sender, payable(recipient), amount);  // payable keyword means that the receipent can accept eth (or tokens).
    return true;
  }

  function decimals() override public pure returns (uint8) {
    return 0;  // No decimal places for the token; 2 tokens for a bottle, 10~ tokens equivalent to one usd.
  }

 }