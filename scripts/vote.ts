import { ethers } from "hardhat";

export async function voteWithReason(
  ideaId: number,
  reason: string
) {
    const voter = await ethers.getContract("Voter");

    console.log(`Voting ${ideaId} with ${reason}`);

    const voteTx = await voter.voteWithReason(
        ideaId,
        reason
    );

    const proposeReceipt = await voteTx.wait(1);
    const event = proposeReceipt.events?.find((event: { event: string; }) => event.event === "IdeaPosted");
    const votedNumber = await voter.getVotedNum(ideaId);
    const votingpossible = await voter.getpossible(ideaId);

    console.log(votedNumber.toString());
    console.log(votingpossible.toString());
}

voteWithReason(1, "wowow")
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })

// string calldata _explanation,
// uint256 _timelimit,
// uint256 _targetMoney,
// string calldata _investmentForm