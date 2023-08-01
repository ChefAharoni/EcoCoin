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

    address ContractOwner;
    address GenesisMunicipalityAddress;
    string GenesisMunicipalityZipCode;
    address RecyclerAddress;
    address ShopAddress;
    address MachineAddress;
    address secondMunicipalityAddress;
    string secondMunicipalityZipCode;

    HelperConfig helperConfig = new HelperConfig();


    function run()
        external
        returns (
            EcoCoin,
            HelperConfig,
            Depositor,
            Machine,
            Spender,
            ShopHandler,
            Municipality
        )
    {
        // StartBroadcat means that everything after this will be broadcasted to the blockchain and deployed.
        // Any other operations we that are not within the startBroadcat, will not cost any gas.
        (
            ContractOwner,
            GenesisMunicipalityAddress,
            GenesisMunicipalityZipCode,
            RecyclerAddress,
            ShopAddress,
            MachineAddress,
            secondMunicipalityAddress
        ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast(ContractOwner);
        Municipality municipality = new Municipality();
        EcoCoin ecoCoin = new EcoCoin(address(municipality)); // "new" keyword creates a new contract.
        // Contract deployer adds the genesis municipality.

        Depositor depositor = new Depositor(address(ecoCoin));

        ShopHandler shopHandler = new ShopHandler(
            address(ecoCoin),
            address(municipality)
        );

        Machine machine = new Machine(
            address(ecoCoin),
            address(depositor),
            address(shopHandler),
            address(municipality)
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
            shopHandler,
            municipality
        );
    }
}
