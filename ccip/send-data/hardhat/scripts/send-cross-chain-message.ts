

import { network } from "hardhat"
import { getContract, parseAbi, parseUnits } from "viem"


// Avalanche Fuji configuration
const FUJI_ROUTER = "0xF694E193200268f9a4868e4Aa017A0118C9a8177"
const FUJI_LINK = "0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846"

// Ethereum Sepolia configuration
// Note that the contract on Sepolia doesn't need to have LINK to pay for CCIP fees.
const SEPOLIA_ROUTER = "0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59"
const SEPOLIA_CHAIN_SELECTOR = 16015286601757825753n

// Connect to Avalanche Fuji
console.log("Connecting to Avalanche Fuji...")
const fujiNetwork = await network.connect("avalancheFuji")

// Connect to Ethereum Sepolia
console.log("Connecting to Ethereum Sepolia...")
const sepoliaNetwork = await network.connect("sepolia")

// Step 1: Deploy Sender on Fuji
console.log("\n[Step 1] Deploying Sender contract on Avalanche Fuji...")

const sender = await fujiNetwork.viem.deployContract("Sender", [FUJI_ROUTER, FUJI_LINK])
const fujiPublicClient = await fujiNetwork.viem.getPublicClient()

console.log(`Sender contract has been deployed to this address on the Fuji testnet: ${sender.address}`)
console.log(`View on Avascan: https://testnet.avascan.info/blockchain/all/address/${sender.address}`)

// Step 2: Fund Sender with LINK
console.log("\n[Step 2] Funding Sender with 1 LINK...")

const [fujiWalletClient] = await fujiNetwork.viem.getWalletClients()
if (!fujiWalletClient) {
  throw new Error("No wallet client available. Check PRIVATE_KEY + network config in hardhat.config.ts.")
}

// We create a minimal interface for the LINK token to be able to call the transfer function.

const linkTokenInterfaceAbi = parseAbi(["function transfer(address to, uint256 value) returns (bool)"])

const link = getContract({
  address: FUJI_LINK,
  abi: linkTokenInterfaceAbi,
  client: { public: fujiPublicClient, wallet: fujiWalletClient },
})

const transferLinkToFujiContract = await link.write.transfer([sender.address, parseUnits("1", 18)])

console.log("LINK token transfer in progress, awaiting confirmation...")
await fujiPublicClient.waitForTransactionReceipt({ hash: transferLinkToFujiContract, confirmations: 1 })
console.log(`Funded Sender with 1 LINK`)

// Step 3: Deploy Receiver on Sepolia
console.log("\n[Step 3] Deploying Receiver on Ethereum Sepolia...")

const receiver = await sepoliaNetwork.viem.deployContract("Receiver", [SEPOLIA_ROUTER])
const sepoliaPublicClient = await sepoliaNetwork.viem.getPublicClient()

console.log(`Receiver contract has been deployed to this address on the Sepolia testnet: ${receiver.address}`)
console.log(`View on Etherscan: https://sepolia.etherscan.io/address/${receiver.address}`)
console.log(`\n📋 Copy the receiver address since it will be needed to run the verification script 📋 \n`)

// Step 4: Send cross-chain message
console.log("\n[Step 4] Sending cross-chain message...")

const sendMessageTx = await sender.write.sendMessage([
  SEPOLIA_CHAIN_SELECTOR,
  receiver.address,
  "Hello World from Hardhat script!",
])

console.log("Cross-chain message sent, awaiting confirmation...")
console.log(`Message sent from source contract! ✅ \n Tx hash: ${sendMessageTx}`)
console.log(`View transaction status on CCIP Explorer: https://ccip.chain.link`)
console.log(
  "Run the receiver script after 10 minutes to check if the message has been received on the destination contract."
)
