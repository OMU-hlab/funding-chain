import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"
import { ethers } from "hardhat";


const deployFundMoneyFactory: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()
    const TestETHToken = await ethers.getContract("TestETHToken", deployer)
    const WithdrawConfirmationAuthority = await ethers.getContract("WithdrawConfirmationAuthority", deployer)

    log("----------------------------------------------------")
    log("Deploying FundMoneyFactory and waiting for confirmations...")
    const FundMoneyFactory = await deploy("FundMoneyFactory", {
        from: deployer,
        args: [
            TestETHToken.address,
            WithdrawConfirmationAuthority.address,
        ],
        log: true,
    })
    log(`FundMoneyFactory contract at ${FundMoneyFactory.address}`)
}

export default deployFundMoneyFactory;
deployFundMoneyFactory.tags = ["all", "pool"];