// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import {EcoCoin} from "./EcoToken.sol";
import {Management} from "./manager.sol";
import {Depositor} from "./depositor.sol";
import {Registration} from "./registration.sol";

// TODO - Redemption mechanism should be automated by the depositor machine.

/**
 * @author  ChefAharoni
 * @title   Token redemption
 * @dev     .
 * @notice  Contract that handles the redemption of tokens owned by shops.
 */

contract Redeemer {
    EcoCoin token =
        EcoCoin(address(0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8)); // Don't forget to update me!
    Management manage =
        Management(address(0xf8e81D47203A594245E36C48e151709F0C19fBe8)); // Don't forget to update me!
    Depositor deposition =
        Depositor(address(0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B)); // Don't forget to update me!
    Registration shopReg =
        Registration(address(0x9D7f74d0C41E726EC95884E0e97Fa6129e3b5E99)); // Don't forget to update me!

    //? Should this change to a modifier?
    // function _isRegisteredShop(
    //     address _shopAddress
    // ) private view returns (bool) {
    //     string memory _shopName = shopReg._getShopName(_shopAddress);
    //     if (
    //         keccak256(abi.encodePacked(_shopName)) ==
    //         keccak256(abi.encodePacked(""))
    //     ) {
    //         return false; // If the name of the shop equals nothing == no shop registered.
    //     } else {
    //         return true; // Otherwise - it is a shop.
    //     }
    // }

    /**
     * @notice  Checks if an address is a registered shop. Used to prevent random users to pretend to be a shop and fool recyclers from depositing tokens to them.
     * @dev     .
     * @param   _shopAddress  .
     */
    modifier isRegisteredShop(address _shopAddress) {
        string memory _shopName = shopReg._getShopName(_shopAddress);
        if (
            keccak256(abi.encodePacked(_shopName)) ==
            keccak256(abi.encodePacked(""))
        ) {
            revert("Only a registered shop can redeem tokens!"); // If the name of the shop equals nothing == no shop registered at this address.
        } else {
            _;
        }
    }

    /**
     * @notice  Allows a shop to request to redeem tokens received by recyclers.
     * @dev     .
     * @param   _tokensAmount  .
     * @return  bool  .
     */
    // TODO - Add a modifier to check if the function caller is a registered shop.
    // TODO - Change the require to if and create a custom error.
    // TODO - Test if this workflow works with a machine instead of a human.
    function requestRedeem(
        uint64 _tokensAmount
    ) public isRegisteredShop(msg.sender) returns (bool) {
        // require(
        //     _isRegisteredShop(msg.sender),
        //     "Only a registered shop can redeem tokens!"
        // ); // Check if the function called is a registered shop.
        require(
            token.balanceOf(msg.sender) >= _tokensAmount,
            "Insufficient tokens to redeem!"
        );
        // uint64 _shopID = shopReg.getIdByAddress(msg.sender);  // Get the recycler's ID from the corresponding mapping, using his address.
        // uint64 _shopIndex = shopReg._getIndexByID(_shopID);  // Get the recycler's index from his ID.
        shopReg.updateRequestedTokensToRedeem(_tokensAmount);
        return true;
    }

    /**
     * @notice  Getter function for an caller's address' role.
     * @dev     .
     * @return  string  Role of the function caller.
     */
    function _getRole() public view returns (string memory) {
        return manage.getRole(msg.sender);
    }

    // TODO - This approval of the tokens should be by the machine, not by a human.
    function approveRedeem(
        uint64 _shopID,
        bool _decision
    ) public returns (bool) {
        string memory _role = manage.getRole(msg.sender); // Get the role of the function caller, should be "Redeemer".
        require(
            keccak256(abi.encodePacked(_role)) ==
                keccak256(abi.encodePacked("Redeemer")),
            "Only a redeemer can approve a redemption!"
        ); // Only allow a redeemer to approve redemption of tokens.

        uint64 _shopIndex = shopReg._getIndexByID(_shopID); // Get the recycler's index from his ID.
        address _shopAddress = shopReg.getShops()[_shopIndex].shopAddress; // Get the recycler's Address from his index.
        uint256 _tokensToRedeemAmt = shopReg
        .getShops()[_shopIndex].requestedTokensToRedeem; // Get the amount of tokens the recycler has requested to redeem.
        if (_decision == true) {
            shopReg.updateRedeemedTokens(_shopIndex, _tokensToRedeemAmt); // Update the redeemed tokens in the recyclers (greeners) array.
            token.transferFunds(
                _shopAddress,
                address(this),
                _tokensToRedeemAmt
            ); // Transfer the redeemed coins to the address of this contract; will be burnt manually later by owner.
            return true;
        } else {
            // Error occured; could I enter an error message here? (revert?)
            return false;
        }
    }

    // TODO - Move this function to the machine's contract - only the machine should be able to burn tokens.
    function BurnRedeemedTokens() public returns (bool, uint256) {
        // TODO - change the requirement for this function to a machine, not an owner.
        // address tokenOwner = token.getTokenOwner(); // Get the address of the token's owner.
        // require(
        //     msg.sender == tokenOwner,
        //     "Only the owner of the token can burn tokens!"
        // ); // Allow only the token owner to call this function
        uint256 _thisContractBalance = token.balanceOf(address(this)); // Get the amount of tokens this contract owns.
        token._burnTokens(address(this), _thisContractBalance); // Burn (delete) the tokens requested to redeem from the recyclers account.
        return (true, token.balanceOf(address(this))); // Return true if successful && balance of this contract.
    }
}
