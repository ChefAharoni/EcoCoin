// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./EcoToken.sol";
import "./depositor.sol";
import "./registration.sol";

contract Spender {
    // When a recycler wishes to spend his tokens in a local shop: Cafe, Restaurant, Clothes store, etc...
    EcoCoin token = EcoCoin(address(0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8));  // Don't forget to update me!
    Depositor deposition = Depositor(address(0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B));  // Don't forget to update me!
    Registration shopReg = Registration(address(0x9D7f74d0C41E726EC95884E0e97Fa6129e3b5E99)); // Don't forget to update me!

    function purchaseGoods(uint64 shopID, uint256 _spendAmount) public returns (bool){
        // In the front-end app, display all the approved shops with their IDs.

        uint64 _shopIndex = shopReg._getIndexByID(shopID);  // Get the index of the shop by its ID.
        address _shopAddress = shopReg.getShops()[_shopIndex].shopAddress;  // Get the address of the shop from its index.
        uint _recyclerBalance = token.balanceOf(msg.sender);  // Get the balance of the spender (recycler).

        // Checks if the spender (recycler) has enough tokens in his account to spend.
        require(_recyclerBalance >= _spendAmount,
                string(abi.encodePacked("Insufficient funds! You have " , _recyclerBalance, " tokens while at least ", _spendAmount, " is required.")));
        token.transferFunds(msg.sender, _shopAddress, _spendAmount);  // Transfer the tokens from the spender to the shop.
        shopReg.updateShopBalance(_shopIndex=_shopIndex, _shopAddress=_shopAddress);  // Updates the shopBalance of the shops array to the current balance of the shop.
        return true; // If operation was successful, return true.
    }

    function shopBalance(uint64 shopID) public view returns (uint256) {
        uint64 _shopIndex = shopReg._getIndexByID(shopID);  // Get the index of the shop by its ID.
        return shopReg.getShops()[_shopIndex].shopBalance;
    }
}