/*
    Order of testing:
        1. Unit
        2. Intergration
        3. Forked
        4. Staging <- running tests on a testnet
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/Console.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {EcoCoin} from "../src/EcoCoin.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {DeployEcoCoin} from "../script/DeployEcoCoin.s.sol";
import {Municipality, Muni} from "../src/Municipality.sol";
import {Depositor} from "../src/Depositor.sol";

contract EcoCoinTest is StdCheats, Test {
    EcoCoin public ecoCoin;
    HelperConfig public helperConfig;
    Municipality municipality = new Municipality();
    Depositor depositor = new Depositor();

    address GenesisMunicipalityAddress;
    string GenesisMunicipalityZipCode;
    address RecyclerAddress;
    address ShopAddress;
    address MachineAddress;
    address secondMunicipalityAddress;
    string secondMunicipalityZipCode;

    function setUp() external {
        DeployEcoCoin deployer = new DeployEcoCoin();
        (ecoCoin, helperConfig) = deployer.run();
        (
            GenesisMunicipalityAddress,
            GenesisMunicipalityZipCode,
            RecyclerAddress,
            ShopAddress,
            MachineAddress,
            secondMunicipalityAddress,
            secondMunicipalityZipCode
        ) = helperConfig.activeNetworkConfig();
    }

    function testAddMuni() external {
        // Not municipality error
        console.log("Genesis muni address: ", GenesisMunicipalityAddress);
        console.log(
            "Zip Code of genesis municipality: ",
            municipality.MuniAddrToZipCode(GenesisMunicipalityAddress)
        );
        vm.startPrank(GenesisMunicipalityAddress);
        municipality.addMuni(
            secondMunicipalityAddress,
            secondMunicipalityZipCode
        );
        vm.stopPrank();
    }

    /* Depositor Tests */
    uint64 searchID;
    uint64 greenerIndex;

    function testRegisterDepositor() public {
        vm.startPrank(RecyclerAddress);
        depositor.registerRecycler("John Doe");
        searchID = depositor.getIdByAddress(RecyclerAddress);
        console.log("Search ID: ", searchID);
        vm.stopPrank();
    }

    // function testGetIDByAddress() external {
    //     // testRegisterDepositor();
    //     vm.prank(RecyclerAddress);
    //     depositor.registerRecycler("John Doe");

    //     searchID = depositor.getIdByAddress(RecyclerAddress);
    //     console.log("Search ID: ", searchID);
    //     assert(searchID > 0);
    // }

    // function testGetGreenerIndexByID() external {
    //     searchID = depositor.getIdByAddress(RecyclerAddress);
    //     greenerIndex = depositor._getGreenerIndexByID(searchID);
    //     console.log("Greener Index: ", greenerIndex);
    // }
}
