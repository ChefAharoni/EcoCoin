// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./manager.sol";
import "./EcoToken.sol";

contract Deposit {
    EcoCoin token = EcoCoin(address(0xf2B1114C644cBb3fF63Bf1dD284c8Cd716e95BE9));  // Don't forget to update me!
    management manage = management(address(0xE3Ca443c9fd7AF40A2B5a95d43207E763e56005F));  // Don't forget to update me!

    address owner = token.getTokenOwner();

    struct Recylcer {
        uint64 ID;  // Starts at 1; 64 bits to save on gas.
        address recyAddr;  // Address of recycler.
        uint bottlesDepo;  // Amount of bottles deposited.
        bool status;  // Bottles approved or denied.
    }

    Recylcer[] public greeners;
    mapping (address => uint) public recylcerBottles;  // Mapping of addresses and their deposited bottles; added only when their bottles are confirmed.

    function requestDeposition(uint _bottles) public returns (address, uint) {
        address _recAddr = msg.sender;
        uint64 _recID = uint64(greeners.length + 1);  // uint64 must be declared at the end because it is be default uint256.I
        greeners.push(Recylcer(_recID, _recAddr, _bottles, false));

        return (_recAddr, _bottles);
    }

    function approveDeposition(uint _reqApprId, bool _decision) public returns (bool, string memory) {
        string memory _role = manage.getRole(msg.sender);  // Gets the role of the function caller.
        require(keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Verifier")) ||
                keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Owner")),
                "Only verifiers or owners can approve depositions of bottles!");
        // Click on 'greeners' array button to see the request number, and approve by it.
        uint _greenerIndex = _getGreenerIndexByID(_reqApprId);  // Get the index of the array using its ID.
        address _reqDepoAddress = greeners[_greenerIndex].recyAddr;
        uint _bottlesAmount = greeners[_greenerIndex].bottlesDepo;
        if (_decision == true) {
            greeners[_greenerIndex].status = true;
            recylcerBottles[_reqDepoAddress] =  _bottlesAmount; // Only here the bottles are added to the mapping object.
            _depositTokens(_reqDepoAddress, _bottlesAmount);
            return (true, "Desposited!");
        } else {
            greeners[_greenerIndex].status = false;
            return (false, "Denied ;(");
        }
    }


    function _getAllowance() public view returns (uint) {
        return token.allowance(owner, msg.sender);  // this - the address of the contract; owner - the contract.
    }

    function _depositTokens(address _recyAddr, uint _amtBottles) private returns (bool){
        // Function should be private; checking if `payable` keyword changed the bug.

        // Deposit the tokens according to the bottles deposited
        uint _bottlesToTokens = _amtBottles * 2;  // Each bottle is 2 coins.

        token.transferFunds(owner, _recyAddr, _bottlesToTokens);
        return true;
    }

    function _printRole() public view returns(string memory) {
        return manage.getRole(msg.sender);
    }

    function _getGreenerIndexByID(uint searchID) private view returns (uint256) {
    // Finds an array's index by its ID; should be internal, doesn't work for some reason (maybe because I'm inherting this contract as instance and not with "is").
    // I had to create another duplicate of the function because I couldn't define an array as the function's parameter.
    for (uint i = 0; i < greeners.length; i++) {
        if (greeners[i].ID == searchID) {
            return i;
            }
        }
    revert("ID not found");
    }

    function getBalance() public view returns (uint256) {
        // Allows to get the token balance held by the smart contract.
        return token.balanceOf(address(msg.sender));
    }
}