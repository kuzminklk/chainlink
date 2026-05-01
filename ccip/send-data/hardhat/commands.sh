

# — Hardhat —

# Initialize
npx hardhat --init

# Install dependences
npm install @chainlink/contracts-ccip @chainlink/contracts viem
npm install --save-dev @nomicfoundation/hardhat-viem @nomicfoundation/hardhat-keystore


# — Keystore —

# Add value to keystore
npx hardhat keystore set PRIVATE_KEY

# List values
npx hardhat keystore list


# — Scripts —

npx hardhat run scripts/verify-cross-chain-message.ts
