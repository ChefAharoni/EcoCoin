// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Municipality} from "./Municipality.sol";
import {IEcoCoin} from "./IEcoCoin.sol"; // EcoCoin Interface
import {Depositor} from "./Depositor.sol";
import {ShopHandler} from "./ShopHandler.sol";

contract Machine {
    // What will the machine do?
    /*  1. Exchange bottles for tokens
            a. Receive bottles from recycler
            b. Mint tokens
            c. Send tokens to recycler

        2. Redeem tokens for real value
            a. Receive tokens from shop
            b. Check for Real Money (RM) funds amount.
                i. If funds are available, send money to shop
                ii. If insufficient funds, withdraw from municipality real money (RM) wallet.
            c. Exchange tokens for money
            d. Send money to shop using a payment processor (venmo, cashapp, etc.); i.e. CashApp can generate a QR code to scan. [CashApp API](https://developers.cash.app/docs/api/welcome)
            e. Burn tokens
    */

    /* Errors */
    error Depositor__RecyclerNotRegistered(); // Error to throw when the recycler is not registered.
    error ShopHandler__ShopNotRegisteredOrApproved(); // Error to throw when the caller is not registered.
    error Machine__CallerIsNotMachine();
    error Machine__BottlesNumberToDepositMustBeGreaterThanZero();
    error Machine__CannotDepositMoreThan200BottlesAtOnce();
    error Machine__CoolDownTimerHasntPassed();
    error Machine__RedeemedTokensMustBeGreaterThanZero();
    error Machine__CannotRedeemMoreThan9999TokensAtOnce();
    error Machine__InsufficientTokensBalanceToRedeem();
    error Municipality__NotMunicipality(address);

    /* Variables */

    struct exchangeMachine {
        uint64 exMachineID; // ID of machines, starts at 1.
        string exMachineZipCode; // Zip code of the Municipality, even if the machine is not in the same exact zip code of the municipality.
        address exMachineAddress; // Tokens wallet address.
        uint256 exMachineRMBalance; // Real Money (RM) balance of the machine.
    }

    // Array of all exchange machines using the exchangeMachine struct
    exchangeMachine[] public exchangeMachines;
    mapping(address => uint64) public exMachineAddressToID;
    mapping(uint64 => address) public exMachineIDToAddress;

    uint256 private immutable i_CoolDownInterval; // Interval of cool down for time between deposits (1 hour).

    IEcoCoin private immutable ecoCoin; // Calling the interface of the EcoCoin contract.
    Depositor depositor;
    ShopHandler shopHandler;
    Municipality municipality;

    /* Events */
    event AddedExchangeMachine(
        address indexed exMachineAddress,
        string indexed exMachineZipCode,
        address indexed addedBy
    );

    event DepositedBottles(
        uint64 indexed exMachineID,
        address exMachineAddress,
        address indexed recyAddr,
        uint64 recyID,
        uint64 indexed bottles
    );

    event DepositedTokens(
        address exMachineAddress,
        uint64 indexed exMachineID,
        address indexed recyAddress,
        uint256 indexed tokens
    );

    event RedeemedTokens(
        address exMachineAddress,
        uint64 indexed exMachineID,
        address indexed shopAddress,
        uint256 indexed tokens,
        string cashAppUsername
    );

    /* Modifiers */
    /**
     * @notice  Modifier that lets only a machine to perform certain actions.
     * @dev     Checks if the machine exists in the exMachineAddresstoID mapping.
     */
    modifier machineOnly() {
        if (exMachineAddressToID[msg.sender] == 0) {
            revert Machine__CallerIsNotMachine();
        }
        _;
    }

    /**
     * @notice  Check in functions so only municipalities can perform actions.
     * @dev   .
     */
    modifier muniOnly() {
        if (bytes(municipality.MuniAddrToZipCode(msg.sender)).length == 0) {
            revert Municipality__NotMunicipality(msg.sender);
        }
        _;
    }

    constructor(
        address _ecoCoinAddr,
        address _depositorAddr,
        address _shopHandlerAddr,
        address _municipalityAddr
    ) {
        // Not sure whether it's more gas efficient to deploy the interface or the contract itself; a problem for future fixes.
        ecoCoin = IEcoCoin(_ecoCoinAddr); // Address of the EcoCoin contract.
        depositor = Depositor(_depositorAddr);
        shopHandler = ShopHandler(_shopHandlerAddr);
        i_CoolDownInterval = 3600; // Should be one hour, MAKE SURE LATER
        //! Make sure block.timestanp is in seconds.
        municipality = Municipality(_municipalityAddr);
    }

    /* Functions */
    /**
     * @notice  Mints tokens to the specified address.
     * @dev     No restrictions on who can mint tokens.
     * @param   to  Address to mint tokens to.
     * @param   amount  Amount of tokens to mint.
     */
    function mint(address to, uint256 amount) external muniOnly {
        ecoCoin.mint(to, amount);
    }

    /**
     * @notice  Create a new exchange machine.
     * @dev     Address of machine should be created prior to calling this function.
     * @return  uint256  ID of the new exchange machine.
     */
    function createMachine(
        address _exMAddress,
        string memory _exMZip
    ) public muniOnly returns (uint256) {
        exchangeMachine memory newMachine = exchangeMachine({
            exMachineID: uint64(exchangeMachines.length + 1),
            exMachineZipCode: _exMZip,
            exMachineAddress: _exMAddress,
            exMachineRMBalance: ecoCoin.balanceOf(_exMAddress) // Should get the balance from the wallet's address.
        });
        exchangeMachines.push(newMachine); // Add the new machine to the array of all machine
        exMachineAddressToID[_exMAddress] = newMachine.exMachineID; // Add the new machine to the mapping of Machine's address and its ID.
        exMachineIDToAddress[newMachine.exMachineID] = _exMAddress; // Add the new machine to the mapping of Machine's ID and its address.
        emit AddedExchangeMachine(_exMAddress, _exMZip, msg.sender); // Emit event of the new machine.
        return newMachine.exMachineID;
    }

    /**
     * @notice  Deposits tokens into the recycler's account, according to the amount of bottles deposited.
     * @dev     DANGEROUS IMPLEMENTATION!!!
     * @dev     Currently this function has no limitations on who can call it; currently this is okay since we're assuming that in "realistic" implementation, only the machine will have access to this function.
     * @dev     Maybe it's all okay, because in a realistic scenario, we can assume that the recycler will only have to these functions when he's at a physical machine.
     * @param exMachineAddress Address of the machine that will be used for minting and transferring.
     * @param   _recyAddr  Address of the recycler.
     * @param   _amtBottles  Amount of bottles to deposit.
     * @return  bool  True if the operation was successful.
     */
    function _depositTokens(
        address exMachineAddress,
        address _recyAddr,
        uint256 _amtBottles
    ) private returns (bool) {
        uint256 _bottlesToTokens = _amtBottles * 2; // Each bottle is 2 coins.

        ecoCoin.mint(_recyAddr, _bottlesToTokens); // Mint the spent amount of tokens to the machine.

        emit DepositedTokens(
            exMachineAddress,
            exMachineAddressToID[exMachineAddress],
            _recyAddr,
            _bottlesToTokens
        ); // Emit event for deposited tokens.
        return true;
        // Problematic that only machine can call this, because the recycler calls the deposit bottles function.
    }

    /**
     * @notice  Lets a recycler deposits bottles through a machine and receive tokens in exchange.
     * @dev     Verification of depositions should be entered in the future.
     * @dev     As of right now, when depositing bottles, user must specify the machine ID. This is a little bit complicated for the user, but I'm assuming that there will be several machines at each ZipCode, so I don't want to rely soley on that.
     * @dev     Please implement a front end feature to get all machines in a zip code, using the array of all exchange machines (exchangeMachines).
     * @dev     Should be called only be a registered depositor.
     * @dev     Since there is no "real" verification of bottles, this function can be easily exploited, since anyone can call it and mint infinite tokens.
     * @param   _exMachineID  ID of the exchange machine to be used.
     * @param   _bottles  Amount of bottles to deposit.
     * @return  bool  True if successfully deposited, false otherwise.
     * @return  string  String indication of success / failure.
     */
    function depositBottles(
        uint64 _exMachineID,
        uint64 _bottles
    ) public returns (bool, string memory) {
        if (_bottles <= 0) {
            revert Machine__BottlesNumberToDepositMustBeGreaterThanZero();
        }
        if (_bottles > 200) {
            revert Machine__CannotDepositMoreThan200BottlesAtOnce();
        }

        address _recyAddr = msg.sender;

        // Maybe let user in front end to make some kind of verification, to add some fake security to the process.
        uint64 _recyID = depositor.getIdByAddress(_recyAddr);

        // Checks if recycler is registered.
        if (_recyID == 0) {
            revert Depositor__RecyclerNotRegistered();
        }

        uint64 _recyIndex = uint64(depositor._getGreenerIndexByID(_recyID));
        uint256 recyLastTimeStamp = depositor
        .getGreeners()[_recyIndex].lastTimeStamp;
        // Check here if enough time has passed since the last recycler's deposition.
        if ((block.timestamp >= recyLastTimeStamp + i_CoolDownInterval)) {
            revert Machine__CoolDownTimerHasntPassed();
        }

        depositor.getGreeners()[_recyIndex].bottlesDepo = _bottles; // Update the number of bottles requested to deposit in the greeners array.
        // Do some clever checks here to verify the deposition; after verification, set the status of the deposition in greeners to 'true'.
        /*
            Saved space for validating the number of bottles.
        */
        depositor.getGreeners()[_recyIndex].status = true; // Change the status of tthe deposition in the array to true (meaning approved).

        // After deposition was verified, update the recycler's last deposition time.
        depositor.getGreeners()[_recyIndex].lastTimeStamp = block.timestamp;

        depositor.getGreeners()[_recyIndex].recyBalance = ecoCoin.balanceOf(
            _recyAddr
        ); // Set the balance in the greeners array to the tokens balance of the account.
        address _exMachineAddress = exMachineIDToAddress[_exMachineID];
        _depositTokens({
            exMachineAddress: _exMachineAddress,
            _recyAddr: _recyAddr,
            _amtBottles: _bottles
        });

        emit DepositedBottles(
            _exMachineID,
            _exMachineAddress,
            _recyAddr,
            _recyID,
            _bottles
        ); // Emit event for deposited bottles.

        return (true, "Desposited!");
        /*
            After creating the verification, if the verification has failed, return false and set the status to false as well.
            depositor.greeners[_recyIndex].status = false;
            return (false, "Denied ;(");
        */
    }

    /**
     * @notice  Allows shops to redeem their tokens.
     * @dev     We are assuming the machine is encyrtped and trusted, so we're automating the process of redeeming tokens.
     * @param   _exMachineID  ID of the exchange machine to be used.
     * @param   _tokensAmt  Amount of tokens to redeem.
     * @return  bool  True if successfully deposited, false otherwise.
     */
    function redeemTokens(
        uint64 _exMachineID,
        string memory _cashAppUsername,
        uint64 _tokensAmt
    ) public returns (bool) {
        /* 
            1. Check if tokens amount is bigger than 0. V
            2. Check if tokens amount is less than 9999. V
            3. Check if the shop is registered and approved. V
            4. Check if the shop has enough tokens to redeem. V
            6. Check if the machine has enough real money (RM) to redeem. ?
            7. Burn the tokens from the shop. V
            8. Send the real money (RM) to the shop. V
        */
        /* Checks */
        // Check requested tokens to redeem is bigger than 0.
        if (_tokensAmt <= 0) {
            revert Machine__RedeemedTokensMustBeGreaterThanZero();
        }

        if (_tokensAmt > 9999) {
            revert Machine__CannotRedeemMoreThan9999TokensAtOnce();
        }

        address _shopAddress = msg.sender;
        uint64 _shopID = shopHandler.getIdByAddress(_shopAddress);
        // Checks if sender is a registered and approved shop.
        if (_shopID == 0) {
            revert ShopHandler__ShopNotRegisteredOrApproved();
        }

        // Checks that the shop has enough tokens to redeem.
        if (ecoCoin.balanceOf(_shopAddress) < _tokensAmt) {
            revert Machine__InsufficientTokensBalanceToRedeem();
        }

        /* Redeem */
        address _exMachineAddress = exMachineIDToAddress[_exMachineID];
        ecoCoin._burn(msg.sender, _tokensAmt); // Burn the tokens from the machine.

        // Transfer the real money to the shop.
        transferRealMoney({
            _exMachineID: _exMachineID,
            _shopAddress: _shopAddress,
            _cashAppUsername: _cashAppUsername,
            _tokensAmt: _tokensAmt
        }); // Transfer the real money (RM) to the shop.

        emit RedeemedTokens(
            _exMachineAddress,
            _exMachineID,
            _shopAddress,
            _tokensAmt,
            _cashAppUsername
        ); // Emit event for redeemed tokens.

        return true;
    }

    /**
     * @notice  Transfers real money (RM) to the shop; currently a mock function.
     * @dev     .
     * @param   _exMachineID   ID of the exchange machine to be used.
     * @param   _shopAddress  Address of the shop that's associated with the redeemed tokens.
     * @param   _cashAppUsername CashApp username of the shop, RM will be transferred to this username.
     * @param   _tokensAmt  Amount of redeemed tokens to be converterd as a transfer of real money (RM).
     * @return  string  Success message of the transfer.
     */
    function transferRealMoney(
        uint64 _exMachineID,
        address _shopAddress,
        string memory _cashAppUsername,
        uint64 _tokensAmt
    ) private pure returns (string memory) {
        /*
            For now, this function **imitates** the action of transferring real money from the machine to the shop that redeems tokens.
            
            In future versions, connect this function to CashApp's API to transfer money to the shop.
            
            Enter a calculation for the amount of real money (RM) to transfer to the shop, according to the amount of tokens redeemed.
        */
        string memory transferData = string(
            abi.encodePacked(
                "Exchange Machine ID: ",
                string(abi.encodePacked(_exMachineID)),
                "Transferred real money (RM) to shop with CashApp username: ",
                _cashAppUsername,
                "Associated with the address of: ",
                string(abi.encodePacked(_shopAddress)),
                " for redeeming ",
                string(abi.encodePacked(_tokensAmt)),
                " tokens."
            )
        );
        return transferData;
    }
}
