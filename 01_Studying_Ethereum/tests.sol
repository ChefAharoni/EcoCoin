// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Deposit{
    function sumOfBottles() private returns (uint sum) {
        // How can I get here the total number of bottles?
        // We should either "imagine" the bottles are scanned through already-built bottles-deposit machines,
        // and the machine returns to the function the number of bottles scanned.
        // until a real machine is used, another function (python/solidity?) should return a random number
    }

    function receiverAccount(address receiver) public view {
        // In the future, think of a way to represent an address in a simple QR code.
        // The connection to accounts as described in the book is through MetaMask, which requires an account & maintenance.
        // If not using a web dapp, but a python dapp, MetaMask doesn't have to be involved.
    }
}