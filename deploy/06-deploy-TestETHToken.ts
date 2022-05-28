import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat";

const deployTestETHToken: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  // @ts-ignore
  const { getNamedAccounts, deployments, network } = hre;
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("----------------------------------------------------")
  log("Deploying TestETHToken and waiting for confirmations...")
  const TestETHToken = await deploy("TestETHToken", {
    from: deployer,
    log: true,
    args: [],
    // waitConfirmations: 1, // For non-dev netwworks so we can verify
  });

  log(`06-Deployed 'TestETHToken' at ${TestETHToken.address}`);
};

export default deployTestETHToken;
deployTestETHToken.tags = ["all", "pool"];