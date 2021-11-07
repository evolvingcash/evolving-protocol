// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../interfaces/IUniswapV2PairOracle.sol";
import "../interfaces/AggregatorV3Interface.sol";

contract RegistryStorage {
    /// @notice USDE uniswap price oracle, in ETH
    IUniswapV2PairOracle internal _usdePairOracle;

    /// @notice EVOL uniswap price oracle, in ETH
    IUniswapV2PairOracle internal _evolPairOracle;

    /// @notice the ETH/USD oracle
    AggregatorV3Interface internal _ethOracle;

    /// @notice chainlink oracle map, such as USDT, USDC oracles, etc
    mapping(address => AggregatorV3Interface) internal _chainlinkOracles;

    address public weth;

    address internal _usdeToken;
    address internal _evolToken;
    address internal _treasury;
}
