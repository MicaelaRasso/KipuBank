// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/*
@title KipuBank for ETHKipu's Ethereum Developer Pack
@author Micaela Rasso
@notice This contract is part of the second project of the Ethereum Developer Pack 
@custom:security this is an educative contract and should not be used in production
*/
contract KipuBank{

/*State variables*/
    ///@notice Mapping of user address to their balance in the bank.
    mapping(address owner => uint256 balance) public s_balances;

    ///@notice Total number of deposits made in the bank.
    uint256 public s_totalDeposits;

    ///@notice Total number of withdrawals made in the bank.
    uint256 public s_totalWithdrawals;

    ///@dev Tracks the actual Ether amount currently stored in the contract.
    uint256 internal s_actualAmount;

    ///@notice Maximum Ether capacity that the bank can hold.
    uint256 public immutable bankCap;

    ///@notice Maximum allowed withdrawal amount per transaction.
    uint256 public immutable maxWithdrawal;

/*Events*/
    /*
    @notice Emitted when a withdrawal is successful.
    @param receiver The address receiving the withdrawn Ether.
    @param amount The amount of Ether withdrawn.
    */
    event KipuBank_SuccessfulWithdrawal (address receiver, uint256 amount); //retiro exitoso

    /*
    @notice Emitted when a deposit is successful.
    @param receiver The address making the deposit.
    @param amount The amount of Ether deposited.
    */
    event KipuBank_SuccessfulDeposit(address receiver, uint256 amount); //deposito exitoso

/*Errors*/
    /*
    @notice Thrown when a withdrawal fails.
    @param error Encoded error message returned by the failed call.
    */
    error KipuBank_FailedWithdrawal (bytes error);

    /*
    @notice Thrown when a fallback call fails.
    @param error Encoded error message for the failed operation.
    */
    error KipuBank_FailedOperation(bytes error);

    /*
    @notice Thrown when a withdrawal is attempted without sufficient funds.
    @param error Encoded error message.
    */
    error KipuBank_InsufficientFounds(bytes error);

    /*
    @notice Thrown when a deposit exceeds the bank capacity.
    @param error Encoded error message.
    */
    error KipuBank_FailedDeposit(bytes error);

/*Modifiers*/
    /*
    @dev Ensures that a withdrawal can only be made if it does not exceed the maximum allowed amount and the user has sufficient balance.
    @param amount The requested withdrawal amount.
    */
    modifier amountAvailable(uint256 amount){
        if(maxWithdrawal < amount) revert KipuBank_FailedWithdrawal("Amount exceeds the maximum withdrawal");
        if(s_balances[msg.sender] < amount) revert KipuBank_InsufficientFounds("Not enough founds");
        _;
    }

/*Functions*/
//constructor
    /*
    @notice Deploys the contract with bank limits.
    @param _bankCap The maximum capacity of the bank.
    @param _maxWithdrawal The maximum withdrawal amount allowed.
    */
    constructor(uint256 _bankCap, uint256 _maxWithdrawal ){
        bankCap = _bankCap * 1 ether;
        maxWithdrawal  = _maxWithdrawal * 1 ether;
        s_totalDeposits = 0;
        s_totalWithdrawals = 0;
        s_actualAmount = 0;
    }

//receive & fallback
    /*
    @notice Allows contract to receive Ether directly.
    @dev Automatically calls the internal deposit function.
    */
    receive() external payable{
        _deposit(msg.sender, msg.value);
    }

    /*
    @notice Handles calls with unknown data.
    @dev Always reverts with a failed operation error.
    */
    fallback() external{
        revert KipuBank_FailedOperation("Operation does not exists or data was incorrect");
    }

//external
    /*
    @notice Allows users to deposit Ether into the bank.
    @dev Emits {KipuBank_SuccessfulDeposit}.
    */
    function deposit() external payable {
        _deposit(msg.sender, msg.value);
    }

    /*
    @notice Allows users to withdraw Ether from the bank.
    @dev Emits {KipuBank_SuccessfulWithdrawal} on success.
    @custom:error KipuBank_FailedWithdrawal Thrown when transfer fails.
    */
    function withdrawal(uint256 amount) external amountAvailable(amount) {
        s_balances[msg.sender] -= amount;
        s_totalWithdrawals += 1;
        actualizeAmount(false, amount);
        (bool success, bytes memory error) = msg.sender.call{value: amount}("");
        if (!success) 
            revert KipuBank_FailedWithdrawal(error);
        emit KipuBank_SuccessfulWithdrawal(msg.sender, amount);
    }


//private
    /*
    @dev Handles the actual deposit logic.
    @param addr The address of the depositor.
    @param amount The amount of Ether to deposit.
    */
    function _deposit(address addr, uint256 amount) private{
        if (s_actualAmount + amount > bankCap) 
            revert KipuBank_FailedDeposit("Total KipuBank's funds exceeded");
        s_balances[addr] += amount;
        s_totalDeposits += 1;
        actualizeAmount(true, amount);
        emit KipuBank_SuccessfulDeposit(addr, amount);
    }

    /*
    @dev Updates the actual Ether amount stored in the contract.
    @param dep Boolean indicating if operation is deposit (true) or withdrawal (false).
    @param amount The amount to update.
    */
    function actualizeAmount(bool dep, uint256 amount) private{
        if(dep)
            s_actualAmount += amount;
        else 
            s_actualAmount -=amount;
    }

//view & pure
    /*
    @notice Returns the balance of a given user.
    @param addr The address to query.
    @return amount The balance of the queried address.
    */
    function consultFounds(address addr) public view returns (uint256 amount){
        return s_balances[addr];
    }
}