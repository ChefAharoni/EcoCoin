/*
    Order of testing:
        1. Unit
        2. Intergration
        3. Forked
        4. Staging <- running tests on a testnet
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
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
        console.log("Set Up address: ", address(this));
        console.log("EcoCoin address: ", address(ecoCoin));
        console.log("Deployer address: ", address(deployer));
        console.log("Helper Config address: ", address(helperConfig));
    }

    // (07/17) tried deploying directly from the test, but it didn't work.
    // address GenesisMunicipalityAddress = makeAddr("genMunicipality");
    // string GenesisMunicipalityZipCode = "70535";
    // address secondMunicipalityAddress = makeAddr("secondMunicipality");
    // string secondMunicipalityZipCode = "70501";
    // address RecyclerAddress = makeAddr("recycler");

    // address contractDeployer = makeAddr("deployer");

    // function setUp() external {
    //     vm.startBroadcast(contractDeployer);
    //     ecoCoin = new EcoCoin();
    //     ecoCoin.addGenMuni(
    //         GenesisMunicipalityAddress,
    //         GenesisMunicipalityZipCode
    //     );
    //     vm.stopBroadcast();
    // }

    /* EcoCoin Tests */

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

    function caller() public view {
        console.log("Caller: ", msg.sender);
    }

    function testCallerMunicipality() external {
        // vm.startPrank() isn't working for some reason.
        console.log("This testCallerMunicipality address:", address(this));
        console.log("Genesis muni address: ", GenesisMunicipalityAddress);
        console.log("Sender: ", msg.sender);
        vm.startPrank(address(0));
        console.log("Pranking GenesisMunicipalityAddress....");
        caller();
        caller();
        caller();
        console.log("Genesis muni address: ", GenesisMunicipalityAddress);
        console.log("Sender: ", msg.sender);
        vm.stopPrank();
        console.log("Pranking stopped.");
        console.log("Genesis muni address: ", GenesisMunicipalityAddress);
        console.log("Sender: ", msg.sender);
        vm.prank(address(1));
        console.log("Sender: ", msg.sender);
    }

    /* Depositor Tests */
    uint64 searchID;
    uint64 greenerIndex;

    function testRegisterDepositor() external {
        // Not working
        vm.startPrank(RecyclerAddress);
        console.log("Sender: ", msg.sender);
        depositor.registerRecycler("John Doe");
        searchID = depositor.getIdByAddress(RecyclerAddress);
        console.log("Search ID: ", searchID);
        vm.stopPrank();
    }

    function testGetIDByAddress() external {
        // Not working
        // testRegisterDepositor();
        vm.prank(RecyclerAddress);
        depositor.registerRecycler("John Doe");

        searchID = depositor.getIdByAddress(RecyclerAddress);
        console.log("Search ID: ", searchID);
        assert(searchID > 0);
    }

    function testGetGreenerIndexByID() external {
        // Not working
        searchID = depositor.getIdByAddress(RecyclerAddress);
        greenerIndex = depositor._getGreenerIndexByID(searchID);
        console.log("Greener Index: ", greenerIndex);
    }
}
