// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

import {EcoCoin} from "./EcoToken.sol";

error MuniData__NotMunicipality(string errorMsg); // Error to throw when the caller is not the i_tokenOwner.

library Muni {
    struct Municipality {
        address muniAddr; // Address of the Municipality
        string s_muniZipCode; // Zip code location of the genesis municipality; string so it can handle long zip codes and non-us zipcodes as well.
    }

    /**
     * @notice  Adds a municipality to the mappings.
     * @dev     Should be called only by another municipality using a modifier muniOnly() from MuniData contract.
     * @dev This function should be called ON the municipalities mapping.
     * @dev i.e. municipalities.addMuni(_municipalityAddr, _municipalityZipCode) muniOnly().
     * @param _municipalityAddr  Address of the municipality to add.
     * @param _municipalityZipCode  Zip code of the municipality to add.
     * @return  address   Address of the municipality added.
     */
    // mapping(address => Municipality) storage municipalities, // Not needed for testing
    function addMuni(
        mapping(address => string) storage MuniAddrToZipCode,
        address _municipalityAddr,
        string memory _municipalityZipCode
    ) public returns (address) {
        // Function to add a municipality to the mapping.
        // MuniAddrToZipCode[_municipalityAddr] = _municipalityZipCode;
        // municipalities[_municipalityAddr] = Muni.Municipality({
        //     muniAddr: _municipalityAddr,
        //     s_muniZipCode: _municipalityZipCode
        // });
        // return municipalities[_municipalityAddr];
        MuniAddrToZipCode[_municipalityAddr] = _municipalityZipCode;
        return _municipalityAddr;
    }
}

contract MuniData {
    // EcoCoin ecoCoin = new EcoCoin;
    using Muni for *;
    mapping(address => Muni.Municipality) municipalities; // Mapping of all municipalites of type Municipality; used to check if a msg.sender is of type Municipality.
    mapping(address => string) public MuniAddrToZipCode; // Mapping of address to a municipality zip code.
    string private constant NOT_MUNICIPALITY_MSG =
        "Only a municipality can perform this action!"; // Error message to throw when the caller is not the i_tokenOwner. // Seems it's not common to use strings in custom errors - I'll keep it here for now.

    /**
     * @notice  Addition to functions so only municipalities can perform actions.
     * @dev   .
     */
    modifier muniOnly() {
        if (municipalities[msg.sender].muniAddr != msg.sender) {
            /* Since all keys in mapping are set to address(0) by default, checks if the address exists in the mapping. */
            revert MuniData__NotMunicipality(NOT_MUNICIPALITY_MSG);
        }
        _;
    }
}
