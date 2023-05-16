import { ethers, upgrades } from "hardhat";

async function main() {
  if (process.env.MANAGER_ADDRESS) {
    const token = await ethers.getContractFactory("ShootingCoinManager");
    console.log("address", process.env.MANAGER_ADDRESS);

    const ShootingCoinManager2 = await upgrades.upgradeProxy(
      process.env.MANAGER_ADDRESS,
      token,
      {
        pollingInterval: 1000,
        timeout: 0,
      }
    );
    console.log(
      "ShootingCoinManager deployed to:",
      ShootingCoinManager2.address
    );
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
