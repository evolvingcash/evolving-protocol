// SPDX-License-Identifier: GNU GPLv3
pragma solidity ^0.8.4;

import "./AggregatorV3Interface.sol";
import "./IUniswapV2PairOracle.sol";

/// @title IRegistry
/// @author evolving-protocol Core Team
/// @notice Interface for evolving-protocol reading contract address
interface IRegistry {
    /// @dev getUSDEToken get USDE stable coin address
    function getUSDEToken() external view returns (address usdeToken);

    /// @dev getEVOLToken get EVOL token address
    function getEVOLToken() external view returns (address evolToken);

    /// @dev getTreasury get treasury address
    function getTreasury() external view returns (address treasury);

    /// @dev getETHOracle get ChainLink ETH Oracle address
    function getETHOracle() external view returns (AggregatorV3Interface);
    
    /// @dev getUSDEUniswapV2Oracle get Uniswap pair USDE/ETH address
    function getUSDEUniswapV2Oracle() external view returns (IUniswapV2PairOracle);

    /// @dev getEVOLUniswapV2Oracle get Uniswap pair EVOL/ETH address
    function getEVOLUniswapV2Oracle() external view returns (IUniswapV2PairOracle);

    /// @dev getWETH get WETH address
    function getWETH() external view returns (address);
}
