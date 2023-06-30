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
pragma solidity ^0.8;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "./openzeppelin-contracts/contracts/access/Ownable.sol"; // Doesn't work for some reason, implement in the future.

error EcoCoin__NotMunicipality(string errorMsg); // Error to throw when the caller is not the i_tokenOwner.

// TODO - add more error and revert messages instead of require, to save gas.
// TODO - add s_ prefix to variables saved in storage.
// TODO - optimize for loops that read from storage every time to read from storage only once.
// TODO - add i_ prefix to immutable variables.
// TODO - Ensure ordering of contracts is correct; order is located in general.txt.
// TODO - Declare events in all contracts.
// TODO - Gas optimization - change state variables to private if possible.
// "EcoCoin", "ECC"
/**
 * @author  ChefAharoni
 * @title   EcoCoin token
 * @dev     .
 * @notice  .
 */

contract EcoCoin is ERC20 {
    // To set the i_tokenOwner of the token; used for managing roles.
    // address immutable i_tokenOwner = msg.sender; // i_ prefix means immutable.
    Municipality private i_genMunicipality; // Genesis municipality, will be able to assign other municipalities and assign roles; should be immutable
    string private constant NOT_MUNICIPALITY_MSG =
        "Only a municipality can perform this action!"; // Error message to throw when the caller is not the i_tokenOwner. // Seems it's not common to use strings in custom errors - I'll keep it here for now.

    mapping(address => string) public MuniAddrToZipCode; // Mapping of address to a municipality zip code.
    mapping(address => Municipality) public municipalities; // Mapping of all municipalites of type Municipality; used to check if a msg.sender is of type Municipality.
    struct Municipality {
        address muniAddr; // Address of the Municipality
        string s_muniZipCode; // Zip code location of the genesis municipality; string so it can handle long zip codes and non-us zipcodes as well.
    }

    constructor(
        address _genMunicipalityAddr,
        string memory _genMunicipalityZipCode
    ) ERC20("EcoCoin", "ECC") {
        // These actions are executed immediately when the contract is deployed.
        // ERC20 tokens by default have 18 decimals
        // number of tokens minted = n * 10^18
        // Update - do not mint any tokens at start.
        // uint256 n = 1000; // Number of tokens to create to the contract deployer.
        // _mint(msg.sender, n * 10 ** uint(decimals())); // Decimals function return 18 == 18 decimal places; here I changed it to 0 so there won't be any decimals. //! mint opeation was cancelled - will mint only when bottles are deposited.
        i_genMunicipality = Municipality(
            _genMunicipalityAddr,
            _genMunicipalityZipCode
        );
        addMuni({
            _municipalityAddr: _genMunicipalityAddr,
            _municipalityZipCode: _genMunicipalityZipCode
        });
    }

    /**
     * @notice  Addition to function so only the i_tokenOwner can perform actions.
     * @dev     Not sure this method works with functions that are called from other contracts.
     */
    modifier muniOnly() {
        if (municipalities[msg.sender].muniAddr != msg.sender) {
            /* Since all keys in mapping are set to address(0) by default, checks if the address exists in the mapping. */
            revert EcoCoin__NotMunicipality(NOT_MUNICIPALITY_MSG);
        }
        _;
    }

    function addMuni(
        address _municipalityAddr,
        string memory _municipalityZipCode
    ) public returns (Municipality memory) {
        // Function to add a municipality to the mapping.
        MuniAddrToZipCode[_municipalityAddr] = _municipalityZipCode;
        municipalities[_municipalityAddr] = Municipality({
            muniAddr: _municipalityAddr,
            s_muniZipCode: _municipalityZipCode
        });
        return municipalities[_municipalityAddr];
    }

    /**
     * @notice  Function to get the i_tokenOwner of the token.
     * @dev     .
     * @return  address  of the i_tokenOwner.
     */
    // function getTokenOwner() public view returns (address) {
    //     // Returns the address of the i_tokenOwner.
    //     return i_tokenOwner;
    // }

    // /**
    //  * @notice  Function that mints tokens to the i_tokenOwner.
    //  * @param   n  Amount of tokens to mint.
    //  */
    // function mintTokens(uint256 n) public {
    //     // ERC20 tokens by default have 18 decimals
    //     // number of tokens minted = n * 10^18
    //     _mint(i_tokenOwner, n * 10 ** uint(decimals())); // Decimals function return 18 == 18 decimal places
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
    // ) public returns (bool) {
    //     _transfer(sender, payable(recipient), amount); // payable keyword means that the receipent can accept eth (or tokens).
    //     return true;
    // }

    // /**
    //  * @notice  Function to burn tokens.
    //  * @dev     Uses the _burn function from the ERC20 contract, because it's internal.
    //  * @param   account  Account to burn tokens from.
    //  * @param   amount  Amount of tokens to burn.
    //  * @return  bool  True if the burn was successful.
    //  */
    // function _burnTokens(
    //     address account,
    //     uint256 amount
    // ) public muniOnly returns (bool) {
    //     //---!!!--- I think the muniOnly gives problems when this function is called from outside - it throws an error even though the caller is the owner. ---!!!---

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
