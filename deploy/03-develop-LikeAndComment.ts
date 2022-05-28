import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"

const deployLikeAndComment: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()

    log("----------------------------------------------------")
    log("Deploying LikeAndComment and waiting for confirmations...")
    const LikeAndComment = await deploy("LikeAndComment", {
        from: deployer,
        args: [],
        log: true,
    })
    log(`LikeAndComment contract at ${LikeAndComment.address}`)
}

export default deployLikeAndComment;
deployLikeAndComment.tags = ["all", "LikeAndComment"];