// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./manager.sol";
import "./EcoToken.sol";

contract Registration {
    EcoCoin token = EcoCoin(address(0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47)); // Don't forget to update me!
    management manage = management(address(0xDA0bab807633f07f013f94DD0E6A4F96F8742B53)); // Don't forget to update me!

    address owner = token.getTokenOwner();

    // Later declare events here for listening.

    // Address and name of shop
    mapping (address => string) shopToName;

    struct Shop {
        uint64 shopID;
        address shopAddress;
        string shopName;  // Name of the shop
        string shopType;  // Coffeehouse / Clothes / Restaurant / etc...
        uint shopBalance;  // Balance of tokens.
        bool status;
    }

    // Array of all shops using the Shop struct
    Shop[] public shops;

    // mapping of requesters' addresses and their request in string; i.e. (0X1234..., "verifier").
    // mapping (address => string) requestedRoles;


    function registerShop(string memory _name, string memory _type) public returns (address, string memory, string memory) {
        // Add a check/modification so string will be lowercase.
        address _shopAddress = msg.sender;
        uint64 _shopRegisterID = uint64(shops.length + 1);
        shops.push(Shop(_shopRegisterID, _shopAddress, _name, _type, token.balanceOf(_shopAddress), false));

        // requestedRoles[_shopAddress] = _role;  // Can I delete this?
        return (_shopAddress, _name, _type);
    }

    function _getIndexByID(uint64 searchID) public view returns (uint64) {
        // Finds an array's index by its ID; should be internal, doesn't work for some reason (maybe because I'm inheriting this contract as instance and not with "is").
        // Setting it public so it can be used in spender contract as well. (maybe not?)
        for (uint64 i = 0; i < shops.length; i++) {
            if (shops[i].shopID == searchID) {
                return i;
            }
        }
        revert("ID not found");
    }


    function _approveShop(uint64 _shopRegisterID, bool _decision) public returns (bool, string memory) {
        require(msg.sender == owner, "Only the owner of the coin can set roles! \n owner's address is ");
        // Click on 'shops' array button to see the request number, and approve by it.
        uint64 _shopIndex = _getIndexByID(_shopRegisterID);  // Get the index of the array using its ID.
        address _shopAddress = shops[_shopIndex].shopAddress;
        if (_decision == true) {
            shops[_shopIndex].status = true;
            shopToName[_shopAddress] = shops[_shopIndex].shopName;
            return (true, "Approved!");
        } else {
            shops[_shopIndex].status = false;
            return (false, "Denied ;(");
        }
    }

    function _removeShop(uint64 _shopRmvID, bool _decision) public returns (bool, string memory) {
        require(msg.sender == owner, "Only the owner of the coin can set roles! /n owner's address is ");
        // Click on 'shops' array button to see the request number, and approve by it.
        uint64 _shopRmvIndex = _getIndexByID(_shopRmvID); // Get the index of the array using its ID.
        address _reqRmvAddress = shops[_shopRmvIndex].shopAddress;
        if (_decision == false) {  // If the shop is removed
            shops[_shopRmvIndex].status = false;
            shopToName[_reqRmvAddress] = "";
            return (false, "Shop removed.");
        } else {
            return (false, "Invalid command.");
        }
    }

    function printShopName() public view returns (string memory) {
        return shopToName[msg.sender];
    }

    function getShops() external view returns (Shop[] memory) {
        return shops;
    }

    function updateShopBalance(uint64 _shopIndex, address _shopAddress) external {
        // Updates the balance of a requested shop according to its balance as written in the blockchain.
        shops[_shopIndex].shopBalance = token.balanceOf(_shopAddress);
    }

}