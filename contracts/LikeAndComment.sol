// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract LikeAndComment {

    // address => Whether you liked it
    mapping (address => bool) public isLiked;

    // ideaId & comment writer => commentID
    mapping (address => mapping(uint256 => uint256)) public commentedMemberListIndexes;

    // ideaId => number of comments
    mapping (uint256 => uint256) public idToTotalComment;

    // Manage comments by mapping (ideaId => comment)
    mapping (uint256 => comment[]) public idToComment;

    uint256 commentId;

    struct comment {
        // commentID
        uint256 CID;
        // Number of likes to comment
        uint256 totalLiked;
        // person who wrote the comment
        address writer;
        // comment
        string commentBody;
    }

    // like to idea
    function like(uint256 ideaId) public {

        require(!isLiked[msg.sender], "already liked");

        isLiked[msg.sender] = true;

        idToTotalComment[ideaId]++;

    }

    // erase like
    function erase_like(uint256 ideaId) public {

        require(isLiked[msg.sender], "not liked yet");

        isLiked[msg.sender] = false;
        
        idToTotalComment[ideaId]--;

    }

/*  ------------------------------- comment ------------------------------------------*/


    //　comment on idea
    function Makingcomment(uint256 ideaId, string calldata _comment) public {

        require(commentedMemberListIndexes[msg.sender][ideaId] > 0, "comment is not created");

        _registerComment(ideaId, _comment);

    }

/* ----------------------------comment helper function----------------------------------- */

    // register comment on idea
    function _registerComment(uint256 ideaId, string calldata _commentBody) private {
        // index 1
        commentId++;
        uint256 id = commentId;

        idToComment[ideaId].push(
            comment({
                CID: id,
                totalLiked: 0,
                writer: msg.sender,
                commentBody: _commentBody
            })
        );

        // register
        commentedMemberListIndexes[msg.sender][ideaId] = id;

        // update the number of comments
        idToTotalComment[ideaId]++;
    }
}