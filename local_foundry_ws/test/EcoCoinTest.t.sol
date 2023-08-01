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
import {ShopHandler} from "../src/ShopHandler.sol";

contract EcoCoinTest is StdCheats, Test {
    EcoCoin public ecoCoin;
    HelperConfig public helperConfig;
    Municipality public municipality;
    Depositor public depositor;
    Machine public machine;
    Spender public spender;
    ShopHandler public shopHandler;

    address ContractOwner;
    address GenesisMunicipalityAddress;
    string GenesisMunicipalityZipCode;
    address RecyclerAddress;
    address ShopAddress;
    address MachineAddress;
    address secondMunicipalityAddress;
    string constant secondMunicipalityZipCode = "70501";

    function setUp() external {
        DeployEcoCoin deployer = new DeployEcoCoin();
        (
            ecoCoin,
            helperConfig,
            depositor,
            machine,
            spender,
            shopHandler,
            municipality
        ) = deployer.run();

        (
            ContractOwner,
            GenesisMunicipalityAddress,
            GenesisMunicipalityZipCode,
            RecyclerAddress,
            ShopAddress,
            MachineAddress,
            secondMunicipalityAddress
        ) = helperConfig.activeNetworkConfig();
    }

    /* EcoCoin Tests */

    function addGenesisMunicipality() private {
        vm.prank(ContractOwner);
        ecoCoin.addGenMuni(
            GenesisMunicipalityAddress,
            GenesisMunicipalityZipCode
        );
    }

    function testAddGenesisMunicipality() external {
        addGenesisMunicipality();
    }

    function testRevertAddGenesisMuni_MuniAlreadyAdded() external {
        addGenesisMunicipality();
        // Should fail since the genesis municipality is already added.
        vm.expectRevert(EcoCoin.EcoCoin__genMunicipalityIsSet.selector);
        vm.prank(ContractOwner);
        ecoCoin.addGenMuni(
            GenesisMunicipalityAddress,
            GenesisMunicipalityZipCode
        );
    }

    function testRevertAddGenesisMuni_CallerIsNotOwner() external {
        // Should fail since the caller is not the deployer.
        // Should get: Ownable: caller is not the owner
        addGenesisMunicipality();
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
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

    function testAgainDecimalsEqualToZero() external {
        uint8 _decimals = ecoCoin.decimals();
        assertEq(_decimals, 0);
    }

    function testHasGenesisMunicipalityAddedProperly() external {
        addGenesisMunicipality();
        assert(
            keccak256(
                abi.encodePacked(
                    municipality.MuniAddrToZipCode(GenesisMunicipalityAddress)
                )
            ) == keccak256(abi.encodePacked(GenesisMunicipalityZipCode))
        );
    }

    function testGenesisMunicipalityIsNotEmpty() external {
        addGenesisMunicipality();
        assert(
            keccak256(
                abi.encodePacked(
                    municipality.MuniAddrToZipCode(GenesisMunicipalityAddress)
                )
            ) != keccak256(abi.encodePacked(""))
        );
    }

    function testTokenNameIsCorrect() external view {
        assert(
            keccak256(abi.encodePacked(ecoCoin.name())) == keccak256("EcoCoin")
        );
    }

    function testTokenSymbolIsCorrect() external view {
        assert(
            keccak256(abi.encodePacked(ecoCoin.symbol())) == keccak256("ECC")
        );
    }

    function testTokenTotalSupplyIsZero() external view {
        assert(ecoCoin.totalSupply() == 0);
    }

    function testTokenBalanceOfDeployerIsZero() external view {
        assert(ecoCoin.balanceOf(ContractOwner) == 0);
    }

    function testTokenBalanceOfGenesisMunicipalityIsZero() external view {
        assert(ecoCoin.balanceOf(GenesisMunicipalityAddress) == 0);
    }

    function testMintTokensToGenesisMunicipality() external {
        addGenesisMunicipality();
        ecoCoin.mint(GenesisMunicipalityAddress, 100);
        assertEq(ecoCoin.balanceOf(GenesisMunicipalityAddress), 100);
    }

    function testBurnTokensFromGenesisMunicipality() external {
        addGenesisMunicipality();
        ecoCoin.mint(GenesisMunicipalityAddress, 100);
        ecoCoin.burn(GenesisMunicipalityAddress, 100);
        assertEq(ecoCoin.balanceOf(GenesisMunicipalityAddress), 0);
    }

    event AddedMunicipality(
        address indexed municipalityAddr,
        string indexed municipalityZipCode,
        address indexed addedBy
    );

    //TODO - Fix events testing.
    // function testEmitAddedMunicipalityEvent() external {
    //     //! Event fails, fix later.
    //     vm.expectEmit(true, true, true, true);
    //     addGenesisMunicipality();
    // }

    /* Municipality Tests */

    function addSecondMunicipality() private {
        addGenesisMunicipality();
        vm.prank(GenesisMunicipalityAddress);
        municipality.addMuni(
            secondMunicipalityAddress,
            secondMunicipalityZipCode
        );
    }

    function testAddMuni() external {
        addSecondMunicipality();
        console.log("Genesis muni address: ", GenesisMunicipalityAddress);
        console.log(
            "Zip Code of genesis municipality: ",
            municipality.MuniAddrToZipCode(GenesisMunicipalityAddress)
        );
    }

    function testSecondMunicipalityAdded() external {
        addSecondMunicipality();
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
        addSecondMunicipality();
        vm.prank(secondMunicipalityAddress);
        municipality.addMuni(
            thirdMunicipalityAddress,
            thirdMunicipalityZipCode
        );
    }

    function testRecyclerTriesToAddMuni() external {
        // Should fail since the recycler is not a municipality.
        // Should get: Municipality__NotMunicipality
        addSecondMunicipality();
        vm.prank(RecyclerAddress);
        vm.expectRevert(
            abi.encodeWithSelector(
                Municipality.Municipality__NotMunicipality.selector,
                RecyclerAddress
            )
        );
        municipality.addMuni(
            secondMunicipalityAddress,
            secondMunicipalityZipCode
        );
    }

    function testRevertUpdateMuniZipCode() external {
        addSecondMunicipality();
        vm.prank(GenesisMunicipalityAddress);
        vm.expectRevert(
            Municipality
                .Municipality__GenesisMunicipalityHasBeenSet_MappingIsNotEmpty
                .selector
        );
        municipality.updateMuniZipCode(
            thirdMunicipalityAddress,
            thirdMunicipalityZipCode
        );
    }

    function testNumMunicipalityUpdated() external {
        // Fails because EcoCoin doesn't add correctly the genesis municipality the the mapping.
        console.log(
            "Num municipalities before call: ",
            municipality.numMunicipalities()
        ); // 0
        addSecondMunicipality();
        console.log(
            "Num municipalities after call: ",
            municipality.numMunicipalities()
        ); // 1
        assertEq(municipality.numMunicipalities(), 2);
    }

    function testNumMunicipalitiesIsZero() external {
        assertEq(municipality.numMunicipalities(), 0);
    }

    function testManualIncrementNumMunicipalities() external {
        municipality.incrementNumMunicipalities();
        assertEq(municipality.numMunicipalities(), 1);
    }

    function testRemoveShop() external {
        genMuniApprovesShopRegistration(1);
        vm.prank(secondMunicipalityAddress);
        shopHandler.removeShop(1, true);
    }

    function testInvalidRemoveShopDecision() external {
        genMuniApprovesShopRegistration(1);
        vm.prank(secondMunicipalityAddress);
        vm.expectRevert(ShopHandler.ShopHandler__InvalidCommand.selector);
        shopHandler.removeShop(1, false);
    }

    function testGetArraysAndData() external {
        genMuniApprovesShopRegistration(1);
        shopHandler.printShopName();
        shopHandler.getShops();
        shopHandler.getShopName(ShopAddress);
    }

    function testUpdateShopBalanceEqualsItsBalance() external {
        genMuniApprovesShopRegistration(1);
        shopHandler.updateShopBalance(0, ShopAddress);
        assertEq(
            shopHandler.getShops()[0].shopBalance,
            ecoCoin.balanceOf(ShopAddress)
        );
    }

    /* Depositor Tests */
    uint64 searchID;
    uint64 greenerIndex;

    function registerRecycler() private {
        addSecondMunicipality();
        vm.prank(RecyclerAddress);
        depositor.registerRecycler("John Green");
    }

    function testRegisterRecycler() external {
        registerRecycler();
        searchID = depositor.getIdByAddress(RecyclerAddress);
        console.log("Search ID: ", searchID);

        assert(searchID != 0);
    }

    function testGetIDByAddress() external {
        registerRecycler();
        searchID = depositor.getIdByAddress(RecyclerAddress);
        console.log("Search ID: ", searchID);
        // User's ID starts at 1.
        assert(searchID > 0);
    }

    function testGetGreenerIndexByID() external {
        registerRecycler();
        searchID = depositor.getIdByAddress(RecyclerAddress);
        greenerIndex = depositor._getGreenerIndexByID(searchID);
        console.log("Greener Index: ", greenerIndex);
    }

    function testUpdateRecyBalance() external {
        registerRecycler();
        uint64 recyID = depositor.getIdByAddress(RecyclerAddress);
        depositor.updateRecyBalance(recyID);
    }

    function testGetGreenersArray() external {
        registerRecycler();
        depositor.getGreeners();
    }

    function testGetGreeners_WithData() external {
        registerRecycler();
        uint64 recyID = depositor.getIdByAddress(RecyclerAddress);
        uint64 recyIndex = depositor._getGreenerIndexByID(recyID);
        uint256 lastTimeStamp = depositor
        .getGreeners()[recyIndex].lastTimeStamp;
        console.log("Last time stamp: ", lastTimeStamp);
        assertEq(lastTimeStamp, 1);
    }

    function testRevertGreenerIndexByID_DNE() external {
        registerRecycler();
        vm.expectRevert(Depositor.Depositor__GreenerID_DoesNotExist.selector);
        depositor._getGreenerIndexByID(100);
    }

    function testGetRecyclerAddresToID() external {
        registerRecycler();
        depositor.recyclerToID(RecyclerAddress);
    }

    // TODO - Add RecyclerRegistered event test.

    /* Machine Tests */

    function createEuniceMachine() private {
        registerRecycler();
        vm.startPrank(GenesisMunicipalityAddress);
        console.log(municipality.MuniAddrToZipCode(GenesisMunicipalityAddress));
        console.log(
            bytes(municipality.MuniAddrToZipCode(GenesisMunicipalityAddress))
                .length
        );
        machine.createMachine(MachineAddress, GenesisMunicipalityZipCode);
        console.log("Genesis muni address: ", GenesisMunicipalityAddress);

        vm.stopPrank();
    }

    function testCreateEuniceMachine() external {
        createEuniceMachine();
    }

    // Setting a mock address for the second machine.
    address secondMachineAddress = makeAddr("secondMachine");

    function testCreateLafayetteMachine() external {
        createEuniceMachine();
        vm.prank(secondMunicipalityAddress);
        machine.createMachine(secondMachineAddress, secondMunicipalityZipCode);
    }

    function testFailCreateMachine() external {
        createEuniceMachine();
        vm.prank(RecyclerAddress);
        machine.createMachine(MachineAddress, GenesisMunicipalityZipCode);
    }

    address randomUser = makeAddr("randomUser");

    function testFailCreateAnotherMachine() external {
        vm.prank(randomUser);
        machine.createMachine(MachineAddress, GenesisMunicipalityZipCode);
    }

    function recyclerDepositBottles() private {
        createEuniceMachine();
        vm.warp(3602); // One hour + initial block timestamp
        vm.prank(RecyclerAddress);
        machine.depositBottles(1, 10);
    }

    function testDepositBottles() external {
        recyclerDepositBottles();
        assertEq(ecoCoin.balanceOf(RecyclerAddress), 20);
    }

    function testRevertTimeStampHasntPassed() external {
        recyclerDepositBottles();
        vm.expectRevert(Machine.Machine__CoolDownTimerHasntPassed.selector);
        vm.warp(10); // Not enough time has passed
        vm.prank(RecyclerAddress);
        machine.depositBottles(1, 10);
    }

    function testRevertDepositMoreThan200Bottles() external {
        recyclerDepositBottles();
        vm.expectRevert(
            Machine.Machine__CannotDepositMoreThan200BottlesAtOnce.selector
        );
        vm.prank(RecyclerAddress);
        machine.depositBottles(1, 201);
    }

    function testRevertDepositZeroBottles() external {
        recyclerDepositBottles();
        vm.expectRevert(
            Machine
                .Machine__BottlesNumberToDepositMustBeGreaterThanZero
                .selector
        );
        vm.prank(RecyclerAddress);
        machine.depositBottles(1, 0);
    }

    function testFailRandomUserDepositBottles() external {
        recyclerDepositBottles();
        vm.prank(randomUser);
        machine.depositBottles(1, 10);
    }

    function testRevertNonExistentUserDepositBottles() external {
        recyclerDepositBottles();
        vm.expectRevert(Machine.Depositor__RecyclerNotRegistered.selector);
        vm.prank(address(1));
        machine.depositBottles(1, 100);
    }

    function requestShopRegistration() private {
        recyclerDepositBottles();
        vm.prank(ShopAddress);
        shopHandler.registerShop("Cafe Mosaic", "Cafe", "70535");
    }

    function genMuniApprovesShopRegistration(uint64 _shopID) private {
        requestShopRegistration();
        vm.prank(GenesisMunicipalityAddress);
        shopHandler.approveShop(_shopID, true);
    }

    function secondMuniApprovesShopRegistration(uint64 _shopID) private {
        requestShopRegistration();
        vm.prank(secondMunicipalityAddress);
        shopHandler.approveShop(_shopID, true);
    }

    function testMuniDeniesShopRegistration() external {
        requestShopRegistration();
        vm.prank(GenesisMunicipalityAddress);
        shopHandler.approveShop(1, false);
    }

    //TODO - Test to see if unregistered shop can perform actions.
    //TODO - Check event properly emitted.

    function testShopRequestedToRegister() external {
        requestShopRegistration();
    }

    function testGenMuniApprovedShopRegistration() external {
        genMuniApprovesShopRegistration(1);
    }

    function testSecondMuniApprovedShopRegistration() external {
        secondMuniApprovesShopRegistration(1);
    }

    function spendTokensAtShop() private {
        genMuniApprovesShopRegistration(1);
        vm.startPrank(RecyclerAddress);
        ecoCoin.approve(address(spender), 10);
        spender.purchaseGoods(1, 10);
        vm.stopPrank();
    }

    function testSpendTokensAtShop() external {
        spendTokensAtShop();
    }

    function testRevertRecyclerTriesToPayMoreTokensThanBalance() external {
        spendTokensAtShop();
        vm.expectRevert(Spender.Spender__InsufficientFundsToSpend.selector);
        vm.startPrank(RecyclerAddress);
        spender.purchaseGoods(1, 100);
        vm.stopPrank();
    }

    function testRevertRandomUserTriesToSpendTokens() external {
        genMuniApprovesShopRegistration(1);
        vm.startPrank(randomUser);
        ecoCoin.approve(address(spender), 10);
        vm.expectRevert(Spender.Depositor__RecyclerNotRegistered.selector);
        spender.purchaseGoods(1, 10);
        vm.stopPrank();
    }

    function testShopBalanceEqualsTokensSent() external {
        spendTokensAtShop();
        assertEq(ecoCoin.balanceOf(ShopAddress), 10);
    }

    function shopRedeemsTokens() private {
        spendTokensAtShop();
        vm.prank(ShopAddress);
        machine.redeemTokens(1, "CafeMosaic", 10);
    }

    function testShopCanRedeemTokens() external {
        shopRedeemsTokens();
    }

    function testShopBalanceLessTokensRedeemed() external {
        shopRedeemsTokens();
        assertEq(ecoCoin.balanceOf(ShopAddress), 0);
    }

    function testRevertShopTriesToRedeemMoreTokensThanBalance() external {
        shopRedeemsTokens();
        vm.expectRevert(
            Machine.Machine__InsufficientTokensBalanceToRedeem.selector
        );
        vm.prank(ShopAddress);
        machine.redeemTokens(1, "CafeMosaic", 12);
    }

    function testRandomUserTriesToRedeemTokens() external {
        shopRedeemsTokens();
        vm.prank(randomUser);
        vm.expectRevert(
            Machine.ShopHandler__ShopNotRegisteredOrApproved.selector
        );
        machine.redeemTokens(1, "CafeMosaic", 10);
    }

    // Test events.

    function testFailSpendTokensAtShops() external {
        vm.prank(randomUser);
        spender.purchaseGoods(1, 10);
    }

    string shopCashAppUserName = "CafeMosaic";

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

    /* ShopHandler Tests */

    function testGetShopName() external {
        shopRedeemsTokens();
        string memory shopName = shopHandler.getShopName(ShopAddress);
        console.log("Shop name: ", shopName);
    }
}
