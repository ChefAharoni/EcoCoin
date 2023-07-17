// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {EcoCoin} from "../src/EcoCoin.sol";
import {console} from "forge-std/Test.sol";

contract DeployEcoCoin is Script {
    // Anvil private key for account 9; nothing risky to show.
    uint256 ACC_9_PRIVATE_KEY =
        0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6;

    function run() external returns (EcoCoin, HelperConfig) {
        // Use the helper function later to detemine better addresses
        HelperConfig helperConfig = new HelperConfig();
        (
            address GenesisMunicipalityAddress,
            string memory GenesisMunicipalityZipCode, // address RecyclerAddress, // address ShopAddress, // address MachineAddress, // address seondMunicipalityAddress, // string memory secondMunicipalityZipCode
            ,
            ,
            ,
            ,

        ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast(ACC_9_PRIVATE_KEY);
        EcoCoin ecoCoin = new EcoCoin();
        // Contract deployer adds the genesis municipality.
        ecoCoin.addGenMuni(
            GenesisMunicipalityAddress,
            GenesisMunicipalityZipCode
        );
        console.log("This deployer address: ", address(this));
        vm.stopBroadcast();

        return (ecoCoin, helperConfig);
    }
}
