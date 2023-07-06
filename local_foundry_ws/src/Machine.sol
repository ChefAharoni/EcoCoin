// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Muni, MuniData} from "./Municipality.sol";

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
        uint64 exMachineID;
        string exMachineZipCode; // Zip code of the Municipality, even if the machine is not in the same exact zip code of the municipality.
        address exMachineAddress; // Tokens wallet address.
        uint256 exMachineRMBalance; // Real Money (RM) balance of the machine.
    }

    // Array of all exchange machines using the exchangeMachine struct
    exchangeMachine[] public exchangeMachines;

    /**
     * @notice  Create a new exchange machine.
     * @dev     Address of machine should be created prior to calling this function.
     * @return  uint256  ID of the new exchange machine.
     */
    function createMachine(
        string memory _exZip,
        address _exAddress
    ) public muniOnly returns (uint256) {
        exchangeMachine memory newMachine = exchangeMachine({
            exMachineID: uint64(exchangeMachines.length),
            exMachineZipCode: _exZip,
            exMachineAddress: _exAddress,
            exMachineRMBalance: 0 // Should get the balance from the wallet's address.
        });
        exchangeMachines.push(newMachine);
        return newMachine.exMachineID;
    }
}
