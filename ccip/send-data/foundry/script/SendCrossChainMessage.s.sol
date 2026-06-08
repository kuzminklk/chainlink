

// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Script, console } from "forge-std/Script.sol";

import { Sender } from "../src/Sender.sol";
import { Receiver } from "../src/Receiver.sol";
import { LinkTokenInterface } from "chainlink-evm/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";


contract SendCrossChainMessage is Script {
    // Avalanche Fuji configuration
    address constant FUJI_ROUTER = 0xF694E193200268f9a4868e4Aa017A0118C9a8177;
    address constant FUJI_LINK = 0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846;

    // Ethereum Sepolia configuration
    address constant SEPOLIA_ROUTER =0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59;
    uint64 constant SEPOLIA_CHAIN_SELECTOR = 16015286601757825753;

    // Configuring decimal value for LINK token
    uint256 ONE_LINK = 1e18;

    function run() public {

        // Load form configs from foundry.toml
        uint256 fujiFork = vm.createFork(vm.rpcUrl("fuji"));
        uint256 sepoliaFork = vm.createFork(vm.rpcUrl("sepolia"));

        // Step 1: Deploy Sender on Fuji

        // Connect to Fuji Network
        console.log("Connecting to Avalanche Fuji...");
        vm.selectFork(fujiFork);
        vm.startBroadcast();

					// Deploy Sender contract
					console.log("\n[Step 1] Deploying Sender contract on Avalanche Fuji...");
					Sender sender = new Sender(FUJI_ROUTER, FUJI_LINK);
					console.log("Sender contract has been deployed to this address on the Fuji testnet:", address(sender));
					console.log(
							string.concat(
									"View on Avascan: https://testnet.avascan.info/blockchain/all/address/",
									vm.toString(address(sender))
							)
					);

					// Step 2: Fund Sender with 1 LINK
					console.log("\n[Step 2] Funding Sender with 1 LINK on Avalanche Fuji...");
					LinkTokenInterface(FUJI_LINK).transfer(address(sender), ONE_LINK);
        vm.stopBroadcast();
        console.log("Funded Sender with 1 LINK on Fuji");

        // Step 3: Deploy Receiver on Sepolia

        // Connect to Sepolia Network
        console.log("Connecting to Ethereum Sepolia...");
        vm.selectFork(sepoliaFork);
        vm.startBroadcast();

					// Deploy Receiver contract

					console.log("\n[Step 3] Deploying Receiver contract on Ethereum Sepolia...");
					Receiver receiver = new Receiver(SEPOLIA_ROUTER);
        vm.stopBroadcast();
        console.log("Receiver deployed on Sepolia at this address:", address(receiver));
        console.log(
            string.concat(
                "View on Etherscan: https://sepolia.etherscan.io/address/",
                vm.toString(address(receiver))
            )
        );
        console.log("\n .....Copy the receiver address since it will be needed to run the verification script.....\n");
        console.log(address(receiver));

        // Step 4: Send cross-chain message (Fuji -> Sepolia)
        vm.selectFork(fujiFork);
        vm.startBroadcast();

        // Send cross-chain message
        console.log("Sending cross-chain message from Fuji to Sepolia...");
        bytes32 messageId = sender.sendMessage(
            SEPOLIA_CHAIN_SELECTOR,
            address(receiver),
            "Hello World from Foundry script!"
        );
        vm.stopBroadcast();

        console.log("The message has been sent to the CCIP router on Fuji, check for successful delivery after 5 minutes...");
        console.log("CCIP messageId:");
        console.logBytes32(messageId);
        console.log("View transaction status on CCIP Explorer: https://ccip.chain.link");
    }
}
