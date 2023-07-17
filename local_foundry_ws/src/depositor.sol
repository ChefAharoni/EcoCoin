// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {EcoCoin} from "./EcoCoin.sol";

/**
 * @author  ChefAharoni
 * @title   Contract of the deposition of bottles.
 * @dev     Development is not complete, should change the whole method of this contract.
 * @notice  Manages the deposition of bottles.
 */
contract Depositor {
    error Depositor__RecyclerNotRegistered(); // Error to throw when the caller is not registered.

    EcoCoin ecoCoin = new EcoCoin();

    struct Recylcer {
        uint64 ID; // Starts at 1; 64 bits to save on gas; perhaps in the future think of a better way to generate an ID.
        string recyName; // Name of recycler.
        address recyAddr; // Address of recycler.
        uint64 bottlesDepo; // Amount of bottles deposited.
        uint256 recyBalance; // Tokens balance of user.
        uint256 lastTimeStamp; // Last time recycler had deposited; used for cooldown.
        bool status; // Bottles approved or denied.
    }

    Recylcer[] public greeners;
    // mapping(address recycler => uint64 bottlesAmt) public recyclerBottles; // Mapping of addresses and their deposited bottles; added only when their bottles are confirmed. - 0713 update: maybe I don't need this mapping anymore?
    // Since the machine auto-approves the amount of bottles.
    mapping(address recycler => uint64 recyID) public recyclerToID; // Mapping of addresses and their ID's.

    /**
     * @notice  Registers the recycler to the system.
     * @dev     .
     * @param   _name  Name of the recycler.
     */
    function registerRecycler(string memory _name) public {
        address _recyAddr = msg.sender;
        uint64 _recyID = uint64(greeners.length + 1); // uint64 must be declared at the end because it is by default uint256.
        recyclerToID[_recyAddr] = _recyID; // Add the ID of the recycler to associate with his address.

        greeners.push(
            Recylcer({
                ID: _recyID,
                recyName: _name,
                recyAddr: _recyAddr,
                bottlesDepo: 0,
                recyBalance: ecoCoin.balanceOf(_recyAddr),
                lastTimeStamp: 0,
                status: false
            })
        );
    }

    /**
     * @notice  Gets the index of the array by its ID.
     * @dev     .
     * @param   searchID  ID of the array to search for.
     * @return  uint64  Index of the array in the greeners array.
     */
    function _getGreenerIndexByID(
        uint64 searchID
    ) public view returns (uint64) {
        // Finds an array's index by its ID; should be internal, doesn't work for some reason (maybe because I'm inherting this contract as instance and not with "is").
        // I had to create another duplicate of the function because I couldn't define an array as the function's parameter.
        // Setting it public so it can be used in spender contract as well. (maybe not?)
        for (uint64 i = 0; i < greeners.length; i++) {
            if (greeners[i].ID == searchID) {
                return i;
            }
        }
        revert("ID not found");
    }

    /**
     * @notice  Gets the recycler's ID by his address.
     * @dev     Used for external contracts.
     * @param   _recyAddr  Address of the recycler.
     * @return  uint64  ID of the recycler.
     */
    function getIdByAddress(address _recyAddr) external view returns (uint64) {
        // For external contracts, extract the recycler's ID from his address.
        return recyclerToID[_recyAddr];
    }

    /**
     * @notice  Gets the array of the greeners to interact with.
     * @dev     Used for external contracts.
     * @return  Recylcer[]  Array of the greeners.
     */
    function getGreeners() external view returns (Recylcer[] memory) {
        return greeners;
    }

    /**
     * @notice  Update the balance of the recycler in the greeners array.
     * @dev     .
     * @param   _recyID  ID of the recycler.
     * @return  bool  True if the operation was successful.
     */
    function updateRecyBalance(uint64 _recyID) public returns (bool) {
        uint64 _recyIndex = uint64(_getGreenerIndexByID(_recyID));
        greeners[_recyIndex].recyBalance = ecoCoin.balanceOf(
            greeners[_recyIndex].recyAddr
        );
        return true;
    }
}
