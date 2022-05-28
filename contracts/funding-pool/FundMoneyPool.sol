// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IERC20.sol";
import "./IFundMoneyFactory.sol";
import "./IWithdrawConfirmationAuthority.sol";
import "./IFundMoneyPool.sol";

contract FundMoneyPool is IFundMoneyPool {
    IERC20 public ETH;
    IFundMoneyFactory public FundMoneyFactory;
    IWithdrawConfirmationAuthority public withdrawConfirmationAuthority;

    address receiverPoolAddress;
    IFundMoneyPool receiverPool;

    address owner;

    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    constructor(address _sender, address _token, address _FundMoneyFactoryAddress, address _withdrawCAAddress) {
        owner = _sender;

        // enter the token address of the network to deploy
        ETH = IERC20(_token);

        // FundMoneyFactory's contract
        FundMoneyFactory = IFundMoneyFactory(_FundMoneyFactoryAddress);

        withdrawConfirmationAuthority = IWithdrawConfirmationAuthority(
            _withdrawCAAddress
        );
    }

    event ErrorLog(string __error_message);

    // issue an event on the side where the money was sent
    event MoneySent
    (
        address indexed __senderAddr,
        address indexed __reciveAddr,
        string __message,
        string __alias,
        uint __amount
    );

    event withdrawRequestId(uint256 _txId);

    // check the amount in this pool
    function ETHAmount() public view returns(uint256) {
        return ETH.balanceOf(address(this)) / 10 ** 18;
    }

    // allow remittances from this pool
    function approveETHFromContract() public {
        ETH.approve(address(this), ETH.balanceOf(address(this)));
    }

    function emitMoneySent(
        address _senderAddr,
        string memory _message,
        string memory _senderAlias,
        uint256 _amount
    ) public {
        emit MoneySent(_senderAddr, address(this), _message, _senderAlias, _amount);
    }

    // function to transfer money from this pool (no approver)
    // send money from pool to other pool
    function sendETH(
        address _receiveAddr,
        string memory _message,
        string memory _sendAlias,
        uint _amount  
    ) public onlyOwner {

        // items to check before remittance
        require(ETH.balanceOf(address(this)) >= _amount, "Insufficient balance on contract");

        require(bytes(_message).length != 0, "Need message to fund money");
        require(_amount != 0, "Need ETH set to be greater than 0 to fund money");
        require(_receiveAddr != address(0), "Need to set receiver address to fund money");

        // approve transfers from this pool
        try ETH.approve(address(this), _amount) {

        } catch Error(string memory reason) {
            emit ErrorLog(reason);
        }

        // get the pool of the remittance partner
        receiverPoolAddress = FundMoneyFactory.getPool(_receiveAddr);
        receiverPool = IFundMoneyPool(receiverPoolAddress);

        // can send money because we got approval
        try ETH.transferFrom(address(this), receiverPoolAddress, _amount) {
            receiverPool.emitMoneySent(owner, _message, _sendAlias, _amount);
        } catch Error(string memory reason) {
            emit ErrorLog(reason);
        }
    }

    // Send money from pool to wallet
    // request approval from the approver
    function submitWithdrawRequest(uint256 _ETHAmount) public onlyOwner  {
        require(ETH.balanceOf(address(this)) >= _ETHAmount, "Insufficient balance on contract");

        uint _txId = withdrawConfirmationAuthority.submitTransaction(address(this), owner, _ETHAmount);
        ETH.approve(address(this), _ETHAmount);
        ETH.approve(address(withdrawConfirmationAuthority), _ETHAmount);

        emit withdrawRequestId(_txId);
    }
}