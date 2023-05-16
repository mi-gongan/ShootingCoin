import { ethers } from "hardhat";

const tokenAddress = "0x2B82C160Fc42fB1F9da067164c838b41f4D541cB";

async function main() {
  if (process.env.MANAGER_ADDRESS) {
    console.log("Deployed Contract Address:", process.env.MANAGER_ADDRESS);
    const nft = await ethers.getContractAt(
      "ShootingCoinManager",
      process.env.MANAGER_ADDRESS
    );
    const tx = await nft.updateWhiteList(tokenAddress, true);
    console.log("ShootingCoinManager address :", nft.address);
    console.log("tx:", tx);
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
