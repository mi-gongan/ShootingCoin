import { ethers, upgrades } from "hardhat";

async function main() {
  if (process.env.ROLE_ADDRESS) {
    const token = await ethers.getContractFactory("ShootingRole");
    console.log("address", process.env.ROLE_ADDRESS);

    const ShootingRole2 = await upgrades.upgradeProxy(
      process.env.ROLE_ADDRESS,
      token,
      {
        pollingInterval: 1000,
        timeout: 0,
      }
    );
    console.log("ShootingRole deployed to:", ShootingRole2.address);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
