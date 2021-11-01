// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract USDEStorage {
    /// @notice mintable pools
    bytes32 public constant MINTABLE_POOL_ROLE = keccak256("MINTABLE_POOL_ROLE");

    // @notice 2M (only for testing, genesis supply will be 5k on Mainnet). This is to help with establishing the Uniswap pools, as they need liquidity
    uint256 public constant genesisSupply = 2000000e18;

}
