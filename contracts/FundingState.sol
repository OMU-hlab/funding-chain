// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IDrafter.sol";
import "./Register.sol";
import "./funding-pool/IFundMoneyFactory.sol";

contract FundingState is Register {

    IFundMoneyFactory public FundMoneyFactory;
    IDrafter public drafter;

    constructor(address _fundMoneyFactoryAddress, address _drafterAddress) {
        // FundMoneyFactory's contract
        FundMoneyFactory = IFundMoneyFactory(_fundMoneyFactoryAddress);
        drafter = IDrafter(_drafterAddress);
    }


    struct RegisteredState {
        // idea's id
        uint256 ideaId;
        // drafter's address
        address inventor;
        // deadline for customers to invest
        uint256 timelimit;
        // metadata
        string explanation;
        // target amount by drafter
        uint256 targetMoney;
        // voting form (all-in, all or nothing, etc)
        string investmentForm;
        // time targeted for investment (block)
        uint256 promotionTime;
        // amount invested
        uint256 totalmoney;
        // number of people who have invested
        uint256 totalinvested;
        // Whether this idea is possible by voter
        bool votercheck;
    }

    // modifier
    // Whether this idea is possible by voter
    // true => possible, false => impossible
    modifier voterCheck(uint256 ideaId) {
        require(!drafter.getVotingpossible(ideaId), "idea is already registered");
        _;
    }


    mapping (address => mapping(uint256 => uint256)) public investMemberListIndexes;

    mapping (uint256 => RegisteredState) public idToRegisteredstate;

    uint256 check = 0;


    function ideaRegister(uint256 id) public voterCheck(id){

        check = 1;

        address _inventor = drafter.getInventor(id);

        idToRegisteredstate[id].ideaId = drafter.getId(id);
        idToRegisteredstate[id].inventor = _inventor;
        idToRegisteredstate[id].timelimit = drafter.getTimeLimit(id);
        idToRegisteredstate[id].explanation = drafter.getExplanation(id);
        idToRegisteredstate[id].targetMoney = drafter.getTargetMoney(id);
        idToRegisteredstate[id].investmentForm = drafter.getInvestmentForm(id);
        idToRegisteredstate[id].promotionTime = block.number;
        idToRegisteredstate[id].totalmoney = 0;
        idToRegisteredstate[id].totalinvested = 0;
        idToRegisteredstate[id].votercheck = true;

    }

    function getAddress(uint256 ideaId) public view returns(address){
        return idToRegisteredstate[ideaId].inventor;
    }

    function getid(uint256 _ideaId) public view returns(uint256){
        return idToRegisteredstate[_ideaId].ideaId;
    }

    function getCheck() public view returns(uint256) {
        return check;
    }

    function getFundingState(uint256 ideaId) public view returns(RegisteredState memory) {
        return idToRegisteredstate[ideaId];
    }

    receive() external payable {
    }
    fallback() external payable {
    }

}