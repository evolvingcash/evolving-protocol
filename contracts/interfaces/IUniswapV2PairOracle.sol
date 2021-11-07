// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.4;

interface IUniswapV2PairOracle {
    function consult(address token, uint amountIn) external view returns (uint amountOut);
}
