// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IFundingState {
    function ideaRegister(uint256 id) external;
    function getAddress(uint256 ideaId) external view returns(address);
    function getid(uint256 _ideaId) external view returns(uint256);
    function getCheck() external view returns(uint256);
}