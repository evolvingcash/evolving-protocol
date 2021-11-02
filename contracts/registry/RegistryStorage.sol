// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../interfaces/IUniswapPairOracle.sol";
import "../interfaces/IAggregatorV3.sol";

contract RegistryStorage {
    /// @notice USDE uniswap price oracle, in ETH
    IUniswapPairOracle private usdePriceOracle;

    /// @notice EVOL uniswap price oracle, in ETH
    IUniswapPairOracle private evolPriceOracle;

    IAggregatorV3 public ethOracle;
    
    address public usdeToken;
    address public evolToken;
    address public treasuryCotroller;
}
