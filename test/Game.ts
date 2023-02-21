import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { deploySetting } from "./helper/deploySetting";

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
      Mock3ERC20,
      Mock4ERC20,
      Mock5ERC20,
    } = await loadFixture(deploySetting);
    const gameId = 1;
    await ShootingCoinManager.connect(account1).enterGame(
      [
        account1.address,
        [Mock1ERC20.address, 10],
        [Mock2ERC20.address, 10],
        [Mock3ERC20.address, 10],
        [Mock4ERC20.address, 10],
        [Mock5ERC20.address, 10],
      ],
      gameId
    );
    await ShootingCoinManager.connect(account2).enterGame(
      [
        account2.address,
        [Mock1ERC20.address, 10],
        [Mock2ERC20.address, 10],
        [Mock3ERC20.address, 10],
        [Mock4ERC20.address, 10],
        [Mock5ERC20.address, 10],
      ],
      gameId
    );
    expect(await ShootingCoinManager.checkOnGame(account1.address)).to.equal(
      gameId
    );
    expect(await ShootingCoinManager.checkOnGame(account2.address)).to.equal(
      gameId
    );
  });
});
