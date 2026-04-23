

import { network } from "hardhat"


// Paste the Receiver contract address
const RECEIVER_ADDRESS = "0xecc5bdf3869a86602ad76325d9d699b7430d6822"

console.log("Connecting to Ethereum Sepolia...")
const sepoliaNetwork = await network.connect("sepolia")

console.log("Checking for received message...\n")
const receiver = await sepoliaNetwork.viem.getContractAt("Receiver", RECEIVER_ADDRESS)

const [messageId, text] = await receiver.read.getLastReceivedMessageDetails()

// A null hexadecimal value means no message has been received yet
const ZERO_BYTES32 = "0x0000000000000000000000000000000000000000000000000000000000000000"

if (messageId === ZERO_BYTES32) {
  console.log("No message received yet.")
  console.log("Please wait a bit longer and try again.")
  process.exit(1)
} else {
  console.log(`✅ Message ID: ${messageId}`)
  console.log(`Text: "${text}"`)
}
