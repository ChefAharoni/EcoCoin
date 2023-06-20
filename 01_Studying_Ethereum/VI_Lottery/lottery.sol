// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "@openzeppelin/contracts/utils/Strings.sol";
// Strings.sol from @openzeppelin was imported to simplify strings handling in Solidity.

contract Betting {
    // Record the owner of the contract
    // Used to store the address of the account that deployed the contract.
    address owner = msg.sender;

    // Minimum amount to wage (wei)
    uint constant MIN_WAGER = 1000;

    // Maximum number of players allowed for each round
    // Defines the maximum number of players allowed in a game before the winning number is drawn.
    // 3 is used for ease of testing, could define to much higher number
    uint constant MAX_NUMBER_OF_PLAYERS = 3;

    // Range of numbers to bet, from 1 to MAX_NUMBER_TO_BET
    // Defines the maximum winning number for the lottery game.
    uint constant MAX_NUMBER_TO_BET = 10;

    // Total amount waged by players so far
    uint totalWager = 0;

    // Number of players waged so far
    uint numberOfPlayers = 0;

    // Winning number
    uint winningBetNumber = 0;

    // Since in Solidity it is not possible to iterate over the mapping object, creating an array to keep track of the players
    // Array of addresses of all players
    // Fixed size array storing the account address of each player.
    // Payable keyword is used to indicate that each player can send/receive Ethers.
    address payable [MAX_NUMBER_OF_PLAYERS] playerAddressesArray;

    // Store wager details of each player
    struct Player {
    uint amountWagered; // e.g. 2000 wei
    uint numberWagered; // e.g. number 5
    }

    // Waging deatils of all players in a mapping object
    // A mapping object where the keys are the acount addresses of all players, the value for each key is a structure named Player with two members:
    // amountWagered (amount of Wei bet), and numberWagered (number player is betting on)
    mapping(address => Player) playerDetailsMapping;

    //---define an event---
    event Winner(
        address winner,
        uint amount
    );

    // The event to display the status of the game
    event Status (
        uint players,
        uint maxPlayers
    );

    function bet(uint number) public payable
    // payable keyword in the function means that whenever a player places a bet, he must also send in some Ethers.
    // Allows a player to place a bet on a number
    {
        // Check #1
        // Ensure the max number of players has not been reached
        require(numberOfPlayers < MAX_NUMBER_OF_PLAYERS, "Maximum number of players reached.");

        // Check #2
        // Ensure the caller has never betted
        // If the account address of the player cannot be found in the playerDetailsMapping object, the values of the two members in the Player structure will be set to their default values, which is 0 for uint.
        require(playerDetailsMapping[msg.sender].numberWagered == 0, "You have already betted.");

        // Check #3
        // Check the range of numbers allowed for betting
        require(number >= 1 && number <= MAX_NUMBER_TO_BET, string.concat("You need to bet a number between 1 and ", Strings.toString(MAX_NUMBER_TO_BET)));

        // Check #4
        // Ensure min. bet (note that msg.value is in wei)
        require(msg.value >= MIN_WAGER, string.concat("Minimum bet is ", Strings.toString(MIN_WAGER), " wei."));

        // Record the number and amount wagered by the player
        playerDetailsMapping[msg.sender].amountWagered = msg.value;
        playerDetailsMapping[msg.sender].numberWagered = number;

        // Add the player address to the array of addresses
        playerAddressesArray[numberOfPlayers] = payable(msg.sender);

        // Increment the number of wagers so far.
        numberOfPlayers++;

        // Sum up the total amount of wagered so far.
        totalWager += msg.value;

        // Emit the Status event
        emit Status(numberOfPlayers, MAX_NUMBER_OF_PLAYERS);
    }

    function announceWinners(uint winningNumber) public
    // Takes in the winning number and calculates the winnings (profits) for each players, and transfers the winnings to them.
    {
        // Check to ensure that only the owner of this contract can invoke this function
        require(msg.sender == owner, "Only the owner can announce the winner!");

        winningBetNumber = winningNumber;

        // Use to store winners
        // Creates an array in memory to store all the winning players, plus two variables for storing the number of winners as well as the total amount of winning wagers.
        address payable[MAX_NUMBER_OF_PLAYERS] memory winners;
        uint winnerCount = 0;
        uint totalWinningWager = 0;

        // Find out the winners
        // Iterates through all the players using the playerAddressesArray array and check if the number they wagered on is the winning number. The winning players are then added to the winners array.
        for (uint i=0; i < playerAddressesArray.length; i++) {
            // Get the address of each player
            address payable playerAddress = playerAddressesArray[i];

            // If the players betted number is the winning number
            if (playerDetailsMapping[playerAddress].numberWagered == winningNumber) {
                // Save the player address into the winners array
                winners[winnerCount] = playerAddress;

                // Sum um the total wagered amount for the winning numbers
                totalWinningWager += playerDetailsMapping[playerAddress].amountWagered;
                winnerCount++;
            }
        }

        // Make payments to each winning player
        // Calculates the winnings for each player and transfer the winnings to them using the transfer() function.
        for (uint j=0; j < winnerCount; j++) {
            // Calculate the winnings of each player
            uint amount = (playerDetailsMapping[winners[j]].amountWagered * totalWager) / totalWinningWager;

            // Make payment to player
            winners[j].transfer(amount);
            emit Winner(winners[j], amount);
        }

        // Reset the variables (so a new game can start)
        numberOfPlayers = 0;
        totalWager = 0;

        // Clear all arrays and mappings
        for (uint i=0; i < playerAddressesArray.length; i++) {
            // Get the address of each player
            address payable playerAddress = playerAddressesArray[i];
            delete playerDetailsMapping[playerAddress];
            delete playerAddressesArray[i];
        }

        // Emit the Status event
        emit Status(numberOfPlayers, MAX_NUMBER_OF_PLAYERS);
    }

    function getGameStatus() view public returns (uint, uint) {
        // Return the status of the game
        return (numberOfPlayers, MAX_NUMBER_OF_PLAYERS);
    }

    function getWinningNumber() view public returns (uint) {
        // Return the winning number
        return winningBetNumber;
    }

    function cashOut() public {
        require(msg.sender == owner, "Only the owner of the contract can cash out!");
        payable(owner).transfer(address(this).balance);
    }
}
