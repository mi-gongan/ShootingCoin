import { ethers, upgrades } from "hardhat";

async function main() {
  const ShootingRoleToken = await ethers.getContractFactory("ShootingRole");
  const ShootingCoinManagerToken = await ethers.getContractFactory(
    "ShootingCoinManager"
  );
  const ShootingNFTToken = await ethers.getContractFactory("ShootingNFT");

  const ShootingRole = await upgrades.deployProxy(ShootingRoleToken, []);
  await ShootingRole.deployed();

  await ShootingRole.addRelayer(process.env.RELAYER_ADDRESS);

  const ShootingCoinManager = await upgrades.deployProxy(
    ShootingCoinManagerToken,
    [ShootingRole.address, 5, "owner addres 자리"]
  );
  await ShootingCoinManager.deployed();

  const ShootingNFT = await upgrades.deployProxy(ShootingNFTToken, [
    ShootingRole.address,
    ShootingCoinManager.address,
  ]);
  await ShootingNFT.deployed();

  await ShootingCoinManager.updateShootingNft(ShootingNFT.address);

  console.log("ShootingRole deployed to:", ShootingRole.address);
  console.log("ShootingCoinManager deployed to:", ShootingCoinManager.address);
  console.log("ShootingNFT deployed to:", ShootingNFT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
