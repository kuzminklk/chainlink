

# — Scripts —

# Deploy contracts and send message
forge script script/SendCrossChainMessage.s.sol:SendCrossChainMessage --broadcast --multi --account development-1

# Verify message
forge script script/VerifyCrossChainMessage.s.sol:VerifyCrossChainMessage
