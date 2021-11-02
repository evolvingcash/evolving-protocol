// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.4;

interface IUniswapPairOracle {
    function consult(address token, uint amountIn) external view returns (uint amountOut);
}
