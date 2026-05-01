/* 

// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { TokenTransferor } from "../src/TokenTransferor.sol";
import { Script } from "forge-std/Script.sol";


contract FundContractWithLinkTokens is Script {
	uint64 public constant SEPOLIA_CHAIN_SELECTOR = 16015286601757825753;
	address public constant DEVELOPMENT_1 = 0xa99C9296010AfA29bBF403ec303155CADD40C601;
	address public constant CCIP_BNM = 0xD21341536c5cF5EB1bcb58f6723cE26e8D8E90e4;
	uint256 public constant AMOUNT = 1000000000000000;

	function run() external returns (TokenTransferor) {
		vm.startBroadcast();

		TokenTransferor TokenTransferorContract = TokenTransferor(0xB63F9bD658C8827Bff8CAAA93bC585Aa7ddb511b);
		TokenTransferorContract.transferTokensPayLINK(SEPOLIA_CHAIN_SELECTOR, DEVELOPMENT_1, CCIP_BNM, AMOUNT);

		vm.stopBroadcast();

		return TokenTransferorContract;
	}
} */