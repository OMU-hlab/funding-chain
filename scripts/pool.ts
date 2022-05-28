import { ethers } from "hardhat";

export async function pool(
) {
    const poolFactory = await ethers.getContract("FundMoneyFactory");
    const fundingState = await ethers.getContract("FundingState");

    const [owner, addr1] = await ethers.getSigners();

    const check = await fundingState.getCheck();
    console.log(check.toString());

    const address = await fundingState.getAddress(1);
    console.log(address.toString());
    const id = await fundingState.getid(1);
    console.log(id.toString());

    console.log(`pool is created for ${owner.address}`);

    const pool = await poolFactory.newFundMoneyPool()

    console.log(pool.toString());

    const getPool = await poolFactory.connect(addr1).newFundMoneyPool()

    console.log(getPool.toString());

}

pool()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })

// string calldata _explanation,
// uint256 _timelimit,
// uint256 _targetMoney,
// string calldata _investmentForm