
import { configVariable, defineConfig } from "hardhat/config"
import hardhatKeystore from "@nomicfoundation/hardhat-keystore"
import hardhatViem from "@nomicfoundation/hardhat-viem"

export default defineConfig({
	plugins: [hardhatViem, hardhatKeystore],
  solidity: {
    version: "0.8.24",
  },
	networks: {
		sepolia: {
			type: "http",
			url: configVariable("SEPOLIA_PRC_URL"),
			accounts: [configVariable("PRIVATE_KEY")],
		},
		avalancheFuji: {
			type: "http",
			url: configVariable("FUJI_PRC_URL"),
			accounts: [configVariable("PRIVATE_KEY")],
		}		
	}
})
