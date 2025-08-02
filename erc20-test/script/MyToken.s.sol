// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenScript is Script {
    address user1;
    address user2;

    function run() external {
        // Load deployer key and user addresses from .env
        uint256 deployerKey = vm.envUint("ACCOUNT_0_PRIVATE_KEY");
        user1 = vm.envAddress("ACCOUNT_1_ADDRESS");
        user2 = vm.envAddress("ACCOUNT_2_ADDRESS");

        // Start broadcasting transactions to the reth RPC
        vm.startBroadcast(deployerKey);

        // Deploy token with 1000 tokens
        MyToken token = new MyToken(1000 ether);
        console.log("Token deployed at:", address(token));

        // Transfer 400 tokens to user1
        token.transfer(user1, 400 ether);
        console.log("Transferred 400 tokens to user1:", user1);

        // From deployer -> user2 directly (just for variety)
        token.transfer(user2, 50 ether);
        console.log("Transferred 50 tokens to user2:", user2);
        vm.stopBroadcast();

        // Approve user2 to spend tokens from user1 (need to impersonate user1)
        vm.startBroadcast(vm.envUint("ACCOUNT_1_PRIVATE_KEY"));
        token.approve(user2, 100 ether);
        console.log("User1 approved user2 for 100 tokens");
        vm.stopBroadcast();

        // Simulate user2 using transferFrom on behalf of user1
        vm.startBroadcast(vm.envUint("ACCOUNT_2_PRIVATE_KEY"));
        token.transferFrom(user1, user2, 80 ether);
        console.log("User2 transferred 80 tokens from user1 to themselves");
        vm.stopBroadcast();
    }
}
