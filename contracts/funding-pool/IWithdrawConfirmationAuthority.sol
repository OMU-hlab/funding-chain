// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IWithdrawConfirmationAuthority {
    function submitTransaction(
        address _from,
        address _to,
        uint256 _ETHcAmount
    ) external returns (uint);

    function confirmTransaction(uint _txIndex) external;
    function getOwners() external view returns (address[] memory);
    function getTransactionCount() external view returns (uint);

    function getTransaction(uint _txIndex)
        external
        view
        returns (
            address to,
            uint ETH_value,
            bool executed,
            uint numConfirmations
        );

    function getTransactions(address _requesterAddress)
        external
        view
        returns (uint[] memory txIndices);
}