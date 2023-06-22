// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./manager.sol";
import "./EcoToken.sol";

contract Depositor {
    EcoCoin token = EcoCoin(address(0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47));  // Don't forget to update me!
    management manage = management(address(0xDA0bab807633f07f013f94DD0E6A4F96F8742B53));  // Don't forget to update me!

    address owner = token.getTokenOwner();

    struct Recylcer {
        uint64 ID;  // Starts at 1; 64 bits to save on gas; perhaps in the future think of a better way to generate an ID.
        string recyName;  // Name of recycler.
        address recyAddr;  // Address of recycler.
        uint64 bottlesDepo;  // Amount of bottles deposited.
        uint256 recyBalance;  // Tokens balance of user
        uint256 requestedTokensToRedeem;  // Amount of tokens the recycler wishes to redeem.
        uint256 redeemedTokens;  // Amount of tokens redeemed.
        bool status;  // Bottles approved or denied.
    }

    Recylcer[] public greeners;
    mapping (address => uint64) public recyclerBottles;  // Mapping of addresses and their deposited bottles; added only when their bottles are confirmed.
    mapping (address => uint64) public recyclerToID;  // Mapping of addresses and their ID's.

    function registerRecycler(string memory _name) public {
        address _recyAddr = msg.sender;
        uint64 _recyID = uint64(greeners.length + 1);  // uint64 must be declared at the end because it is by default uint256.
        recyclerToID[_recyAddr] = _recyID;  // Add the ID of the recycler to associate with his address.
        //                      ID;    name;  address; bottles;   balance;   requested..Redeem; ;redeemedTokens;  status
        greeners.push(Recylcer(_recyID, _name, _recyAddr, 0, token.balanceOf(_recyAddr), 0, 0, false));
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
        require(isRegistered, "You must be registered in order to perform actions!");
        _;
    }


    function requestDeposition(uint64 _bottles) public registered returns (address, uint64) {
        require(_bottles > 0, "Number of bottles to deposit must be bigger than 0!");
        address _recyAddr = msg.sender;
        uint64 _recyID = recyclerToID[_recyAddr];  // Get the recycler's ID from the corresponding mapping, using his address.
        uint64 _recyIndex = uint64(_getGreenerIndexByID(_recyID));
        greeners[_recyIndex].bottlesDepo = _bottles;  // Update the number of bottles requested to deposit in the greeners array; (note - this is NOT approved bottles).
        return (_recyAddr, _bottles);
    }

    function approveDeposition(uint64 _reqApprId, bool _decision) public returns (bool, string memory) {
        string memory _role = manage.getRole(msg.sender);  // Gets the role of the function caller.
        require(keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Verifier")) ||
                keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Owner")),
                "Only verifiers or owners can approve depositions of bottles!");
        // Click on 'greeners' array button to see the request number, and approve by it.
        uint64 _greenerIndex = uint64(_getGreenerIndexByID(_reqApprId));  // Get the index of the array using its ID.
        require(greeners[_greenerIndex].status == false, "Only unapproved requests can be approved!");  // To prevent approval of the same request twice.
        address _reqDepoAddress = greeners[_greenerIndex].recyAddr;  // Get the address of the recycler.
        uint64 _bottlesAmount = greeners[_greenerIndex].bottlesDepo;  // Get the amount of bottles requested to deposit.
        if (_decision == true) {  // If approver has approved the deposit.
            greeners[_greenerIndex].status = true;  // Change the status of tthe deposition in the array to true (meaning approved).
            recyclerBottles[_reqDepoAddress] =  _bottlesAmount; // Only here the bottles are added to the mapping object.
            _depositTokens(_reqDepoAddress, _bottlesAmount);  // Deposit the corresponding tokens to the recycler.
            greeners[_greenerIndex].recyBalance = token.balanceOf(_reqDepoAddress);  // Set the balance in the greeners array to the tokens balance of the account.
            return (true, "Desposited!");
        } else {
            greeners[_greenerIndex].status = false;
            return (false, "Denied ;(");
        }
    }

    function _depositTokens(address _recyAddr, uint _amtBottles) private returns (bool){
        // Deposit the tokens according to the bottles deposited
        uint _bottlesToTokens = _amtBottles * 2;  // Each bottle is 2 coins.

        token.transferFunds(owner, _recyAddr, _bottlesToTokens);

        // The mint operation below raises an important question - if I mint the amount of tokens I spend, the value of the tokens keeps dropping, because the supply is bigger.
        // but since there is not use for the tokens in exchange for cash, just for products - does it matter what their value is?
        // The value of the token should be set by the state or the local municipality; some will exchange 2 tokens for coffee, some 4.
        // It all depends on how the acceptors of the bottles value the bottles.
        // Solution - burn tokens when redeeming.
        token.mintTokens(_bottlesToTokens);  // Mint the spent amount of tokens to the owner.
        return true;
    }

    function _printRole() public view returns(string memory) {
        return manage.getRole(msg.sender);
    }

    function _getGreenerIndexByID(uint64 searchID) public view returns (uint64) {
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

    function updateRequestedTokensToRedeem(uint64 _recyIndex, address _recyAddr, uint256 _tokensToRedeemAmt) external returns (bool) {
        // Updates the requested amount of tokens to redeem in the `greeners` array.
        require(msg.sender == _recyAddr, "Only the owner of the account can request to redeem tokens!");  // Prevent users to modify other users' request to redeem tokens.
        greeners[_recyIndex].requestedTokensToRedeem = _tokensToRedeemAmt;
        return true;
    }

    function updateRedeemedTokens(uint64 _recyIndex, uint256 _redeemedTokens, string memory _role) external {
        // Updates the amount of redeemed tokens approved by the redeemer.
        require(keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Redeemer")), "Only a redeemer can approve a redemption!");  // Only allow a redeemer to approve redemption of tokens.
        greeners[_recyIndex].redeemedTokens = _redeemedTokens;
    }
}