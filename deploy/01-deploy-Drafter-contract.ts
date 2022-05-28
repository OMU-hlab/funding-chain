import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"

const deployDrafterContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()

    log("----------------------------------------------------")
    log("Deploying DrafterContract and waiting for confirmations...")
    const governorContract = await deploy("Drafter", {
        from: deployer,
        args: [],
        log: true,
    })
    log(`GovernorContract at ${governorContract.address}`)
}

export default deployDrafterContract;
deployDrafterContract.tags = ["all", "drafter"];
