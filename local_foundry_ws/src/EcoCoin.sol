// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations: structs, enums
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
import {Muni, Municipality} from "./Municipality.sol";

// import "./openzeppelin-contracts/contracts/access/Ownable.sol"; // Doesn't work for some reason, implement in the future.

// error EcoCoin__NotMunicipality(string errorMsg); // Error to throw when the caller is not the i_tokenOwner.

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

contract EcoCoin is ERC20, Ownable {
    error EcoCoin__genMunicipalityIsSet(); // Error to throw when Genesis municipality is already set.

    Municipality municipality = new Municipality();

    using Muni for address; // Changed from Muni for *; to use the library only for addresses; if doesn't work, change back to Muni for *.

    Muni.MunicipalityBase private i_genMunicipality; // Genesis municipality, will be able to assign other municipalities and assign roles; should be immutable

    constructor() ERC20("EcoCoin", "ECC") {}

    /**
     * @notice  Adds the genesis municipality.
     * @dev     Should be called only once, when the contract is deployed.
     * @dev     The genesis municipality is the first municipality to be added to the system.
     * @dev     Only the contract deployer can call this function.
     * @dev     This function is the onlu function that utilizes the onlyOwner modifier from the Ownable contract; owner has no other special permissions.
     * @param   _genMunicipalityAddr  Wallet address of the genesis municipality.
     * @param   _genMunicipalityZipCode  Zip code of the genesis municipality.
     */
    function addGenMuni(address _genMunicipalityAddr, string memory _genMunicipalityZipCode) public onlyOwner {
        // Error if the genesis municipality is already set; should only be set once.
        if (i_genMunicipality.muniAddr != address(0)) {
            revert EcoCoin__genMunicipalityIsSet();
        }
        i_genMunicipality = Muni.MunicipalityBase(_genMunicipalityAddr, _genMunicipalityZipCode);

        // Because the function addMuni requires msg.sender to be a municipality, implementing the function here so it could be called once automatically without restrictions.
        // MuniAddrToZipCode[_genMunicipalityAddr] = _genMunicipalityZipCode;
        municipality.updateMuniZipCode(_genMunicipalityAddr, _genMunicipalityZipCode);
    }

    /**
     * @notice  Overriding the decimals function from the ERC20 contract, setting the decimals of the token to zero (0).
     * @return  uint8  Amount of decimals used for the token.
     */
    function decimals() public pure override returns (uint8) {
        return 0; // No decimal places for the token; 2 tokens for a bottle, 10~ tokens equivalent to one usd.
    }
}
