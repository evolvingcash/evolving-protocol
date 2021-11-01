// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

/**
 * @title Errors library
 * @author evolving-protocol
 * @notice Defines the error messages emitted by the different contracts of the evolving protocol
 * @dev Error messages prefix glossary:
 *  - UO = uniswap oracle
 *  - MATH = Math libraries
 *  - CT = Common errors between tokens (AToken, VariableDebtToken and StableDebtToken)
 *  - AT = AToken
 *  - SDT = StableDebtToken
 *  - VDT = VariableDebtToken
 *  - LP = LendingPool
 *  - LPAPR = LendingPoolAddressesProviderRegistry
 *  - LPC = LendingPoolConfiguration
 *  - RL = ReserveLogic
 *  - LPCM = LendingPoolCollateralManager
 *  - P = Pausable
 */
library Errors {
    // common errors
    string public constant NO_AUTH          = '10'; // 'The caller has no auth'
    string public constant INVALID_ADDRESS  = '11';

    string public constant UO_NO_AUTH            = '12'; // You are not an owner or the governance timelock
    string public constant UO_NO_RESERVES        = '13'; // UniswapPairOracle: NO_RESERVES
    string public constant UO_PERIOD_NOT_ELAPSED = '14'; // 
    string public constant UO_PRICE_NEED_UPDATE  = '15'; // price need update
    string public constant UO_INVALID_TOKEN      = '16'; // 
}
