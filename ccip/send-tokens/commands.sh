

# — Scripts —

# Deploy contract
forge script script/DeployTokenTransferor.s.sol:DeployTokenTransferor --broadcast --rpc-url avalanche_fuji --account development-1

# Send tokens
forge script script/SendTokens.s.sol:SendTokens --broadcast --rpc-url avalanche_fuji --account development-1