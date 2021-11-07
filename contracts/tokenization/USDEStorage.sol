// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../interfaces/IRegistry.sol";

contract USDEStorage {
    /// @notice mintable pools
    bytes32 public constant MINTABLE_POOL_ROLE = keccak256("MINTABLE_POOL_ROLE");
    /// @notice governance or owner 
    bytes32 public constant OWNER_OR_GOVERN_ROLE = keccak256("OWNER_OR_GOVERN_ROLE");

    /// @notice 2M (only for testing, genesis supply will be 5k on Mainnet). This is to help with establishing the Uniswap pools, as they need liquidity
    uint256 public genesisSupply;

    /// @notice registry address
    IRegistry public registry;

    /// @notice Last time the refreshCollateralRatio function was called
    uint256 public lastRefreshTime;
    /// @notice collateral ratio
    uint256 public collateralRatio;
    /// @notice refresh collateral interval, in second, default 3600 seconds
    uint256 public refreshCooldown;
    /// @notice price to anchor
    uint256 public priceAnchor;
    /// @notice price band
    uint256 public priceBand;
    /// @notice per price adjust step, div by 1e6 1000000
    uint256 public ratioStep;

    uint256 public stage1Supply;
    uint256 public stage2Supply;

    /// @notice is collateral ratio refresh paused
    bool public collateralRatioPaused;
}
