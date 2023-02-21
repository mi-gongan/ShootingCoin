import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import "hardhat-gas-reporter";
import "hardhat-abi-exporter";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  gasReporter: {
    gasPriceApi:
      "https://api.etherscan.io/api?module=proxy&action=eth_gasPrice",
    enabled: true,
  },
  abiExporter: [
    {
      path: "./abi/pretty",
      pretty: true,
    },
    {
      path: "./abi/ugly",
      pretty: false,
    },
  ],
};

export default config;
