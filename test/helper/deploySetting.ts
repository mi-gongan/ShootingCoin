import { ethers, upgrades } from "hardhat";
import { user1TokenId, user2TokenId } from "./constant";

export async function deploySetting() {
  const [owner, account1, account2, relayer] = await ethers.getSigners();
  const ShootingRoleToken = await ethers.getContractFactory("ShootingRole");
  const ShootingCoinManagerToken = await ethers.getContractFactory(
    "ShootingCoinManager"
  );
  const ShootingNFTToken = await ethers.getContractFactory("ShootingNFT");

  const ShootingRole = await upgrades.deployProxy(ShootingRoleToken, []);
  await ShootingRole.deployed();

  await ShootingRole.addRelayer(relayer.address);

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

  await ShootingNFT.mint(account1.address, user1TokenId);
  await ShootingNFT.mint(account2.address, user2TokenId);

  //MockERC20 token
  const MockERC20Token = await ethers.getContractFactory("ERC20Mock");
  //ERC20 deploy token
  const Mock1ERC20 = await MockERC20Token.deploy();
  const Mock2ERC20 = await MockERC20Token.deploy();
  await Mock1ERC20.deployed();
  await Mock2ERC20.deployed();
  await Mock1ERC20.mint(account1.address, 100);
  await Mock1ERC20.connect(account1).approve(ShootingCoinManager.address, 100);
  // await Mock2ERC20.mint(account1.address, 100);
  // await Mock2ERC20.connect(account1).approve(ShootingCoinManager.address, 100);

  // await Mock1ERC20.mint(account2.address, 100);
  // await Mock1ERC20.connect(account2).approve(ShootingCoinManager.address, 100);
  await Mock2ERC20.mint(account2.address, 100);
  await Mock2ERC20.connect(account2).approve(ShootingCoinManager.address, 100);
  return {
    owner,
    account1,
    account2,
    ShootingCoinManager,
    ShootingRole,
    ShootingNFT,
    Mock1ERC20,
    Mock2ERC20,
    relayer,
  };
}
