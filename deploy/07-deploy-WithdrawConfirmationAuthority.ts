import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"

const deployWithdrawConfirmationAuthority: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()
    const TestETHToken = await get("TestETHToken")

    log("----------------------------------------------------")
    log("Deploying WithdrawConfirmationAuthority and waiting for confirmations...")
    const WithdrawConfirmationAuthority = await deploy("WithdrawConfirmationAuthority", {
        from: deployer,
        args: [
            [deployer],
            0,
            TestETHToken.address,
        ],
        log: true,
    })
    log(`WithdrawConfirmationAuthority contract at ${WithdrawConfirmationAuthority.address}`)
}

export default deployWithdrawConfirmationAuthority;
deployWithdrawConfirmationAuthority.tags = ["all", "pool"];