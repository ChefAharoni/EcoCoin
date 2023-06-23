// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast(); // VM is a "cheat code" in foundry; everything after this line will run.
        SimpleStorage simpleStorage = new SimpleStorage(); // "new" is a Solidity keyword that creates a new contract.
        vm.stopBroadcast();
        return simpleStorage;
    }
}
