// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./EcoToken.sol";
import "./manager.sol";
import "./depositor.sol";

contract Redeemer {
    EcoCoin token = EcoCoin(address(0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47)); // Don't forget to update me!
    management manage = management(address(0xDA0bab807633f07f013f94DD0E6A4F96F8742B53)); // Don't forget to update me!
    Depositor deposition = Depositor(address(0x9a2E12340354d2532b4247da3704D2A5d73Bd189)); // Don't forget to update me!

    function requestRedeem(uint64 _tokensAmount) public returns (bool) {
        require(token.balanceOf(msg.sender) >= _tokensAmount, "Insufficient tokens to redeem!");
        uint64 _recyID = deposition.getIdByAddress(msg.sender);  // Get the recycler's ID from the corresponding mapping, using his address.
        uint64 _recyIndex = deposition._getGreenerIndexByID(_recyID);  // Get the recycler's index from his ID.
        deposition.updateRequestedTokensToRedeem(_recyIndex, msg.sender, _tokensAmount);
        return true;
    }

    function approveRedeem(uint64 _recyIndex, bool _decision) public returns (bool) {
        string memory _role = manage.getRole(msg.sender);  // Get the role of the function caller, should be "Redeemer".
        require(keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Redeemer")), "Only a redeemer can approve a redemption!");  // Only allow a redeemer to approve redemption of tokens.
        if (_decision == true) {

            // deposition.updateRedeemedTokens
        }
        return true;
    }
}