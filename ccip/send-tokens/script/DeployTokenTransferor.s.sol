

// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { TokenTransferor } from "../src/TokenTransferor.sol";
import { Script } from "forge-std/Script.sol";


contract DeployTokenTransferor is Script {
	address public constant FUJI_CCIP_ROUTER = 0xF694E193200268f9a4868e4Aa017A0118C9a8177;
	address public constant FUJI_LINK = 0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846;
	uint64 public constant SEPOLIA_CHAIN_SELECTOR = 16015286601757825753;

	function run() external returns (TokenTransferor) {
		vm.startBroadcast();

		TokenTransferor TokenTransferorContract = new TokenTransferor(FUJI_CCIP_ROUTER, FUJI_LINK);
		TokenTransferorContract.allowlistDestinationChain(SEPOLIA_CHAIN_SELECTOR, true);

		vm.stopBroadcast();

		return TokenTransferorContract;
	}
}