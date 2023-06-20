// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./manager.sol";

contract Deposit {
    management manage = management(address(0x1482717Eb2eA8Ecd81d2d8C403CaCF87AcF04927));  // Don't forget to update me!

    struct Recylcer {
        uint ID;
        address recyAddr;  // Address of recycler.
        uint bottlesDepo;  // Amount of bottles deposited.
        bool status;  // Bottles approved or denied.
    }

    Recylcer[] public greeners;
    mapping (address => uint) public recylcerBottles;  // Not sure I need this mapping.
    // address _recAddr;

    function requestDeposition(uint _bottles) public returns (address, uint) {
        address _recAddr = msg.sender;
        // recylcerBottles[_recAddr] = _bottles;
        uint _recID = greeners.length + 1;
        greeners.push(Recylcer(_recID, _recAddr, _bottles, false));

        return (_recAddr, _bottles);
    }

    function approveDeposition(uint _reqApprId, bool _decision) public returns (bool, string memory) {
        // string memory _approverRole = manage.roles[msg.sender];
        string memory _role = manage.getRole(msg.sender);  // Gets the role of the function caller.
        require(keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Verifier")), "Only verifiers can approve depositions of bottles!");
        // Click on 'greeners' array button to see the request number, and approve by it.
        uint _greenerIndex = _getIndexByID(_reqApprId);  // Get the index of the array using its ID.
        address _reqDepoAddress = greeners[_greenerIndex].recyAddr;
        if (_decision == true) {
            greeners[_greenerIndex].status = true;
            recylcerBottles[_reqDepoAddress] = greeners[_greenerIndex].bottlesDepo;  // Only here the bottles are added to the mapping object.
            // recylcerBottlDepo] = greeners[_greenerIndex].bottlesDepo;
            return (true, "Desposited!");
        } else {
            greeners[_greenerIndex].status = false;
            return (false, "Denied ;(");
        }
    }

    function depositTokens(address __recAddr) public view {

    }

    function _printRole() public view returns(string memory) {
        return manage.getRole(msg.sender);
    }

    function _getIndexByID(uint searchID) private view returns (uint256) {
    // Finds an array's index by its ID; should be internal, doesn't work for some reason (maybe because I'm inherting this contract as instance and not with "is").
    // I had to create another duplicate of the function because I couldn't define an array as the function's parameter.
    for (uint i = 0; i < greeners.length; i++) {
        if (greeners[i].ID == searchID) {
            return i;
            }
        }
    revert("ID not found");
    }
}