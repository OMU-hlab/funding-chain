// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// make tokens here because we dont have tokens for investment on the local network
contract TestETHToken is ERC20 {
    uint256 public s_maxSupply = 1000000000000000000000000;

    constructor()
        ERC20("GovernanceToken", "GT")
        {
            _mint(msg.sender, s_maxSupply);
        }

    function _afterTokenTransfer(
		address from,
		address to,
		uint256 amount
	) internal override(ERC20) {
		super._afterTokenTransfer(from, to, amount);
	}

	function _mint(address to, uint256 amount) internal override(ERC20) {
		super._mint(to, amount);
	}

	function _burn(address account, uint256 amount)
		internal
		override(ERC20)
	{
		super._burn(account, amount);
	}
}