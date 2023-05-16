import { ethers } from "hardhat";

enum ShootingCoinNFTStat {
  defense = 0,
  attack = 1,
}

async function main() {
  if (process.env.NFT_ADDRESS) {
    console.log("Deployed Contract Address:", process.env.NFT_ADDRESS);
    const nft = await ethers.getContractAt(
      "ShootingNFT",
      process.env.NFT_ADDRESS
    );
    for (let i = 0; i < 10; i++) {
      const stat = 5;
      const tx = await nft.mint(
        "0x8D693b69D0042F9A06206347132FB613dFdFAbb7",
        i,
        ShootingCoinNFTStat.defense,
        stat
      );
      console.log("tx:", tx);
    }
    console.log("ShootingCoinNFT address :", nft.address);
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
