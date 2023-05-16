import { ethers, upgrades } from "hardhat";

async function main() {
  if (process.env.NFT_ADDRESS) {
    const token = await ethers.getContractFactory("ShootingNFT");
    console.log("address", process.env.NFT_ADDRESS);

    const ShootingNFT2 = await upgrades.upgradeProxy(
      process.env.NFT_ADDRESS,
      token,
      {
        pollingInterval: 1000,
        timeout: 0,
      }
    );
    console.log("ShootingNFT deployed to:", ShootingNFT2.address);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
