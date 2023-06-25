// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "./openzeppelin-contracts/contracts/access/Ownable.sol"; // Doesn't work for some reason, implement in the future.

// "EcoCoin", "ECC"
/**
 * @author  ChefAharoni
 * @title   EcoCoin token
 * @dev     .
 * @notice  .
 */

contract EcoCoin is ERC20 {
    // To set the i_tokenOwner of the token; used for managing roles.
    address immutable i_tokenOwner = msg.sender;  // i_ prefix means immutable.

    /**
     * @notice  Function to get the i_tokenOwner of the token.
     * @dev     .
     * @return  address  of the i_tokenOwner.
     */
    function getTokenOwner() public view returns (address) {
        // Returns the address of the i_tokenOwner.
        return i_tokenOwner;
    }

    /**
     * @notice  Addition to function so only the i_tokenOwner can perform actions.
     * @dev     Not sure this method works with functions that are called from other contracts.
     */
    modifier ownerOnly() {
        // Addition to function so only the i_tokenOwner can perform actions.
        require(
            msg.sender == i_tokenOwner,
            "Only the owner of the token can perform this action!"
        );
        _;
    }

    /**
     * @notice  Function that mints tokens to the i_tokenOwner.
     * @param   n  Amount of tokens to mint.
     */
    function mintTokens(uint256 n) public {
        // ERC20 tokens by default have 18 decimals
        // number of tokens minted = n * 10^18
        _mint(i_tokenOwner, n * 10 ** uint(decimals())); // Decimals function return 18 == 18 decimal places
    }

    constructor() ERC20("EcoCoin", "ECC") {
        // These actions are executed immediately when the contract is deployed.
        // ERC20 tokens by default have 18 decimals
        // number of tokens minted = n * 10^18
        // Update - do not mint any tokens at start.
        // uint256 n = 1000; // Number of tokens to create to the contract deployer.
        // _mint(msg.sender, n * 10 ** uint(decimals())); // Decimals function return 18 == 18 decimal places; here I changed it to 0 so there won't be any decimals.
    }

    /**
     * @notice  Function to transfer tokens from one address to another.
     * @dev     Uses the _transfer function from the ERC20 contract, because it's internal.
     * @param   sender  Sender of the tokens.
     * @param   recipient  Recipient of the tokens.
     * @param   amount  Amount of tokens to transfer.
     * @return  bool  True if the transfer was successful.
     */
    function transferFunds(
        address sender,
        address recipient,
        uint amount
    ) public returns (bool) {
        _transfer(sender, payable(recipient), amount); // payable keyword means that the receipent can accept eth (or tokens).
        return true;
    }

    /**
     * @notice  Function to burn tokens.
     * @dev     Uses the _burn function from the ERC20 contract, because it's internal.
     * @param   account  Account to burn tokens from.
     * @param   amount  Amount of tokens to burn.
     * @return  bool  True if the burn was successful.
     */
    function _burnTokens(
        address account,
        uint256 amount
    ) public ownerOnly returns (bool) {
        //---!!!--- I think the ownerOnly gives problems when this function is called from outside - it throws an error even though the caller is the owner. ---!!!---

        _burn(account, amount); // Burn tokens
        return true;
    }

    /**
     * @notice  Overriding the decimals function from the ERC20 contract, setting the decimals of the token to zero (0).
     * @return  uint8  Amount of decimals used for the token.
     */
    function decimals() public pure override returns (uint8) {
        return 0; // No decimal places for the token; 2 tokens for a bottle, 10~ tokens equivalent to one usd.
    }
}
