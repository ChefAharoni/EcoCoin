// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

// "EcoCoin", "ECC"
contract EcoCoin is ERC20{
  // To set the tokenOwner of the token; used for managing roles.
  address tokenOwner = msg.sender;

  function getTokenOwner() public view returns (address){
    // Returns the address of the tokenOwner.
    return tokenOwner;
  }

  modifier ownerOnly() {
    // Addition to function so only the tokenOwner can perform actions.
    require(msg.sender == tokenOwner);
    _;
  }

  function mintTokens(uint256 n) public {
    // ERC20 tokens by default have 18 decimals
    // number of tokens minted = n * 10^18
    // uint256 n = 1000;  // Number of tokens to create; I think this is the amount each user gets when adding the token - if so, it needs to be changed to 0.
    _mint(tokenOwner, n * 10**uint(decimals()));  // Decimals function return 18 == 18 decimal places
  }

  constructor() ERC20("EcoCoin", "ECC") {
    // These actions are executed immediately when the contract is deployed.

    // ERC20 tokens by default have 18 decimals
    // number of tokens minted = n * 10^18
    uint256 n = 1000;  // Number of tokens to create to the contract deployer.
    _mint(msg.sender, n * 10**uint(decimals()));  // Decimals function return 18 == 18 decimal places; here I changed it to 0 so there won't be any decimals.

  }

  function transferFunds(address sender, address recipient, uint amount) public returns (bool) {
    _transfer(sender, payable(recipient), amount);  // payable keyword means that the receipent can accept eth (or tokens).
    return true;
  }

  function _burnTokens(address account, uint256 amount) public ownerOnly returns (bool) {
    // Function for other contracts to burn redeemed tokens.
    _burn(account, amount);  // Burn tokens
    return true;
  }

  function decimals() override public pure returns (uint8) {
    return 0;  // No decimal places for the token; 2 tokens for a bottle, 10~ tokens equivalent to one usd.
  }

 }