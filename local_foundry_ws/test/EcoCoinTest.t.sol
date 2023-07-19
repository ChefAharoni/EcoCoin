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
    // Depositor depositor = new Depositor();
    // Machine machine = new Machine(address(ecoCoin));
    // Spender spender = new Spender(address(ecoCoin));

    address contractDeployer = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;

    address GenesisMunicipalityAddress;
    string GenesisMunicipalityZipCode;
    address RecyclerAddress;
    address ShopAddress;
    address MachineAddress;
    address secondMunicipalityAddress;
    string secondMunicipalityZipCode;

    function setUp() external {
        // depositor = new Depositor();
        DeployEcoCoin deployer = new DeployEcoCoin();
        (
            ecoCoin,
            helperConfig,
            depositor,
            machine,
            spender,
            shopHandler
        ) = deployer.run();

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

    function addGenesisMunicipality() private {
        vm.prank(contractDeployer);
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
        vm.prank(contractDeployer);
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
        assert(ecoCoin.balanceOf(contractDeployer) == 0);
    }

    function testTokenBalanceOfGenesisMunicipalityIsZero() external view {
        assert(ecoCoin.balanceOf(GenesisMunicipalityAddress) == 0);
    }

    event AddedMunicipality(
        address indexed municipalityAddr,
        string indexed municipalityZipCode,
        address indexed addedBy
    );

    //TODO - Fix events testing.
    function testEmitAddedMunicipalityEvent() external {
        //! Event fails, fix later.
        addGenesisMunicipality();
        vm.expectEmit();
        emit AddedMunicipality(
            GenesisMunicipalityAddress,
            GenesisMunicipalityZipCode,
            contractDeployer
        );
    }

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
        vm.expectRevert(Municipality.Municipality__NotMunicipality.selector);
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

    /* Depositor Tests */
    uint64 searchID;
    uint64 greenerIndex;

    function registerRecycler() private {
        addSecondMunicipality();
        vm.prank(RecyclerAddress);
        depositor.registerRecycler("John Doe");
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
        assertEq(lastTimeStamp, 0);
    }

    function testGetRecyclerAddresToID() external {
        registerRecycler();
        depositor.recyclerToID(RecyclerAddress);
    }

    // TODO - Add RecyclerRegistered event test.

    /* Machine Tests */

    function caller() external view {
        console.log("Caller: ", msg.sender);
    }

    function createEuniceMachine() private {
        // this.caller();
        registerRecycler();
        vm.startPrank(GenesisMunicipalityAddress);
        console.log(municipality.MuniAddrToZipCode(GenesisMunicipalityAddress));
        console.log(bytes(municipality.MuniAddrToZipCode(GenesisMunicipalityAddress)).length);
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

    function testDepositBottles() external {
        createEuniceMachine();
        vm.prank(RecyclerAddress);
        machine.depositBottles(1, 10);
    }

    function testTokensEqualsTwoTimesBottlesDeposited() external {
        createEuniceMachine();
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
        createEuniceMachine();
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
        // A shop needs to be registered and approved first.
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
