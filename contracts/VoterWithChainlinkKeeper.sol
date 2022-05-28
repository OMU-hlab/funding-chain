// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IDrafter.sol";
import "./IFundingState.sol";
import "./Idea.sol";

import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

contract Voter is  Idea, KeeperCompatibleInterface {

// already declared in fundingstate
    IDrafter public drafter;

    IFundingState public fundingState;

    mapping (address => mapping(uint256 => bool)) Voted;
    mapping (address => ideaState) OwnerToIdeaState;
    mapping (uint256 => uint256) idToVotedNumber;
    mapping (address => mapping (uint256 => string)) votingIdToReason;

    // number of voter
    uint256 public totalVoterCount;
    // voting deadline (block number)
    uint256 i_votingDelay;
    // voter による投票の期限？
	uint256 i_votingPeriod;

    uint256 lastTimeStamp;



    error duplicateVoting();
    error ideadisagree();
    
    constructor(
		uint256 _votingDelay,
		uint256 _votingPeriod, 
        address _fundMoneyFactoryAddress,
        address payable _drafterAddress, 
        address _fundingStateAddress
	)
	{
        i_votingDelay = _votingDelay;
        i_votingPeriod = _votingPeriod;
        totalVoterCount = 0;
        drafter = IDrafter(_drafterAddress);
        fundingState = IFundingState(_fundingStateAddress);
        lastTimeStamp = block.timestamp;
    }


    // Whether voters can vote
    modifier voterPossible(uint256 ideaId) {
        require(drafter.getVotingpossible(ideaId), "voter cannot vote");
        _;
    }

    function voteWithReason (uint256 ideaId, string calldata reason) public voterPossible(ideaId) {
        uint votedNumber = drafter.addVotedNumber(ideaId);

        votingIdToReason[msg.sender][ideaId] = reason;

        // goal% × totalVoterCount (required number of votes) / 100 <=  number of votes in favor
        //if(idToIdeaState[ideaId].goalRate * totalVoterCount <= idToIdeaState[ideaId].votedNumber * 100) {
        // to test, this function will run if 3 voters vote in favor
        if(3 <= votedNumber ) {
            drafter.changeVoterCheck(ideaId);
            drafter.changeVotingPossible(ideaId);
            fundingState.ideaRegister(ideaId);
        }

    }


    function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }

    function performUpkeep(bytes calldata) external override {
        if ((block.timestamp - lastTimeStamp) > interval ) {
            lastTimeStamp = block.timestamp;
        }
    }    


    function getVotedNum(uint256 ideaId) public view returns(uint256) {
        return drafter.getVotedNumber(ideaId);
    }

    function getpossible(uint256 ideaId) public view returns(bool) {
        return drafter.getVotingpossible(ideaId);
    }
}