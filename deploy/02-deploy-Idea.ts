import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"

const deployIdea: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()

    log("----------------------------------------------------")
    log("Deploying Idea and waiting for confirmations...")
    const Idea = await deploy("Idea", {
        from: deployer,
        args: [],
        log: true,
    })
    log(`Idea contract at ${Idea.address}`)
}

export default deployIdea;
deployIdea.tags = ["all", "Idea"];
