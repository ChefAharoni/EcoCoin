// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IEcoCoin} from "./IEcoCoin.sol"; // EcoCoin Interface
import {Muni, MuniData} from "./Municipality.sol";

// import "./openzeppelin-contracts/contracts/access/Ownable.sol"; // Doesn't work for some reason, implement in the future.

// error EcoCoin__NotMunicipality(string errorMsg); // Error to throw when the caller is not the i_tokenOwner.
error EcoCoin__genMunicipalityIsSet(); // Error to throw when Genesis municipality is already set.

// TODO - add more error and revert messages instead of require, to save gas.
// TODO - add s_ prefix to variables saved in storage.
// TODO - optimize for loops that read from storage every time to read from storage only once.
// TODO - add i_ prefix to immutable variables.
// TODO - Ensure ordering of contracts is correct; order is located in general.txt.
// TODO - Declare events in all contracts.
// TODO - Gas optimization - change state variables to private if possible.
/**
 * @author  ChefAharoni
 * @title   EcoCoin token
 * @dev     Name: "EcoCoin"; Symbol: "ECC"
 * @notice  0 Decimals, derives basic structure from OpenZeppelin's ERC20 contract.
 */

contract EcoCoin is ERC20, MuniData, Ownable, IEcoCoin {
    using Muni for address; // Changed from Muni for *; to use the library only for addresses; if doesn't work, change back to Muni for *.

    Muni.Municipality private i_genMunicipality; // Genesis municipality, will be able to assign other municipalities and assign roles; should be immutable

    constructor() ERC20("EcoCoin", "ECC") {}

    /**
     * @notice  Adds the genesis municipality.
     * @dev     Should be called only once, when the contract is deployed.
     * @dev     The genesis municipality is the first municipality to be added to the system.
     * @dev     Only the contract deployer can call this function.
     * @param   _genMunicipalityAddr  Wallet address of the genesis municipality.
     * @param   _genMunicipalityZipCode  Zip code of the genesis municipality.
     */
    function addGenMuni(
        address _genMunicipalityAddr,
        string memory _genMunicipalityZipCode
    ) public onlyOwner {
        // Error if the genesis municipality is already set; should only be set once.
        if (i_genMunicipality.muniAddr != address(0)) {
            revert EcoCoin__genMunicipalityIsSet();
        }
        i_genMunicipality = Muni.Municipality(
            _genMunicipalityAddr,
            _genMunicipalityZipCode
        );

        // Because the function addMuni requires msg.sender to be a municipality, implementing the function here so it could be called once automatically without restrictions.
        MuniAddrToZipCode[_genMunicipalityAddr] = _genMunicipalityZipCode;
    }

    /**
     * @notice  Function that mints tokens to the machine.
     * @param   n  Amount of tokens to mint.
     */
    // function mintTokens(address machineAdr, uint256 n) public muniOnly {
    //     // ERC20 tokens by default have 18 decimals
    //     // number of tokens minted = n * 10^18
    //     _mint(machineAdr, n * 10 ** uint(decimals())); // Decimals function return 18 == 18 decimal places
    // }

    /**
     * @notice  Function to transfer tokens from one address to another.
     * @dev     Uses the _transfer function from the ERC20 contract, because it's internal.
     * @param   sender  Sender of the tokens.
     * @param   recipient  Recipient of the tokens.
     * @param   amount  Amount of tokens to transfer.
     * @return  bool  True if the transfer was successful.
     */
    //! the _transfer function can be inherited from ERC20, and the sender would be the machine, who would also be the tokens minter.
    // function transferFunds(
    //     // Double check if I need this function, I may be able to inherit it from this contract.
    //     address sender,
    //     address recipient,
    //     uint amount
    // ) public muniOnly returns (bool) {
    //     _transfer(sender, payable(recipient), amount); // payable keyword means that the receipent can accept eth (or tokens).
    //     return true;
    // }

    /**
     * @notice  Function to burn tokens.
     * @dev     Uses the _burn function from the ERC20 contract, because it's internal.
     * @param   account  Account to burn tokens from.
     * @param   amount  Amount of tokens to burn.
     * @return  bool  True if the burn was successful.
     */
    // function _burnTokens(
    //     address account,
    //     uint256 amount
    // ) public muniOnly returns (bool) {
    //     _burn(account, amount); // Burn tokens
    //     return true;
    // }

    /**
     * @notice  Overriding the decimals function from the ERC20 contract, setting the decimals of the token to zero (0).
     * @return  uint8  Amount of decimals used for the token.
     */
    function decimals() public pure override returns (uint8) {
        return 0; // No decimal places for the token; 2 tokens for a bottle, 10~ tokens equivalent to one usd.
    }
}
