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
import {Machine} from "../src/Machine.sol";
import {Spender} from "../src/Spender.sol";

contract EcoCoinTest is StdCheats, Test {
    EcoCoin public ecoCoin;
    HelperConfig public helperConfig;
    Municipality public municipality;
    Depositor public depositor;
    // Depositor depositor = new Depositor();
    Machine machine = new Machine(address(ecoCoin));
    Spender spender = new Spender(address(ecoCoin));

    address contractDeployer = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;

    address GenesisMunicipalityAddress;
    string GenesisMunicipalityZipCode;
    address RecyclerAddress;
    address ShopAddress;
    address MachineAddress;
    address secondMunicipalityAddress;
    string secondMunicipalityZipCode;

    function setUp() external {
        depositor = new Depositor();
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
        municipality = ecoCoin.municipality();
    }

    /* EcoCoin Tests */

    function testFailAddGenesisMuni_MuniAlreadyAdded() external {
        // Should fail since the genesis municipality is already added.
        // Should get: EcoCoin__GenesisMunicipalityAlreadyAdded
        vm.prank(contractDeployer);
        ecoCoin.addGenMuni(
            GenesisMunicipalityAddress,
            GenesisMunicipalityZipCode
        );
    }

    function testFailAddGenesisMuni_CallerIsNotOwner() external {
        // Should fail since the caller is not the deployer.
        // Should get: Ownable: caller is not the owner
        vm.startPrank(RecyclerAddress);
        ecoCoin.addGenMuni(
            GenesisMunicipalityAddress,
            GenesisMunicipalityZipCode
        );
        vm.stopPrank();
    }

    function testDecimalsEqualToZero() external view {
        assert(ecoCoin.decimals() == 0);
    }

    function testHasGenesisMunicipalityAdded() external view {
        assert(
            keccak256(
                abi.encodePacked(
                    municipality.MuniAddrToZipCode(GenesisMunicipalityAddress)
                )
            ) == keccak256(abi.encodePacked(GenesisMunicipalityZipCode))
        );
    }

    function testGenesisMunicipalityIsNotEmpty() external view {
        assert(
            keccak256(
                abi.encodePacked(
                    municipality.MuniAddrToZipCode(GenesisMunicipalityAddress)
                )
            ) != keccak256(abi.encodePacked(""))
        );
    }

    /* Municipality Tests */

    function testAddMuni() external {
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

    function testSecondMunicipalityAdded() external view {
        assert(
            keccak256(
                abi.encodePacked(
                    municipality.MuniAddrToZipCode(secondMunicipalityAddress)
                )
            ) == keccak256(abi.encodePacked(secondMunicipalityZipCode))
        );
    }

    address thirdMunicipalityAddress = makeAddr("thirdMunicipality");
    string thirdMunicipalityZipCode = "70502";

    function testSecondMuniAddsThirdMuni() external {
        vm.prank(secondMunicipalityAddress);
        municipality.addMuni(
            thirdMunicipalityAddress,
            thirdMunicipalityZipCode
        );
    }

    /* Depositor Tests */
    uint64 searchID;
    uint64 greenerIndex;

    function testRegisterDepositor() external {
        // Not working
        vm.startPrank(RecyclerAddress);
        depositor.registerRecycler("John Doe");
        searchID = depositor.getIdByAddress(RecyclerAddress);
        vm.stopPrank();
        console.log("Search ID: ", searchID);

        assert(searchID != 0);
    }

    function testGetIDByAddress() external {
        // Not working
        // testRegisterDepositor();
        vm.prank(RecyclerAddress);
        depositor.registerRecycler("John Doe");

        searchID = depositor.getIdByAddress(RecyclerAddress);
        console.log("Search ID: ", searchID);
        // User's ID starts at 1.
        assert(searchID > 0);
    }

    function testGetGreenerIndexByID() external {
        // Not working
        searchID = depositor.getIdByAddress(RecyclerAddress);
        greenerIndex = depositor._getGreenerIndexByID(searchID);
        console.log("Greener Index: ", greenerIndex);
    }

    /* Machine Tests */

    function testCreateEuniceMachine() external {
        vm.prank(GenesisMunicipalityAddress);
        machine.createMachine(MachineAddress, GenesisMunicipalityZipCode);
    }

    // Setting a mock address for the second machine.
    address secondMachineAddress = makeAddr("secondMachine");

    function testCreateLafayetteMachine() external {
        vm.prank(secondMunicipalityAddress);
        machine.createMachine(secondMachineAddress, secondMunicipalityZipCode);
    }

    function testFailCreateMachine() external {
        vm.prank(RecyclerAddress);
        machine.createMachine(MachineAddress, GenesisMunicipalityZipCode);
    }

    address randomUser = makeAddr("randomUser");

    function testFailCreateAnotherMachine() external {
        vm.prank(randomUser);
        machine.createMachine(MachineAddress, GenesisMunicipalityZipCode);
    }

    function testDepositBottles() external {
        // Error - recycler not registered
        vm.prank(RecyclerAddress);
        machine.depositBottles(1, 10);
    }

    function testTokensEqualsTwoTimesBottlesDeposited() external {
        vm.prank(RecyclerAddress);
        machine.depositBottles(1, 20);
        assert(ecoCoin.balanceOf(RecyclerAddress) == 40);
    }

    // Test cool down timer.

    function testFailDepositMoreThan200Bottles() external {
        // Should fail since the recycler can't deposit more than 200 bottles at once.
        // Should get: Machine__CannotDepositMoreThan200BottlesAtOnce
        vm.prank(RecyclerAddress);
        machine.depositBottles(1, 201);
    }

    function testFailDepositZeroBottles() external {
        // Should fail since the recycler can't deposit zero bottles.
        // Should get: Machine__BottlesNumberToDepositMustBeGreaterThanZero
        vm.prank(RecyclerAddress);
        machine.depositBottles(1, 0);
    }

    function testFailRandomUserDepositBottles() external {
        // Should fail since the random user is not registered.
        vm.prank(randomUser);
        machine.depositBottles(1, 10);
    }

    function testSpendTokensAtShop() external {
        // Depositor__RecyclerNotRegistered
        // Spend tokens at the shop so we can test that the shop can redeem tokens.
        vm.prank(RecyclerAddress);
        // Does the recycler have tokens from previous functions? Or should we give him tokens at the start of this function?
        spender.purchaseGoods(1, 10);
    }

    function testFailSpendTokensAtShops() external {
        vm.prank(randomUser);
        spender.purchaseGoods(1, 10);
    }

    string shopCashAppUserName = "CafeMosaic";

    function testRedeemTokens() external {
        vm.prank(ShopAddress);
        machine.redeemTokens(1, shopCashAppUserName, 10);
    }

    function testFailShopRedeemsTokensBiggerThanBalance() external {
        // Should fail since the shop doesn't have enough tokens to redeem.
        // Should get: Machine__InsufficientTokensBalanceToRedeem
        vm.prank(ShopAddress);
        machine.redeemTokens(1, shopCashAppUserName, 1000);
    }

    function testFailShopRedeemsTokensMoreThan9999() external {
        // Should fail since the shop can't redeem more than 9999 tokens.
        // Should get: Machine__CannotRedeemMoreThan9999TokensAtOnce
        vm.prank(ShopAddress);
        machine.redeemTokens(1, shopCashAppUserName, 10000);
    }

    function testFailShopRedeemsZeroTokens() external {
        // Should fail since the shop can't redeem zero tokens.
        // Should get: Machine__RedeemedTokensMustBeGreaterThanZero
        vm.prank(ShopAddress);
        machine.redeemTokens(1, shopCashAppUserName, 0);
    }

    function testFailRandomUserRedeemTokens() external {
        // Should fail since only registered shop can redeem tokens.
        // Should get: ShopHandler__ShopNotRegisteredOrApproved
        vm.prank(randomUser);
        machine.redeemTokens(1, shopCashAppUserName, 10);
    }

    function testFailRecyclerRedeemTokens() external {
        // Should fail since only registered shop can redeem tokens.
        // Should get: ShopHandler__ShopNotRegisteredOrApproved
        vm.prank(RecyclerAddress);
        machine.redeemTokens(1, "Bad Hacker", 100);
    }
}
