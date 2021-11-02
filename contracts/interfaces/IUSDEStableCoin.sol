// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.4;

interface IUSDEStableCoin {
    /* ========== EVENTS ========== */

    // Track USDE burned
    event USDEBurned(address indexed account, uint256 amount);

    // Track USDE minted
    event USDEMinted(address indexed from, address indexed to, uint256 amount);

    // Collateral Ratio updated
    event CollateralRatioRefreshed(uint256 ratio);

    event CollateralRatioSet(uint256 ratio);
    event PriceBandSet(uint256 band);
    event RefreshCooldownSet(uint256 _seconds);
    event PriceAnchorSet(uint256 price);
    event RatioStepSet(uint256 step);
}
