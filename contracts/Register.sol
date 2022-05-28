// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Modifier that can execute only each role, and role registration function
contract Register {
    // address of the person who deployed
    address public owner = msg.sender;
    struct Members {
        // Whether you are validater 
        bool is_validater;
        // Whether you are voter 
        bool is_voter;
        // Whether you are drafter 
        bool is_drafter;
        // Whether you are founder
        // If drafter's idea is voted on, the drafter becomes a founder!
        bool is_founder;
        // Score based on past performance
        uint256 score;
    }

    mapping(address => Members) members;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyValidater() {
        require(members[msg.sender].is_validater == true);
        _;
    }

    modifier onlyVoter() {
        require(members[msg.sender].is_voter == true);
        _;
    }

    modifier onlyDrafter() {
        require(members[msg.sender].is_drafter == true);
        _;
    }

    modifier onlyFounder() {
        require(members[msg.sender].is_founder == true);
        _;
    }

    function add_Validater(address ID_) onlyOwner() public {
        members[ID_].is_validater = true;
    }
    
    function add_Voter(address ID_) onlyValidater() public {
        members[ID_].is_voter = true;
    }

    function add_drafter(address ID_) onlyValidater() public {
        members[ID_].is_drafter = true;
        members[ID_].is_founder = false;
    }
    
    function add_Founder(address ID_) onlyValidater() public {
        members[ID_].is_founder = true;
        members[ID_].is_drafter = false;
    }
}