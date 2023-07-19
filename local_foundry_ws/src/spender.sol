// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
// import {EcoCoin} from "./EcoCoin.sol";

import {IEcoCoin} from "./IEcoCoin.sol"; // EcoCoin Interface
import {Depositor} from "./Depositor.sol";
import {ShopHandler} from "./ShopHandler.sol";

contract Spender {
    /* Errors */
    error Spender__InsufficientFunds(); // Error to throw when the spender doesn't have enough tokens to spend.
    error Depositor__RecyclerNotRegistered(); // Error to throw when the recycler is not registered.

    // When a recycler wishes to spend his tokens in a local shop: Cafe, Restaurant, Clothes store, etc...
    IEcoCoin private immutable ecoCoin; // Calling the interface of the EcoCoin contract.
    Depositor depositor;
    ShopHandler shopHandler;

    /* Events */
    event GoodsPurchased(
        uint64 indexed shopID,
        address shopAddress,
        address indexed recyAddr,
        uint256 indexed spendAmount
    );

    constructor(address _ecoCoinAddr, address _depositorAddr, address _shopHandlerAddr) {
        // Not sure whether it's more gas efficient to deploy the interface or the contract itself; a problem for future fixes.
        ecoCoin = IEcoCoin(_ecoCoinAddr); // Address of the EcoCoin contract.
        depositor = Depositor(_depositorAddr);
        shopHandler = ShopHandler(_shopHandlerAddr);
    }

    function purchaseGoods(
        uint64 shopID,
        uint256 _spendAmount
    ) public returns (bool) {
        // In the front-end app, display all the approved shops with their IDs.

        address _recyAddr = msg.sender;

        // Maybe let user in front end to make some kind of verification, to add some fake security to the process.
        uint64 _recyID = depositor.getIdByAddress(_recyAddr);

        // Checks if recycler is registered.
        if (_recyID == 0) {
            revert Depositor__RecyclerNotRegistered();
        }

        uint64 _shopIndex = shopHandler._getIndexByID(shopID); // Get the index of the shop by its ID.
        address _shopAddress = shopHandler.getShops()[_shopIndex].shopAddress; // Get the address of the shop from its index.
        uint256 _recyclerBalance = ecoCoin.balanceOf(msg.sender); // Get the balance of the spender (recycler).

        // Checks if the spender (recycler) has enough tokens in his account to spend.
        if (_recyclerBalance < _spendAmount) {
            revert Spender__InsufficientFunds();
        }
        ecoCoin.transferFrom(msg.sender, _shopAddress, _spendAmount); // Transfer the tokens from the spender to the shop.
        shopHandler.updateShopBalance(
            _shopIndex = _shopIndex,
            _shopAddress = _shopAddress
        ); // Updates the shopBalance of the shops array to the current balance of the shop.

        depositor.updateRecyBalance(_recyID); // Updates the recycler balance in the greeners array.

        emit GoodsPurchased(shopID, _shopAddress, _recyAddr, _spendAmount); // Emit event of the purchase.
        return true; // If operation was successful, return true.
    }

    function shopBalance(uint64 shopID) public view returns (uint256) {
        uint64 _shopIndex = shopHandler._getIndexByID(shopID); // Get the index of the shop by its ID.
        return shopHandler.getShops()[_shopIndex].shopBalance;
    }
}
