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

contract EcoCoinTest is StdCheats, Test {
    EcoCoin public ecoCoin;
    HelperConfig public helperConfig;
    Municipality municipality = new Municipality();

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
}
