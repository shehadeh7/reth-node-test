// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public token;
    address user1 = vm.addr(1);
    address user2 = vm.addr(2);

    function setUp() public {
        token = new MyToken(1000 ether);

        token.transfer(user1, 500 ether);
    }

    function testTransfer() public {
        vm.prank(user1);
        token.transfer(user2, 100 ether);

        assertEq(token.balanceOf(user2), 100 ether);
    }

    function testTransferFrom() public {
        vm.prank(user1);
        token.approve(address(this), 200 ether);

        token.transferFrom(user1, user2, 150 ether);

        assertEq(token.balanceOf(user2), 150 ether);
    }
}
