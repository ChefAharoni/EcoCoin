// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./EcoToken.sol";

contract management {
    constructor() {
        // When contract called, set the owner role.
        _addOwnerRole();
    }

    // EcoCoin token
    EcoCoin token = EcoCoin(address(0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47));  // Don't forget to update me!

    // Later declare events here for listening.

    // Used to deploy roles of users and machines
    mapping (address => string) roles;

    address owner = token.getTokenOwner();

    // function setTokenContractAddress (address _address) external {
    //     // Add here onlyOwner later instead of require

    //     // Function enables to set the contracts' address from outside, so it can be constantly updated; rectricted to owners only.
    //     require(msg.sender == owner, "Only the owner can set the contracts' address!");
    //     token = EcoCoin(_address);
    // }

    function _addOwnerRole() private {
        // Called automatically when contract is deployed.
        roles[owner] = "Owner";  // Add the owner of the token
    }

    function printOwner() public view returns (address) {
        // Prints the address of the token's owner.
        return token.getTokenOwner();
    }

    function getRole(address _userAddress) external view returns (string memory) {
        // Get the role of a specific user using his address.
        return roles[_userAddress];
    }

    struct Requester {
        uint64 ID;  // Starts at 1; 64 bits to save on gas.
        string name;
        address rqAddress;
        string role;  // Verifier / Owner / Redeemer
        bool status;  // Approve / denied.
    }

    // Array of all requests based on the Requester struct.
    Requester[] public requests;

    // mapping of requesters' addresses and their request in string; i.e. (0X1234..., "verifier").
    mapping (address => string) requestedRoles;


    function requestRole(string memory _role, string memory _name) public returns (address, string memory) {
        // Add a check/modification so string will be lowercase.
        address _reqAddress = msg.sender;
        uint64 _reqApprID = uint64(requests.length + 1);
        requests.push(Requester(_reqApprID, _name, _reqAddress, _role, false));

        requestedRoles[_reqAddress] = _role;
        return (_reqAddress, _role);
    }

    function _getIndexByID(uint searchID) private view returns (uint256) {
        // Finds an array's index by its ID; should be internal, doesn't work for some reason (maybe because I'm inherting this contract as instance and not with "is").
        for (uint i = 0; i < requests.length; i++) {
            if (requests[i].ID == searchID) {
                return i;
            }
        }
        revert("ID not found");
    }


    function _approveRole(uint _reqApprId, bool _decision) public returns (bool, string memory) {
        require(msg.sender == owner, "Only the owner of the coin can set roles! \n owner's address is ");
        // Click on 'requests' array button to see the request number, and approve by it.
        uint _reqIndex = _getIndexByID(_reqApprId);  // Get the index of the array using its ID.
        address _reqApprAddress = requests[_reqIndex].rqAddress;
        if (_decision == true) {
            requests[_reqIndex].status = true;
            roles[_reqApprAddress] = requestedRoles[_reqApprAddress];
            return (true, "Approved!");
        } else {
            requests[_reqIndex].status = false;
            return (false, "Denied ;(");
        }
    }

    function _removeRole(uint _reqRmvId, bool _decision) public returns (bool, string memory) {
        require(msg.sender == owner, "Only the owner of the coin can set roles! /n owner's address is ");
        // Click on 'requests' array button to see the request number, and approve by it.
        uint _reqRmvIndex = _getIndexByID(_reqRmvId); // Get the index of the array using its ID.
        address _reqRmvAdress = requests[_reqRmvIndex].rqAddress;
        if (_decision == false) {
            requests[_reqRmvIndex].status = false;
            roles[_reqRmvAdress] = "";
            return (false, "Role removed.");
        } else {
            return (false, "Invalid command.");
        }
    }

    function printRole() public view returns (string memory) {
        return roles[msg.sender];
    }

 }
