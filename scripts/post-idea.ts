import { ethers } from "hardhat";

export async function post(
    explanation: string,
    timelimit: number,
    targetMoney: number,
    investmentForm: string
) {
    const drafter = await ethers.getContract("Drafter");
    const voter = await ethers.getContract("Voter");

    console.log(`Posting idea ${explanation} by ${timelimit} with ${targetMoney}`)
    console.log(`Investment form is ${investmentForm}`)

    const ideaTx = await drafter.postIdea(
        explanation,
        timelimit,
        targetMoney,
        investmentForm
    );

    const proposeReceipt = await ideaTx.wait(1);
    const event = proposeReceipt.events?.find((event: { event: string; }) => event.event === "IdeaPosted");

    const id = await drafter.getId(1);

    const possible = await drafter.getVotingpossible(id);

    const inventor = await drafter.getInventor(id);

    console.log(id.toString());
    console.log(event.toString());
    console.log(possible.toString());
    console.log(inventor.toString());
}

post("unbelievable project", 10, 3000, "all-in")
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })

// string calldata _explanation,
// uint256 _timelimit,
// uint256 _targetMoney,
// string calldata _investmentForm