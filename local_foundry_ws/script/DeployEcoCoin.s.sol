// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {EcoCoin} from "../src/EcoCoin.sol";

contract DeployEcoCoin is Script {
    function run() external returns (EcoCoin, HelperConfig) {
        // Use the helper function later to detemine better addresses
        HelperConfig helperConfig = new HelperConfig();
        (
            address GenesisMunicipalityAddress,
            string memory GenesisMunicipalityZipCode, // address RecyclerAddress, // address ShopAddress, // address MachineAddress,
            ,
            ,
            ,
            ,

        ) = // address seondMunicipalityAddress,
            // string memory secondMunicipalityZipCode
            helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        EcoCoin ecoCoin = new EcoCoin();
        ecoCoin.addGenMuni(
            GenesisMunicipalityAddress,
            GenesisMunicipalityZipCode
        );
        vm.stopBroadcast();

        return (ecoCoin, helperConfig);
    }
}
