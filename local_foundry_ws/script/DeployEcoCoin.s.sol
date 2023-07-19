// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {EcoCoin} from "../src/EcoCoin.sol";
import {console} from "forge-std/Test.sol";
import {Municipality} from "../src/Municipality.sol";
import {Depositor} from "../src/Depositor.sol";
import {Machine} from "../src/Machine.sol";
import {Spender} from "../src/Spender.sol";
import {ShopHandler} from "../src/ShopHandler.sol";

contract DeployEcoCoin is Script {
    // Municipality municipality = new Municipality();

    // Anvil private key for account 9; nothing risky to show.
    uint256 ACC_9_PRIVATE_KEY =
        0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6;

    function run()
        external
        returns (
            EcoCoin,
            HelperConfig,
            Depositor,
            Machine,
            Spender,
            ShopHandler
        )
    {
        // StartBroadcat means that everything after this will be broadcasted to the blockchain and deployed.
        // Any other operations we that are not within the startBroadcat, will not cost any gas.
        vm.startBroadcast(ACC_9_PRIVATE_KEY);
        HelperConfig helperConfig = new HelperConfig();
        EcoCoin ecoCoin = new EcoCoin(); // "new" keyword creates a new contract.
        // Contract deployer adds the genesis municipality.

        Depositor depositor = new Depositor(address(ecoCoin));
        ShopHandler shopHandler = new ShopHandler(address(ecoCoin));
        Machine machine = new Machine(
            address(ecoCoin),
            address(depositor),
            address(shopHandler)
        );
        Spender spender = new Spender(
            address(ecoCoin),
            address(depositor),
            address(shopHandler)
        );

        vm.stopBroadcast();

        return (
            ecoCoin,
            helperConfig,
            depositor,
            machine,
            spender,
            shopHandler
        );
    }
}
