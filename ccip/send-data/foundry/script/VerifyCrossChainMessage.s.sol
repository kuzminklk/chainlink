

// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { Script, console } from "forge-std/Script.sol";
import { Receiver } from "../src/Receiver.sol";


contract VerifyCrossChainMessage is Script {

    bytes32 constant ZERO_BYTES32 = bytes32(0);

    function run() public {

        address receiverAddress = 0x788A7FB4c6fc5eD9286D121c018045CEdd97EA17;
        require(receiverAddress != address(0), "Set RECEIVER_ADDRESS");

        console.log("Connecting to Ethereum Sepolia...");
        uint256 sepoliaFork = vm.createFork(vm.rpcUrl("sepolia"));
        vm.selectFork(sepoliaFork);

        console.log("Checking for received message...\n");
        Receiver receiver = Receiver(receiverAddress);

        (bytes32 messageId, string memory text) = receiver
            .getLastReceivedMessageDetails();

        if (messageId == ZERO_BYTES32) {
            console.log("No message received yet.");
            console.log("Please wait a bit longer and try again.");
            revert("No message received yet");
        }

        console.log("Received Message ID:");
        console.logBytes32(messageId);
        console.log(string.concat('Received Text: "', text, '"'));
    }
}
