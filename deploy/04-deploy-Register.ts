import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"

const deployRegister: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()

    log("----------------------------------------------------")
    log("Deploying Register and waiting for confirmations...")
    const Register = await deploy("Register", {
        from: deployer,
        args: [],
        log: true,
    })
    log(`Register contract at ${Register.address}`)
}

export default deployRegister;
deployRegister.tags = ["all", "Register"];