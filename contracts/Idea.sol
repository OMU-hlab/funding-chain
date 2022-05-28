// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Idea {


    struct ideaState {
        // idea's id (Drafter)
        uint256 ideaId;
        // drafter's address
        address inventor;
        // number of votes in favor
        uint256 votedNumber;
        // goal% (Drafterでhardcode)
        uint256 goalRate;
        // target amount by drafter
        uint256 targetMoney;
        // number of blocks when creating an idea (Drafter)
        uint256 submissionTime;
        // deadline for customers to invest
        uint256 timelimit;
        // metadata (Drafter)
        string explanation;
        // voting form (all-in, all or nothing, etc) (Drafter)
        string investmentForm;
        // Whether voters can vote
        // true => can vote
        // if idea is submitted or banished -> false => cannot vote
        bool votingpossible;
        // Whether this idea is possible by voter
        bool votercheck;
    }

    mapping (uint256 => ideaState) public idToIdeaState;
    
}