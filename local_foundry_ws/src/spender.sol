// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import {EcoCoin} from "./EcoToken.sol";
import {Depositor} from "./Depositor.sol";
import {ShopHandler} from "./ShopHandler.sol";

contract Spender {
    // When a recycler wishes to spend his tokens in a local shop: Cafe, Restaurant, Clothes store, etc...
    EcoCoin ecoCoin = new EcoCoin();
    Depositor depositor = new Depositor();
    ShopHandler shopHandler = new ShopHandler();

    function purchaseGoods(
        uint64 shopID,
        uint256 _spendAmount
    ) public returns (bool) {
        // In the front-end app, display all the approved shops with their IDs.

        uint64 _shopIndex = shopHandler._getIndexByID(shopID); // Get the index of the shop by its ID.
        address _shopAddress = shopHandler.getShops()[_shopIndex].shopAddress; // Get the address of the shop from its index.
        uint _recyclerBalance = ecoCoin.balanceOf(msg.sender); // Get the balance of the spender (recycler).

        // Checks if the spender (recycler) has enough tokens in his account to spend.
        require(
            _recyclerBalance >= _spendAmount,
            string(
                abi.encodePacked(
                    "Insufficient funds! You have ",
                    _recyclerBalance,
                    " tokens while at least ",
                    _spendAmount,
                    " is required."
                )
            )
        );
        ecoCoin.transferFunds(msg.sender, _shopAddress, _spendAmount); // Transfer the tokens from the spender to the shop.
        shopHandler.updateShopBalance(
            _shopIndex = _shopIndex,
            _shopAddress = _shopAddress
        ); // Updates the shopBalance of the shops array to the current balance of the shop.
        // Add here function that updates the recycler balance in the greeners array.
        return true; // If operation was successful, return true.
    }

    function shopBalance(uint64 shopID) public view returns (uint256) {
        uint64 _shopIndex = shopHandler._getIndexByID(shopID); // Get the index of the shop by its ID.
        return shopHandler.getShops()[_shopIndex].shopBalance;
    }
}
