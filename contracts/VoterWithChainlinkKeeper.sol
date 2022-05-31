// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IDrafter.sol";
import "./IFundingState.sol";
import "./Idea.sol";

import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

contract VoterWithChainlinkKeeper is  Idea, KeeperCompatibleInterface {

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

    event IdeaDeleted(uint256);

    error duplicateVoting();
    error ideadisagree();
    
    constructor(
		uint256 _votingDelay,
		uint256 _votingPeriod, 
        address payable _drafterAddress, 
        address _fundingStateAddress
	)
	{
        i_votingDelay = _votingDelay;
        i_votingPeriod = _votingPeriod;
        totalVoterCount = 0;
        drafter = IDrafter(_drafterAddress);
        fundingState = IFundingState(_fundingStateAddress);
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

    function deleteIdea (uint256 ideaId) public {
        drafter.deleteIdeaState(ideaId);
        emit IdeaDeleted(ideaId);
    }

    function getTimeOutId() public view returns (uint256 timeOutId) {
        uint256 id = drafter.viewId();
        for (uint i = 1; i < id + 1; i++) {
            if (block.timestamp - (drafter.getSubmissionTime(i)) > i_votingPeriod) {
                return i;
            }
        }
    }


    function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded, bytes memory performData) {
        uint256 timeOutId = getTimeOutId();
        upkeepNeeded = (block.timestamp - drafter.getSubmissionTime(timeOutId)) > i_votingPeriod;
        performData = abi.encode(timeOutId);
        return (upkeepNeeded, performData);

    }

    function performUpkeep(bytes calldata performData) external override {
        uint256 id = drafter.viewId();
        uint256 timeOutId = abi.decode(performData, (uint256));
        for (uint i = timeOutId; i < id + 1; i++) {
            if (block.timestamp - (drafter.getSubmissionTime(i)) > i_votingPeriod) {
                deleteIdea(i);
            }
        }
    }    


    function getVotedNum(uint256 ideaId) public view returns(uint256) {
        return drafter.getVotedNumber(ideaId);
    }

    function getpossible(uint256 ideaId) public view returns(bool) {
        return drafter.getVotingpossible(ideaId);
    }
}