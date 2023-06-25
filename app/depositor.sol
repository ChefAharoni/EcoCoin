// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import {Management} from "./manager.sol";
import {EcoCoin} from "./EcoToken.sol";

contract Depositor {
    EcoCoin token =
        EcoCoin(address(0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8)); // Don't forget to update me!
    Management manage =
        Management(address(0xf8e81D47203A594245E36C48e151709F0C19fBe8)); // Don't forget to update me!

    address owner = token.getTokenOwner();

    struct Recylcer {
        uint64 ID; // Starts at 1; 64 bits to save on gas; perhaps in the future think of a better way to generate an ID.
        string recyName; // Name of recycler.
        address recyAddr; // Address of recycler.
        uint64 bottlesDepo; // Amount of bottles deposited.
        uint256 recyBalance; // Tokens balance of user.
        bool status; // Bottles approved or denied.
    }

    Recylcer[] public greeners;
    mapping(address recycler => uint64 bottlesAmt) public recyclerBottles; // Mapping of addresses and their deposited bottles; added only when their bottles are confirmed.
    mapping(address recycler => uint64 recyID) public recyclerToID; // Mapping of addresses and their ID's.

    function registerRecycler(string memory _name) public {
        address _recyAddr = msg.sender;
        uint64 _recyID = uint64(greeners.length + 1); // uint64 must be declared at the end because it is by default uint256.
        recyclerToID[_recyAddr] = _recyID; // Add the ID of the recycler to associate with his address.
        //                      ID;    name;  address; bottles;   balance;   requested..Redeem; ;redeemedTokens;  status
        greeners.push(
            Recylcer(
                _recyID,
                _name,
                _recyAddr,
                0,
                token.balanceOf(_recyAddr),
                false
            )
        );
    }

    modifier registered() {
        // Check if user has registered to the system; otherwise he won't be able to perform certain actions, such as request deposition of bottles.
        bool isRegistered = false;
        for (uint256 i = 0; i < greeners.length; i++) {
            if (greeners[i].recyAddr == msg.sender) {
                isRegistered = true;
                break;
            }
        }
        require(
            isRegistered,
            "You must be registered in order to perform actions!"
        );
        _;
    }

    function requestDeposition(
        uint64 _bottles
    ) public registered returns (address, uint64) {
        require(
            _bottles > 0,
            "Number of bottles to deposit must be bigger than 0!"
        );
        address _recyAddr = msg.sender;
        uint64 _recyID = recyclerToID[_recyAddr]; // Get the recycler's ID from the corresponding mapping, using his address.
        uint64 _recyIndex = uint64(_getGreenerIndexByID(_recyID));
        greeners[_recyIndex].bottlesDepo = _bottles; // Update the number of bottles requested to deposit in the greeners array; (note - this is NOT approved bottles).
        return (_recyAddr, _bottles);
    }

    function approveDeposition(
        uint64 _reqApprId,
        bool _decision
    ) public returns (bool, string memory) {
        string memory _role = manage.getRole(msg.sender); // Gets the role of the function caller.
        require(
            keccak256(abi.encodePacked(_role)) ==
                keccak256(abi.encodePacked("Verifier")),
            "Only verifiers can approve depositions of bottles!"
        );
        // Click on 'greeners' array button to see the request number, and approve by it.
        uint64 _greenerIndex = uint64(_getGreenerIndexByID(_reqApprId)); // Get the index of the array using its ID.
        require(
            greeners[_greenerIndex].status == false,
            "Only unapproved requests can be approved!"
        ); // To prevent approval of the same request twice.
        address _reqDepoAddress = greeners[_greenerIndex].recyAddr; // Get the address of the recycler.
        uint64 _bottlesAmount = greeners[_greenerIndex].bottlesDepo; // Get the amount of bottles requested to deposit.
        if (_decision == true) {
            // If approver has approved the deposit.
            greeners[_greenerIndex].status = true; // Change the status of tthe deposition in the array to true (meaning approved).
            recyclerBottles[_reqDepoAddress] = _bottlesAmount; // Only here the bottles are added to the mapping object.
            _depositTokens(_reqDepoAddress, _bottlesAmount); // Deposit the corresponding tokens to the recycler.
            greeners[_greenerIndex].recyBalance = token.balanceOf(
                _reqDepoAddress
            ); // Set the balance in the greeners array to the tokens balance of the account.
            return (true, "Desposited!");
        } else {
            greeners[_greenerIndex].status = false;
            return (false, "Denied ;(");
        }
    }

    function _depositTokens(
        address _recyAddr,
        uint _amtBottles
    ) private returns (bool) {
        // Deposit the tokens according to the bottles deposited
        uint _bottlesToTokens = _amtBottles * 2; // Each bottle is 2 coins.

        token.transferFunds(owner, _recyAddr, _bottlesToTokens);

        token.mintTokens(_bottlesToTokens); // Mint the spent amount of tokens to the owner.
        return true;
    }

    function _printRole() public view returns (string memory) {
        return manage.getRole(msg.sender);
    }

    function _getGreenerIndexByID(
        uint64 searchID
    ) public view returns (uint64) {
        // Finds an array's index by its ID; should be internal, doesn't work for some reason (maybe because I'm inherting this contract as instance and not with "is").
        // I had to create another duplicate of the function because I couldn't define an array as the function's parameter.
        // Setting it public so it can be used in spender contract as well. (maybe not?)
        for (uint64 i = 0; i < greeners.length; i++) {
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

    function getIdByAddress(address _recyAddr) external view returns (uint64) {
        // For external contracts, extract the recycler's ID from his address.
        return recyclerToID[_recyAddr];
    }

    function getGreeners() external view returns (Recylcer[] memory) {
        // View the `greeners` array from contracts outside of this contract.
        return greeners;
    }

    function updateRecyBalance(uint64 _recyID) public returns (bool) {
        // Update the recycler's balance in the array.
        uint64 _recyIndex = uint64(_getGreenerIndexByID(_recyID));
        greeners[_recyIndex].recyBalance = token.balanceOf(
            greeners[_recyIndex].recyAddr
        );
        return true;
    }
}
