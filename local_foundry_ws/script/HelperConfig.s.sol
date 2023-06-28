// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint32 constant SEPOLIA_CHAIN_ID = 11155111;

    struct NetworkConfig {
        address relevantAddress; // Maybe change this variable name.
    }

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaNetConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaNetConfig() public pure returns (NetworkConfig memory) {}

    function getOrCreateAnvilEthConfig()
        public
        view
        returns (NetworkConfig memory)
    {
        // Line blelow checks if the contract has already been deployed. If it has, the address would be different from 0.
        if (activeNetworkConfig.relevantAddress != address(0)) {
            return activeNetworkConfig;
        }

        // Function is not complete, complete when details to test are more clear.
    }
}
