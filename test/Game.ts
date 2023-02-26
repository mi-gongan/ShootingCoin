import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { deploySetting } from "./helper/deploySetting";
import { user1TokenId, user2TokenId } from "./helper/constant";

describe("goods", async function () {
  it("deploy test", async function () {
    const { ShootingCoinManager, ShootingRole, ShootingNFT } =
      await loadFixture(deploySetting);
    expect(await ShootingCoinManager.getShootingRole()).to.equal(
      ShootingRole.address
    );
    expect(await ShootingCoinManager.getShootingNft()).to.equal(
      ShootingNFT.address
    );
    expect(await ShootingNFT.getShootingRole()).to.equal(ShootingRole.address);
    expect(await ShootingNFT.getShootingManger()).to.equal(
      ShootingCoinManager.address
    );
  });
  it("game", async function () {
    const {
      ShootingCoinManager,
      ShootingRole,
      ShootingNFT,
      account1,
      account2,
      Mock1ERC20,
      Mock2ERC20,
      relayer,
    } = await loadFixture(deploySetting);
    await ShootingCoinManager.connect(account1).enterGame(account1.address, [
      Mock1ERC20.address,
      100,
      [user1TokenId, 0, 0, 0, 0],
    ]);
    await ShootingCoinManager.connect(account2).enterGame(account2.address, [
      Mock2ERC20.address,
      100,
      [user2TokenId, 0, 0, 0, 0],
    ]);

    expect(await Mock1ERC20.balanceOf(ShootingCoinManager.address)).to.equal(
      100
    );
    expect(await ShootingCoinManager.checkOnGame(account1.address)).to.equal(
      true
    );
    expect(await Mock2ERC20.balanceOf(ShootingCoinManager.address)).to.equal(
      100
    );
    expect(await ShootingCoinManager.checkOnGame(account2.address)).to.equal(
      true
    );

    await ShootingCoinManager.connect(relayer).startGame(
      1,
      account1.address,
      account2.address
    );
    await ShootingCoinManager.connect(relayer).settleGame(
      1,
      account1.address,
      account2.address,
      10,
      10
    );

    expect(await Mock1ERC20.balanceOf(account1.address)).to.deep.equal(0);
    expect(await Mock2ERC20.balanceOf(account1.address)).to.deep.equal(10);
    expect(await Mock2ERC20.balanceOf(account2.address)).to.deep.equal(0);
    expect(await Mock1ERC20.balanceOf(account2.address)).to.deep.equal(10);
  });
});
