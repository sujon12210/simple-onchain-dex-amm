// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./SimpleAMM.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 10000e18);
    }
}

contract SimpleAMMTest is Test {
    SimpleAMM public amm;
    MockToken public token0;
    MockToken public token1;
    address public provider = address(1);

    function setUp() public {
        token0 = new MockToken("Token0", "T0");
        token1 = new MockToken("Token1", "T1");
        amm = new SimpleAMM(address(token0), address(token1));

        token0.transfer(provider, 1000e18);
        token1.transfer(provider, 1000e18);
    }

    function testAddLiquidity() public {
        vm.startPrank(provider);
        token0.approve(address(amm), 100e18);
        token1.approve(address(amm), 100e18);
        amm.addLiquidity(100e18, 100e18);
        vm.stopPrank();

        assertEq(amm.reserve0(), 100e18);
        assertEq(amm.reserve1(), 100e18);
    }
}
