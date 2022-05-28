// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IERC20.sol";
import "./IWithdrawConfirmationAuthority.sol";

// owner's contract
contract WithdrawConfirmationAuthority is IWithdrawConfirmationAuthority {
    IERC20 public ETH;

    // owner list
    address[] public owners;
    mapping(address => bool) public isOwner;

    // number of approvals required to withdraw tokens
    uint256 public numConfirmationsRequired;

    

    struct Transaction {
        address from;
        address to;
        uint256 ETHAmount;
        // whether the withdrawal was executed
        bool executed;
        // number approved by approver(owner)
        uint256 numConfirmations;
    }

    // transaction partner -> array containing transaction indexes
    mapping(address => uint[]) public requestTransactionQue;

    // Tx index and approver(owner)'s address-> whether it is approved
    mapping(uint => mapping(address => bool)) public isConfirmed;

    Transaction[] public transactions;

    // check if you are an approver(owner)
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Signer is not owner");
        _;
    }

    // whether Tx exist
    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "tx index does not exist");
        _;
    }

    // whether it is performed by the approver
    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "tx index already executed");
        _;
    }

    // Whether it is approved by the approver
    modifier notConfirmed(uint _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "tx index is already confirmed");
        _;
    }

    constructor(address[] memory _owners, uint256 _numConfirmationsRequired, address _tokenAddress) {
        require(_owners.length > 0, "owners required");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "assigned invalid owner address");
            require(!isOwner[owner], "owners have a redundant address");

            isOwner[owner] = true;
            owners.push(owner);
        }

        numConfirmationsRequired = _numConfirmationsRequired;

        ETH = IERC20(_tokenAddress);
    }

    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint256 ETHAmount
    );
    
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    // Creating and submitting Tx
    function submitTransaction(
        address _from,
        address _to,
        uint256 _ETHAmount
    ) public returns (uint) {
        uint256 txIndex = transactions.length;

        transactions.push(
            Transaction({
                from: _from,
                to: _to,
                ETHAmount: _ETHAmount,
                executed: false,
                numConfirmations: 0
            })
        );

        requestTransactionQue[_to].push(txIndex);

        emit SubmitTransaction(msg.sender, txIndex, _to, _ETHAmount);

        return txIndex;
    }

    function confirmTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        transaction.numConfirmations += 1;

        // register which approver approved
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    function executeTransaction(uint256 _txIndex) 
        public 
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        // check if the minimum number of approvals set in the contract is exceeded
        require(transaction.numConfirmations >= numConfirmationsRequired,
                "cannot execute tx"
        );

        transaction.executed = true;

        bool success = ETH.transferFrom(transaction.from, transaction.to, transaction.ETHAmount);

        require(success, "tx failed");

        for (uint256 i = _txIndex; i < requestTransactionQue[transaction.to].length; i++) {
            requestTransactionQue[transaction.to][i] = requestTransactionQue[transaction.to][ i + 1];
        }
        requestTransactionQue[transaction.to].pop();

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    function getOwners() external view returns (address[] memory){
        return owners;
    }

    function getTransactionCount() external view returns (uint) {
        return transactions.length;
    }

    function getTransaction(uint _txIndex)
        external
        view
        returns (
            address to,
            uint ETHAmount,
            bool executed,
            uint numConfirmations
        ) 
    {
        Transaction storage transaction = transactions[_txIndex];

        return (
            transaction.to,
            transaction.ETHAmount,
            transaction.executed,
            transaction.numConfirmations
        );
    }

    function getTransactions(address _requesterAddress)
        external
        view
        returns (uint[] memory txIndices)
    {
        return requestTransactionQue[_requesterAddress];
    }

}