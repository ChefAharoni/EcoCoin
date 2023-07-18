// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {EcoCoin} from "./EcoCoin.sol";

library Muni {
    // As for right now (07/15), I don't see what advantage for using a special struct for Municipality, if it's only used for the address and zip code.
    struct MunicipalityBase {
        address muniAddr; // Address of the Municipality
        string s_muniZipCode; // Zip code location of the genesis municipality; string so it can handle long zip codes and non-us zipcodes as well.
    }
}

contract Municipality {
    error Municipality__GenesisMunicipalityHasBeenSet_MappingIsNotEmpty();
    error Municipality__NotMunicipality(); // Error to throw when the caller is not a municipality.

    // EcoCoin ecoCoin = new EcoCoin;
    using Muni for address; // Changed from Muni for *; to use the library only for addresses; if doesn't work, change back to Muni for *.

    mapping(address => string) public MuniAddrToZipCode; // Mapping of address to a municipality zip code.

    /* Events */
    event AddedMunicipality(
        address indexed municipalityAddr,
        string indexed municipalityZipCode,
        address indexed addedBy
    );

    /**
     * @notice  Addition to functions so only municipalities can perform actions.
     * @dev   .
     */
    modifier muniOnly() {
        if (
            keccak256(abi.encodePacked(MuniAddrToZipCode[msg.sender])) ==
            keccak256(abi.encodePacked(""))
        ) {
            revert Municipality__NotMunicipality();
        }
        _;
    }

    /**
     * @notice  Adds a municipality to the mappings.
     * @dev     Should be called only by another municipality using a modifier muniOnly() from Municipality contract.
     * @dev This function should be called ON the municipalities mapping.
     * @dev i.e. municipalities.addMuni(_municipalityAddr, _municipalityZipCode) muniOnly().
     * @param _municipalityAddr  Address of the municipality to add.
     * @param _municipalityZipCode  Zip code of the municipality to add.
     * @return  string   ZipCode of the municipality added.
     */
    function addMuni(
        address _municipalityAddr,
        string memory _municipalityZipCode
    ) public muniOnly returns (string memory) {
        emit AddedMunicipality(
            _municipalityAddr,
            _municipalityZipCode,
            msg.sender
        );
        MuniAddrToZipCode[_municipalityAddr] = _municipalityZipCode;
        return MuniAddrToZipCode[_municipalityAddr];
    }

    /**
     * @notice  Updated MuniAddrToZipCode mapping.
     * @dev     Could be called only once, by the contract owner.
     * @dev     There's no check for calling by an owner, but this function should be called when contract is deployed.
     * @param   _municipalityAddr  Address of the municipality to add.
     * @param   _municipalityZipCode  Zip code of the municipality to add.
     * @return  string  ZipCode of the municipality added.
     */
    function updateMuniZipCode(
        address _municipalityAddr,
        string memory _municipalityZipCode
    ) external returns (string memory) {
        // Let this function be called only once; checks if the mapping is empty.
        if (
            keccak256(abi.encodePacked(MuniAddrToZipCode[msg.sender])) !=
            keccak256(abi.encodePacked(""))
        ) {
            revert Municipality__GenesisMunicipalityHasBeenSet_MappingIsNotEmpty();
        }

        MuniAddrToZipCode[_municipalityAddr] = _municipalityZipCode;
        return MuniAddrToZipCode[_municipalityAddr];
    }
}
