// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IDrafter {
    function postIdea(
        string calldata _explanation,
        uint256 _timeLimit,
        uint256 _targetMoney,
        string calldata _investmentForm
    ) external;   
    function getId(uint256 ideaId) external view returns(uint256);
    function viewId() external view returns(uint256);
    function getInventor(uint256 ideaId) external view returns(address);
    function getVotedNumber(uint256 ideaId) external view returns(uint256);
    function getGoalRate(uint256 ideaId) external view returns(uint256);
    function getTargetMoney(uint256 ideaId) external view returns(uint256);
    function getSubmissionTime(uint256 ideaId) external view returns(uint256);
    function getTimeLimit(uint256 ideaId) external view returns(uint256);
    function getExplanation(uint256 ideaId) external view returns(string memory);
    function getInvestmentForm(uint256 ideaId) external view returns(string memory);
    function getVotingpossible(uint256 ideaId) external view returns(bool);
    function getVoterCheck(uint256 ideaId) external view returns(bool);
    function addVotedNumber(uint256 ideaId) external returns(uint256);
    function deleteIdeaState(uint256 ideaId) external;
    function changeVotingPossible(uint256 ideaId) external;
    function changeVoterCheck(uint256 ideaId) external;
}