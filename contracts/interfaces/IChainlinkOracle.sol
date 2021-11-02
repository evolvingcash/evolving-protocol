// SPDX-License-Identifier: GNU GPLv3
pragma solidity ^0.8.4;

/// @title IChainlinkOracle
/// @author evolving-protocol Core Team
/// @notice Interface for evolving-protocol oracle contracts reading oracle rates from Chainlink
interface IChainlinkOracle {
    function getLatestPrice() external view returns (int);
    function getDecimals() external view returns (uint8);
}