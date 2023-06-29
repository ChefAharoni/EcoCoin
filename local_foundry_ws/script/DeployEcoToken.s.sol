// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {EcoCoin} from "../src/EcoToken.sol";

contract DeployEcoToken is Script {
    function run() external returns (EcoCoin) {
        // Use the helper function later to detemine better addresses
        HelperConfig helperConfig = new HelperConfig();
        (
            address GenesisMunicipalityAddress, // Address of the municipality.
            string memory s_GenesisMunicipalityZipCode, // ZipCode of Municipality; should it be a `storage`? throws a converting error.
            address RecyclerAddress, // Address of the recycler. - use later
            address ShopAddress, // Address of the shops. - use later
            address MachineAddress // Address of the machine. - use later
        ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        EcoCoin ecoCoin = new EcoCoin(
            GenesisMunicipalityAddress,
            s_GenesisMunicipalityZipCode
        );

        vm.stopBroadcast();

        return ecoCoin;
    }
}
