// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Management} from "./manager.sol";
import {EcoCoin} from "./EcoToken.sol";

/**
 * @author  ChefAharoni
 * @title   Registration for shops
 * @dev     .
 * @notice  Allows shops to register themselves. Used to prevent fraud by random users pretend to be shops and fool users into sending them tokens.
 */

contract Registration {
    EcoCoin token =
        EcoCoin(address(0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8)); // Don't forget to update me!
    Management manage =
        Management(address(0xf8e81D47203A594245E36C48e151709F0C19fBe8)); // Don't forget to update me!

    // address owner = token.getTokenOwner(); // Owner is not longer relevant.

    // TODO - Declare events here for listening.

    // Address and name of shop; only approved shops
    mapping(address shop => string shopName) shopAddrToName;

    // Address and ID of shop; only approved shops
    mapping(address shop => uint64 shopID) shopAddrToID;

    struct Shop {
        uint64 shopID; // Starts from 1.
        address shopAddress; // Address of the shop.
        string shopName; // Name of the shop.
        string shopType; // Coffeehouse / Clothes / Restaurant / etc...
        uint shopBalance; // Balance of tokens.
        uint256 requestedTokensToRedeem; // Amount of tokens the recycler wishes to redeem. ----!!!---
        uint256 redeemedTokens; // Amount of tokens redeemed.   ---!!!---
        bool status;
    }

    // Array of all shops using the Shop struct
    Shop[] public shops;

    // mapping of Rolers' addresses and their request in string; i.e. (0X1234..., "verifier").
    //? Can I delete this?
    // mapping (address => string) requestedRoles;

    /**
     * @notice  Main function for shops to register themselves.
     * @dev     Adds a shop to the array of shops, using the Shop struct.
     * @dev     The shop's address is the sender's address.
     * @param   _name  Name of the shop.
     * @param   _type  Type of the shop: Coffeehouse / Clothes / Restaurant / etc...
     * @return  address  Address of the shop.
     * @return  string  Name of the shop.
     * @return  string  Type of the shop.
     */
    function registerShop(
        string memory _name,
        string memory _type
    ) public returns (address, string memory, string memory) {
        // Add a check/modification so string will be lowercase.
        address _shopAddress = msg.sender;
        uint64 _shopRegisterID = uint64(shops.length + 1);
        shops.push(
            Shop(
                _shopRegisterID,
                _shopAddress,
                _name,
                _type,
                token.balanceOf(_shopAddress),
                0,
                0,
                false
            )
        );

        // requestedRoles[_shopAddress] = _role;  // Can I delete this?
        return (_shopAddress, _name, _type);
    }

    /**
     * @notice  Finds an array's index by its ID; should be internal, doesn't work for some reason (maybe because I'm inheriting this contract as instance and not with "is").
     * @dev     .
     * @param   searchID  ID of the shop to search.
     * @return  uint64  Index of the shop in the array.
     */
    function _getIndexByID(uint64 searchID) public view returns (uint64) {
        // Setting it public so it can be used in spender contract as well. (maybe not?)
        for (uint64 i = 0; i < shops.length; i++) {
            if (shops[i].shopID == searchID) {
                return i;
            }
        }
        revert("ID not found");
    }

    /**
     * @notice  Approved a request of a shop to register; only municipality can approve.
     * @dev     .
     * @param   _shopRegisterID  ID of the shop that requested to register.
     * @param   _decision  Decision of the municipality to approve or deny the request.
     * @return  bool  True if approved, false if denied.
     * @return  string  Message of approval/denial.
     */
    function _approveShop(
        uint64 _shopRegisterID,
        bool _decision
    ) public returns (bool, string memory) {
        // TODO - Change check here to Municipality, not owner.
        // require(
        //     msg.sender == owner,
        //     "Only the owner of the coin can set roles! \n owner's address is "
        // );
        // Click on 'shops' array button to see the request number, and approve by it.
        uint64 _shopIndex = _getIndexByID(_shopRegisterID); // Get the index of the array using its ID.
        address _shopAddress = shops[_shopIndex].shopAddress;
        if (_decision == true) {
            shops[_shopIndex].status = true;
            shopAddrToName[_shopAddress] = shops[_shopIndex].shopName;
            shopAddrToID[_shopAddress] = shops[_shopIndex].shopID;
            return (true, "Approved!");
        } else {
            shops[_shopIndex].status = false;
            return (false, "Denied ;(");
        }
    }

    /**
     * @notice   Remove a role requested by a shop; only municipality can remove a role.
     * @dev     .
     * @param   _shopRmvID   ID of the shop that requested to be removed.
     * @param   _decision   Decision of the municipality to approve or deny the request.
     * @return  bool  True if approved, false if denied.
     * @return  string Message of approval/denial.
     */
    function _removeShop(
        uint64 _shopRmvID,
        bool _decision
    ) public returns (bool, string memory) {
        // TODO - Change check here to Municipality, not owner.
        // require(
        //     msg.sender == owner,
        //     "Only the owner of the coin can set roles! /n owner's address is "
        // );
        // Click on 'shops' array button to see the request number, and approve by it.
        uint64 _shopRmvIndex = _getIndexByID(_shopRmvID); // Get the index of the array using its ID.
        address _reqRmvAddress = shops[_shopRmvIndex].shopAddress;
        if (_decision == false) {
            // If the shop is removed
            shops[_shopRmvIndex].status = false;
            shopAddrToName[_reqRmvAddress] = "";
            shopAddrToID[_reqRmvAddress] = 0; // Zero will never be an ID since it starts from one.
            return (false, "Shop removed.");
        } else {
            return (false, "Invalid command.");
        }
    }

    function printShopName() public view returns (string memory) {
        return shopAddrToName[msg.sender];
    }

    function getShops() external view returns (Shop[] memory) {
        return shops;
    }

    function updateShopBalance(
        uint64 _shopIndex,
        address _shopAddress
    ) external {
        // Updates the balance of a requested shop according to its balance as written in the blockchain.
        shops[_shopIndex].shopBalance = token.balanceOf(_shopAddress);
    }

    function _getShopName(
        address _shopAddress
    ) public view returns (string memory) {
        // Gets the shop's name by its address; used for checking if address is registered shop.
        return shopAddrToName[_shopAddress];
    }

    function updateRequestedTokensToRedeem(
        uint256 _tokensToRedeemAmt
    ) external returns (bool) {
        // Updates the requested amount of tokens to redeem in the `shops` array.
        // require(msg.sender == _recyAddr, "Only the owner of the account can request to redeem tokens!");  // Prevent users to modify other users' request to redeem tokens.
        uint64 _shopIndex = shopAddrToID[msg.sender]; // This allows only to update only the functions caller's request of tokens.
        shops[_shopIndex].requestedTokensToRedeem = _tokensToRedeemAmt; // This will override any data currently there.
        return true;
    }

    function updateRedeemedTokens(
        uint64 _shopIndex,
        uint256 _redeemedTokens
    ) external returns (bool) {
        string memory _role = manage.getRole(msg.sender); // Get the role of the msg.sender.

        // Updates the amount of redeemed tokens approved by the redeemer.
        require(
            keccak256(abi.encodePacked(_role)) ==
                keccak256(abi.encodePacked("Redeemer")),
            "Only a redeemer can approve a redemption!"
        ); // Only allow a redeemer to approve redemption of tokens.
        shops[_shopIndex].redeemedTokens = _redeemedTokens; // This will override any data currently there.
        return true;
    }
}
