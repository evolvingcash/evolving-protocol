// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.4;

interface IUSDEStableCoin {
    /* ========== EVENTS ========== */

    // Track USDE burned
    event USDEBurned(address indexed from, address indexed to, uint256 amount);

    // Track USDE minted
    event USDEMinted(address indexed from, address indexed to, uint256 amount);

}
