// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../interfaces/IUniswapPairOracle.sol";

contract RegistryStorage {
    /// @notice USDE uniswap price oracle, in ETH
    IUniswapPairOracle private usdePriceOracle;

    /// @notice EVOL uniswap price oracle, in ETH
    IUniswapPairOracle private evolPriceOracle;
    
    address public usde;
    address public evol;

}
