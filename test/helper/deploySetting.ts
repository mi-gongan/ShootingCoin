import { ethers, upgrades } from "hardhat";

export async function deploySetting() {
  const [owner, account1, account2, relayer] = await ethers.getSigners();
  const ShootingRoleToken = await ethers.getContractFactory("ShootingRole");
  const ShootingCoinManagerToken = await ethers.getContractFactory(
    "ShootingCoinManager"
  );
  const ShootingNFTToken = await ethers.getContractFactory("ShootingNFT");

  const ShootingRole = await upgrades.deployProxy(ShootingRoleToken, []);
  await ShootingRole.deployed();

  const ShootingCoinManager = await upgrades.deployProxy(
    ShootingCoinManagerToken,
    [ShootingRole.address]
  );
  await ShootingCoinManager.deployed();

  const ShootingNFT = await upgrades.deployProxy(ShootingNFTToken, [
    ShootingRole.address,
    ShootingCoinManager.address,
  ]);
  await ShootingNFT.deployed();

  await ShootingCoinManager.updateShootingNft(ShootingNFT.address);

  return {
    owner,
    account1,
    account2,
    ShootingCoinManager,
    ShootingRole,
    ShootingNFT,
  };
}
