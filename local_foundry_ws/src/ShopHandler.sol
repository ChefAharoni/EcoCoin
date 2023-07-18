// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {EcoCoin} from "./EcoCoin.sol";
import {Municipality} from "./Municipality.sol";

/**
 * @author  ChefAharoni
 * @title   Registration for shops
 * @dev     .
 * @notice  Allows shops to register themselves. Used to prevent fraud by random users pretend to be shops and fool users into sending them tokens.
 */
contract ShopHandler is Municipality {
    /* Errors */

    EcoCoin ecoCoin = new EcoCoin();

    // Address and name of shop; only approved shops
    mapping(address shop => string shopName) shopAddrToName;

    // Address and ID of shop; only approved shops
    mapping(address shop => uint64 shopID) shopAddrToID;

    struct Shop {
        uint64 shopID; // Starts from 1.
        address shopAddress; // Address of the shop.
        string shopName; // Name of the shop.
        string shopType; // Coffeehouse / Clothes / Restaurant / etc...
        string shopZipCode; // Zip code of the shop.
        uint256 shopBalance; // Balance of tokens.
        bool status; // Status of shop's registration.
    }

    // Array of all shops using the Shop struct
    Shop[] public shops;

    /* Events */
    event ShopRegistered(
        address indexed shopAddress,
        uint64 indexed shopID,
        string indexed shopName,
        string shopType,
        string shopZipCode
    );

    event ShopApproved(
        address indexed approverAddress,
        address indexed shopAddress,
        uint64 indexed shopID,
        string shopName,
        string shopType,
        string shopZipCode
    );

    event ShopDenied(
        address indexed denierAddress,
        address indexed shopAddress,
        uint64 indexed shopID,
        string shopName,
        string shopType,
        string shopZipCode
    );

    event ShopRemoved(
        address indexed removerAddress,
        address indexed shopAddress,
        uint64 indexed shopID,
        string shopName,
        string shopType,
        string shopZipCode
    );

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
        string memory _type,
        string memory _zipCode
    ) public returns (address, string memory, string memory, string memory) {
        // Add a check/modification so string will be lowercase.
        address _shopAddress = msg.sender;
        uint64 _shopRegisterID = uint64(shops.length + 1);
        shops.push(
            Shop({
                shopID: _shopRegisterID,
                shopAddress: _shopAddress,
                shopName: _name,
                shopType: _type,
                shopZipCode: _zipCode,
                shopBalance: ecoCoin.balanceOf(_shopAddress),
                status: false
            })
        );

        emit ShopRegistered(
            _shopAddress,
            _shopRegisterID,
            _name,
            _type,
            _zipCode
        );

        return (_shopAddress, _name, _type, _zipCode);
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
    ) public muniOnly returns (bool, string memory) {
        // Click on 'shops' array button to see the request number, and approve by it.
        uint64 _shopIndex = _getIndexByID(_shopRegisterID); // Get the index of the array using its ID.
        address _shopAddress = shops[_shopIndex].shopAddress;
        if (_decision == true) {
            shops[_shopIndex].status = true;
            shopAddrToName[_shopAddress] = shops[_shopIndex].shopName;
            shopAddrToID[_shopAddress] = shops[_shopIndex].shopID;

            emit ShopApproved(
                msg.sender,
                _shopAddress,
                _shopRegisterID,
                shops[_shopIndex].shopName,
                shops[_shopIndex].shopType,
                shops[_shopIndex].shopZipCode
            );

            return (true, "Approved!");
        } else {
            shops[_shopIndex].status = false;

            emit ShopDenied(
                msg.sender,
                _shopAddress,
                _shopRegisterID,
                shops[_shopIndex].shopName,
                shops[_shopIndex].shopType,
                shops[_shopIndex].shopZipCode
            );

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
    ) public muniOnly returns (bool, string memory) {
        // Click on 'shops' array button to see the request number, and approve by it.
        uint64 _shopRmvIndex = _getIndexByID(_shopRmvID); // Get the index of the array using its ID.
        address _reqRmvAddress = shops[_shopRmvIndex].shopAddress;
        if (_decision == false) {
            // If the shop is removed
            shops[_shopRmvIndex].status = false;
            shopAddrToName[_reqRmvAddress] = "";
            shopAddrToID[_reqRmvAddress] = 0; // Zero will never be an ID since it starts from one.

            emit ShopRemoved(
                msg.sender,
                _reqRmvAddress,
                _shopRmvID,
                shops[_shopRmvIndex].shopName,
                shops[_shopRmvIndex].shopType,
                shops[_shopRmvIndex].shopZipCode
            );

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
        shops[_shopIndex].shopBalance = ecoCoin.balanceOf(_shopAddress);
    }

    function _getShopName(
        address _shopAddress
    ) public view returns (string memory) {
        // Gets the shop's name by its address; used for checking if address is registered shop.
        return shopAddrToName[_shopAddress];
    }

    /**
     * @notice  Gets the shop's ID by his address.
     * @dev     Used for external contracts.
     * @param   _shopAddress  Address of the shop.
     * @return  uint64  ID of the shop.
     */
    function getIdByAddress(
        address _shopAddress
    ) external view returns (uint64) {
        // For external contracts, extract the recycler's ID from his address.
        return shopAddrToID[_shopAddress];
    }
}
