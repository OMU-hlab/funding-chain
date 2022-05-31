// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Idea.sol";

contract Drafter is Idea {

    uint256 id = 0;

    event IdeaPosted(ideaState createdIdea);

    function postIdea(
        string calldata _explanation,
        uint256 _timeLimit,
        uint256 _targetMoney,
        string calldata _investmentForm
    ) public {

        id += 1;

        idToIdeaState[id].ideaId = id;
        idToIdeaState[id].inventor = msg.sender;
        idToIdeaState[id].votedNumber = 0;
        idToIdeaState[id].goalRate = 4;
        idToIdeaState[id].targetMoney = _targetMoney;
        idToIdeaState[id].submissionTime = block.number;
        idToIdeaState[id].timelimit = _timeLimit;
        idToIdeaState[id].explanation = _explanation;
        idToIdeaState[id].explanation = _investmentForm;
        idToIdeaState[id].votingpossible = true;
        idToIdeaState[id].votercheck = false;

        emit IdeaPosted(
            idToIdeaState[id]
        );
    }

    function getIdea(uint256 _ideaId) public view returns(ideaState memory) {
        return idToIdeaState[_ideaId];
    }

    function getId(uint256 _ideaId) public view returns(uint256) {
        return idToIdeaState[_ideaId].ideaId; 
    }

    function viewId() public view returns(uint256) {
        return id; 
    }

    function getInventor(uint256 ideaId) public view returns(address) {
        return idToIdeaState[ideaId].inventor;
    }

    function getVotedNumber(uint256 ideaId) public view returns(uint256){
        return idToIdeaState[ideaId].votedNumber;
    }

    function getGoalRate(uint256 ideaId) public view returns(uint256){
        return idToIdeaState[ideaId].goalRate;
    }

    function getTargetMoney(uint256 ideaId) public view returns(uint256){
        return idToIdeaState[ideaId].targetMoney;
    }
    
    function getSubmissionTime(uint256 ideaId) public view returns(uint256){
        return idToIdeaState[ideaId].submissionTime;
    }

    function getTimeLimit(uint256 ideaId) public view returns(uint256){
        return idToIdeaState[ideaId].timelimit;
    }

    function getExplanation(uint256 ideaId) public view returns(string memory){
        return idToIdeaState[ideaId].explanation;
    }

    function getInvestmentForm(uint256 ideaId) public view returns(string memory){
        return idToIdeaState[ideaId].investmentForm;
    }

    function getVotingpossible(uint256 ideaId) public view returns(bool) {
        return idToIdeaState[ideaId].votingpossible;
    }

    function getVoterCheck(uint256 ideaId) public view returns(bool) {
        return idToIdeaState[ideaId].votercheck;
    }


    function addVotedNumber(uint256 ideaId) public returns(uint256){
        idToIdeaState[ideaId].votedNumber += 1;
        return idToIdeaState[ideaId].votedNumber;
    }

    function changeVotingPossible(uint256 ideaId) public {
        idToIdeaState[ideaId].votingpossible = false;

    }

    function changeVoterCheck(uint256 ideaId) public {
        idToIdeaState[ideaId].votingpossible = true;
    }

    function deleteIdeaState(uint256 ideaId) public {
        delete idToIdeaState[ideaId];
    }

    receive() external payable {
    }
    fallback() external payable {
    }
}