// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./FundMoneyPool.sol";

contract FundMoneyFactory is IFundMoneyFactory {
    // 1. Create a pool for each Investor
    // 2. Transfer money from wallet to Investor pool
    // 3. Create a pool for each Drafter
    // 4. Transfer money from Investor pool to Drafter pool
    // 5. Transfer money from Drafter pool to wallet

    address immutable i_tokenAddress;
    address immutable i_withdrawCAAddress;
    address immutable i_fundMoneyFactoryAddress = address(this);

    // wallet address -> pool address
    mapping(address => address) pools;


    constructor(address _tokenAddress, address _withdrawCAAddress) {
        i_tokenAddress = _tokenAddress;
        i_withdrawCAAddress = _withdrawCAAddress;
    }

    event PoolCreated(address indexed __sender_address, address __pool_address);

    function getPool(address _sender) public view returns(address) {
        require(pools[_sender] != address(0), "sender doesnt have pool");
        return pools[_sender];
    }

    // Function to create a pool
    // because pool is contract, we can get address form it
    function newFundMoneyPool() public returns(address) {
        require(address(pools[msg.sender]) == address(0), "Pool has been already created");

        FundMoneyPool pool = new FundMoneyPool(msg.sender, i_tokenAddress, address(this), i_withdrawCAAddress);
        emit PoolCreated(msg.sender, address(pool));
        pools[msg.sender] = address(pool);
        return pools[msg.sender];
    }
}