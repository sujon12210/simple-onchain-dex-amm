// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title SimpleAMM
 * @dev A basic Constant Product AMM (x * y = k).
 */
contract SimpleAMM {
    IERC20 public token0;
    IERC20 public token1;

    uint256 public reserve0;
    uint256 public reserve1;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address to, uint256 amount) private {
        balanceOf[to] += amount;
        totalSupply += amount;
    }

    function _burn(address from, uint256 amount) private {
        balanceOf[from] -= amount;
        totalSupply -= amount;
    }

    function swap(address tokenIn, uint256 amountIn) external returns (uint256 amountOut) {
        require(tokenIn == address(token0) || tokenIn == address(token1), "Invalid token");
        require(amountIn > 0, "Amount must be > 0");

        bool isToken0 = tokenIn == address(token0);
        (IERC20 tIn, IERC20 tOut, uint256 rIn, uint256 rOut) = isToken0
            ? (token0, token1, reserve0, reserve1)
            : (token1, token0, reserve1, reserve0);

        tIn.transferFrom(msg.sender, address(this), amountIn);

        // Constant Product Formula: (rIn + amountIn) * (rOut - amountOut) = rIn * rOut
        // amountOut = (rOut * amountIn) / (rIn + amountIn)
        uint256 amountInWithFee = (amountIn * 997) / 1000; // 0.3% fee
        amountOut = (rOut * amountInWithFee) / (rIn + amountInWithFee);

        tOut.transfer(msg.sender, amountOut);

        _updateReserves();
    }

    function addLiquidity(uint256 amount0, uint256 amount1) external returns (uint256 shares) {
        token0.transferFrom(msg.sender, address(this), amount0);
        token1.transferFrom(msg.sender, address(this), amount1);

        if (totalSupply == 0) {
            shares = _sqrt(amount0 * amount1);
        } else {
            shares = _min((amount0 * totalSupply) / reserve0, (amount1 * totalSupply) / reserve1);
        }

        require(shares > 0, "Shares must be > 0");
        _mint(msg.sender, shares);
        _updateReserves();
    }

    function _updateReserves() private {
        reserve0 = token0.balanceOf(address(this));
        reserve1 = token1.balanceOf(address(this));
    }

    function _sqrt(uint256 y) private pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _min(uint256 x, uint256 y) private pure returns (uint256) {
        return x <= y ? x : y;
    }
}
