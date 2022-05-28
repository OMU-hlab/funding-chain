// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IFundMoneyFactory {
    function getPool(address sender) external view returns(address);
    function newFundMoneyPool() external returns(address);
}
