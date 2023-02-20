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
});
