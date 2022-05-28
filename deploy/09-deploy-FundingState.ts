import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"
import { ethers } from "hardhat";


const deployFundingState: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()
    const FundMoneyFactory = await ethers.getContract("FundMoneyFactory", deployer)
    const Drafter = await ethers.getContract("Drafter", deployer)

    log("----------------------------------------------------")
    log("Deploying FundingState and waiting for confirmations...")
    
    const FundingState = await deploy("FundingState", {
        from: deployer,
        // use depoly address of FundMoneyFactory
        args: [
            FundMoneyFactory.address,
            Drafter.address,
        ],
        log: true,
    })
    log(`FundingState contract at ${FundingState.address}`)
    
}

export default deployFundingState;
deployFundingState.tags = ["all", "pool"];
