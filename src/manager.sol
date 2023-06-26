// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import {EcoCoin} from "./EcoToken.sol";

contract Management {
    constructor() {
        // When contract called, set the i_owner role in the roles mapping.
        _addOwnerRole();
    }

    // EcoCoin token
    EcoCoin token =
        EcoCoin(address(0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8)); // Don't forget to update me!

    // Later declare events here for listening.

    // Used to deploy roles of users and machines; only approved roles are here.
    mapping(address user => string Role) roles;

    address immutable i_owner = token.getTokenOwner();

    // Implement this in the future - a smart way to add the address of the contract from the outside.
    // function setTokenContractAddress (address _address) external {
    // Add here only i_Owner later instead of require

    // Function enables to set the contracts' address from outside, so it can be constantly updated; rectricted to i_owners only.
    //     require(msg.sender == i_owner, "Only the i_owner can set the contracts' address!");
    //     token = EcoCoin(_address);
    // }

    /**
     * @notice  Adds the role of the owner.
     * @dev Called automatically when contract is called.
     */
    function _addOwnerRole() private {
        roles[i_owner] = "i_Owner"; // Add the owner of the token
    }

    /**
     * @notice  Prints the address of the token's owner.
     * @return  address  Of token's owner.
     */
    function printOwner() public view returns (address) {
        return token.getTokenOwner();
    }

    /**
     * @notice  Gets a role from the roles mapping.
     * @dev     Used for outer functions that cannot access the mapping.
     * @param   _userAddress  Address of user requested to get role of.
     * @return  string  If exists, role of the user requested.
     */
    function getRole(
        address _userAddress
    ) external view returns (string memory) {
        return roles[_userAddress];
    }

    /**
     * @notice Struct of a roler, where his ID, name, addres, and requested roles are saved.
     * @dev As long as status is false, the role of the user hasn't been verified by an owner/municipality.
     */
    struct Roler {
        uint64 ID; // Starts at 1; 64 bits to save on gas.
        string name;
        address rqAddress;
        string role; //  Owner / Redeemer
        bool status; // Approve / denied.
    }

    // Array of all requests based on the Roler struct; represent only requested roles, not approved ones.
    Roler[] public requests;

    // mapping of Rolers' addresses and their request in string; i.e. (0X1234..., "verifier").
    mapping(address user => string roleRequested) requestedRoles;

    /**
     * @notice  Method that lets users request a role for them.
     * @dev     .
     * @param   _role  Role requested.
     * @param   _name  Name of the requester (used for identification in approval).
     * @return  address  Address of the requester.
     * @return  string  Role requested by the requester.
     */
    function requestRole(
        string memory _role,
        string memory _name
    ) public returns (address, string memory) {
        // Add a check/modification so string will be lowercase.
        address _reqAddress = msg.sender;
        uint64 _reqApprID = uint64(requests.length + 1);
        requests.push(Roler(_reqApprID, _name, _reqAddress, _role, false));

        requestedRoles[_reqAddress] = _role;
        return (_reqAddress, _role);
    }

    /**
     * @notice  Finds an array's index by its ID.
     * @dev     Two things aren't working: 1. Function should be internal, but then it wouldn't be avaiable to other contracts without fully inheriting this contract.
     *                                     2. Array is fixed, not a var; I haven't figured how to set the array searched as a var;
     *                                         this function is multiplied in every contract, according to its corresponding array.
     * @param   searchID  Object's ID to query in the array.
     * @return  uint64  Index of queried array's object.
     */
    function _getIndexByID(uint searchID) private view returns (uint64) {
        // Finds an array's index by its ID; should be internal, doesn't work for some reason (maybe because I'm inherting this contract as instance and not with "is").
        for (uint64 i = 0; i < requests.length; i++) {
            if (requests[i].ID == searchID) {
                return i;
            }
        }
        revert("ID not found");
    }

    /**
     * @notice  Approve a role requested by a user, only an owner (for now, might change to municipality) can approve a role.
     * @dev     .
     * @param   _reqApprId  .
     * @param   _decision  .
     * @return  bool  .
     * @return  string  .
     */
    function _approveRole(
        uint _reqApprId,
        bool _decision
    ) public returns (bool, string memory) {
        require(
            msg.sender == i_owner,
            "Only the owner of the coin can set roles! \n owner's address is " /* This error message doesn't work, should return the owner's address. */
        );
        // Click on 'requests' array button to see the request number, and approve by it.
        uint64 _reqIndex = uint64(_getIndexByID(_reqApprId)); // Get the index of the array using its ID.
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

    function _removeRole(
        uint _reqRmvId,
        bool _decision
    ) public returns (bool, string memory) {
        require(
            msg.sender == i_owner,
            "Only the owner of the coin can set roles! /n owner's address is "
        );
        // Click on 'requests' array button to see the request number, and approve by it.
        uint64 _reqRmvIndex = uint64(_getIndexByID(_reqRmvId)); // Get the index of the array using its ID.
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