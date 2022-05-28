import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat";

const deployToken: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  // @ts-ignore
  const { getNamedAccounts, deployments, network } = hre;
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("----------------------------------------------------")
  log("Deploying Token and waiting for confirmations...")
  const Token = await deploy("Token", {
    from: deployer,
    log: true,
    args: [],
    // waitConfirmations: 1, // For non-dev netwworks so we can verify
  });

  log(`06-Deployed 'Token' at ${Token.address}`);

  // Delegate votes to deployer.
  await delegate(Token.address, deployer);
  log(`Delegated votes to ${deployer} `);
};

const delegate = async (
  TokenAddress: string,
  delegatedAccount: string
) => {
  const Token = await ethers.getContractAt(
    "Token",
    TokenAddress
  );
  const txResponse = await Token.delegate(delegatedAccount);
  await txResponse.wait(1);
  console.log(
    `Checkpoints: ${await Token.numCheckpoints(delegatedAccount)}`
  );
};

export default deployToken;
deployToken.tags = ["all", "governor"];