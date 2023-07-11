// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Muni, MuniData} from "./Municipality.sol";
import {IEcoCoin} from "./IEcoCoin.sol"; // EcoCoin Interface
import {Depositor} from "./Depositor.sol";

error Machine__CallerIsNotMachine();
error Machine__BottlesNumberToDepositMustBeGreaterThanZero();
error Machine__CannotDepositMoreThan200BottlesAtOnce();
error Machine__CoolDownTimerHasntPassed();

contract Machine is MuniData {
    // What will the machine do?
    /*  1. Exchange bottles for tokens
            a. Receive bottles from recycler
            b. Mint tokens
            c. Send tokens to recycler

        2. Redeem tokens for real value
            a. Receive tokens from shop
            b. Check for Real Money (RM) funds amount.
                i. If funds are available, send money to shop
                ii. If insufficient funds, withdraw from municipality real money (RM) wallet.
            c. Exchange tokens for money
            d. Send money to shop using a payment processor (venmo, cashapp, etc.); i.e. CashApp can generate a QR code to scan. [CashApp API](https://developers.cash.app/docs/api/welcome)
            e. Burn tokens
    */

    struct exchangeMachine {
        uint64 exMachineID; // ID of machines, starts at 1.
        string exMachineZipCode; // Zip code of the Municipality, even if the machine is not in the same exact zip code of the municipality.
        address exMachineAddress; // Tokens wallet address.
        uint256 exMachineRMBalance; // Real Money (RM) balance of the machine.
    }

    // Array of all exchange machines using the exchangeMachine struct
    exchangeMachine[] public exchangeMachines;
    mapping(address => uint64) public exMachineAddressToID;
    mapping(uint64 => address) private exMachineIDToAddress;

    uint256 private immutable i_CoolDownInterval; // Interval of cool down for time between deposits (1 hour).

    IEcoCoin private immutable ecoCoin; // Calling the interface of the EcoCoin contract.
    Depositor depositor = new Depositor();

    /**
     * @notice  Modifier that lets only a machine to act.
     * @dev     Checks if the machine exists in the exMachineAddresstoID mapping.
     */
    modifier machineOnly() {
        if (exMachineAddressToID[msg.sender] == 0) {
            revert Machine__CallerIsNotMachine();
        }
        _;
    }

    constructor(address _ecoCoinAddr) {
        // Not sure whether it's more gas efficient to deploy the interface or the contract itself; a problem for future fixes.
        ecoCoin = IEcoCoin(_ecoCoinAddr);
        i_CoolDownInterval = 3600; // Should be one hour, MAKE SURE LATER
        //! Make sure block.timestanp is in seconds.
    }

    /**
     * @notice  Create a new exchange machine.
     * @dev     Address of machine should be created prior to calling this function.
     * @return  uint256  ID of the new exchange machine.
     */
    function createMachine(
        string memory _exMZip,
        address _exMAddress
    ) public muniOnly returns (uint256) {
        exchangeMachine memory newMachine = exchangeMachine({
            exMachineID: uint64(exchangeMachines.length),
            exMachineZipCode: _exMZip,
            exMachineAddress: _exMAddress,
            exMachineRMBalance: ecoCoin.balanceOf(_exMAddress) // Should get the balance from the wallet's address.
        });
        exchangeMachines.push(newMachine); // Add the new machine to the array of all machine
        exMachineAddressToID[_exMAddress] = newMachine.exMachineID; // Add the new machine to the mapping of Machine's address and its ID.
        return newMachine.exMachineID;
    }

    /**
     * @notice  Deposits tokens into the recycler's account, according to the amount of bottles deposited.
     * @dev     DANGEROUS IMPLEMENTATION!!!
     * @dev     Currently this function has no limitations on who can call it; currently this is okay since we're assuming that in "realistic" implementation, only the machine will have access to this function.
     * @dev     Maybe it's all okay, because in a realistic scenario, we can assume that the recycler will only have to these functions when he's at a physical machine.
     * @param exMachineAddress Address of the machine that will be used for minting and transferring.
     * @param   _recyAddr  Address of the recycler.
     * @param   _amtBottles  Amount of bottles to deposit.
     * @return  bool  True if the operation was successful.
     */
    function _depositTokens(
        address exMachineAddress,
        address _recyAddr,
        uint _amtBottles
    ) private returns (bool) {
        //? Is the process of minting to the machine and then transferring immediately redundant? Can I just mint directly to the recycler?
        uint256 _bottlesToTokens = _amtBottles * 2; // Each bottle is 2 coins.

        ecoCoin._mint(exMachineAddress, _bottlesToTokens); // Mint the spent amount of tokens to the machine.

        ecoCoin._transfer(exMachineAddress, _recyAddr, _bottlesToTokens); // Transfer the tokens from the machine to the recycler.
        return true;
        // Problematic that only machine can call this, because the recycler calls the deposit bottles function.
    }

    /**
     * @notice  Lets a recycler deposits bottles through a machine and receive tokens in exchange.
     * @dev     Verification of depositions should be entered in the future.
     * @dev     As of right now, when depositing bottles, user must specify the machine ID. This is a little bit complicated for the user, but I'm assuming that there will be several machines at each ZipCode, so I don't want to rely soley on that.
     * @dev     Please implement a front end feature to get all machines in a zip code, using the array of all exchange machines (exchangeMachines).
     * @dev     Should be called only be a registered depositor.
     * @dev     Since there is no "real" verification of bottles, this function can be easily exploited, since anyone can call it and mint infinite tokens.
     * @param   _exMachineID  ID of the exchange machine to be used.
     * @param   _bottles  Amount of bottles to deposit.
     * @return  bool  True if successfully deposited, false otherwise.
     * @return  string  String indication of success / failure.
     */
    function depositBottles(
        uint64 _exMachineID,
        uint64 _bottles
    ) public returns (bool, string memory) {
        if (_bottles <= 0) {
            revert Machine__BottlesNumberToDepositMustBeGreaterThanZero();
        }
        if (_bottles > 200) {
            revert Machine__CannotDepositMoreThan200BottlesAtOnce();
        }

        address _recyAddr = msg.sender;
        // Checks if recycler is registered.
        if (depositor.recyclerToID[_recyAddr] == 0) {
            revert depositor.Depositor__NotRegistered();
        }
        // Enter here check of last deposited time to allow deposits in at least one hour cool down.
        // Maybe let user in front end to make some kind of verification, to add some fake security to the process.
        uint64 _recyID = depositor.recyclerToID[_recyAddr]; // Get the recycler's ID from the corresponding mapping, using his address; will receive a real address, otherwise it will indicate that the recycler is not registered.
        uint64 _recyIndex = uint64(depositor._getGreenerIndexByID(_recyID));
        uint256 recyLastTimeStamp = depositor
            .greeners[_recyIndex]
            .lastTimeStamp;
        // Check here if enough time has passed since the last recycler's deposition.
        if ((block.timestamp - recyLastTimeStamp) < i_CoolDownInterval) {
            revert Machine__CoolDownTimerHasntPassed();
        }

        depositor.greeners[_recyIndex].bottlesDepo = _bottles; // Update the number of bottles requested to deposit in the greeners array; (note - this is NOT approved bottles).
        // Do some clever checks here to verify the deposition; after verification, set the status of the deposition in greeners to 'true'.
        /*
            Saved space for validating the number of bottles.
        */
        depositor.greeners[_recyIndex].status = true; // Change the status of tthe deposition in the array to true (meaning approved).

        // After deposition was verified, update the recycler's last deposition time.
        depositor.greeners[_recyIndex].lastTimeStamp = block.timestamp;

        depositor.recyclerBottles[_recyAddr] = _bottles; // Only here the bottles are added to the mapping object.
        depositor.greeners[_recyIndex].recyBalance = ecoCoin.balanceOf(
            _recyAddr
        ); // Set the balance in the greeners array to the tokens balance of the account.
        address _exMachineAddress = exMachineIDToAddress[_exMachineID];
        _depositTokens({
            exMachineAddress: _exMachineAddress,
            _recyAddr: _recyAddr,
            _amtBottles: _bottles
        });
        return (true, "Desposited!");
        /*
            After creating the verification, if the verification has failed, return false and set the status to false as well.
            depositor.greeners[_recyIndex].status = false;
            return (false, "Denied ;(");
        */
    }
}
