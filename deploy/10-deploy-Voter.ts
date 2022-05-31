import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"
import { ethers } from "hardhat";

const deployVoter: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()
    const FundMoneyFactory = await ethers.getContract("FundMoneyFactory",deployer)

    const Drafter = await ethers.getContract("Drafter",deployer)
    const FundingState = await ethers.getContract("FundingState", deployer)


    const votingDelay = 1;
    const votingPeriod = 20;

    log("----------------------------------------------------")
    log("Deploying Voter and waiting for confirmations...")
    
    const Voter = await deploy("Voter", {
        from: deployer,
        // use depoly address of FundMoneyFactory
        args: [
            votingDelay,
            votingPeriod,
            Drafter.address,
            FundingState.address,
        ],
        log: true,
    })
    log(`Voter contract at ${Voter.address}`)
    
}

export default deployVoter;
deployVoter.tags = ["all", "pool"];