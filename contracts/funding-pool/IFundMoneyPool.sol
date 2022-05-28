// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IFundMoneyPool {
    function ETHAmount() external view returns (uint);
    function approveETHFromContract() external;
    function emitMoneySent(
        address _senderAddr,
        string memory _message,
        string memory _senderAlias,
        uint _amount
    ) external;
}