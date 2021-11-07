// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "../interfaces/AggregatorV3Interface.sol";
import "../interfaces/IRegistry.sol";

import "./Errors.sol";

/**
 * @title PriceLogic get price logic
 * @dev library for get USDE/EVOL price
 * @author evolving-protocol core team
 */
library PriceLogic {
    using SafeMath for uint256;

    enum PriceToken { USDE, EVOL }
    uint256 private constant PRICE_PRECISION = 1e8;

    /// 间接通过Token/ETH ETH/USD 获取 token 相对 USD 的币价
    function getPriceInUSDByETH(PriceToken token, IRegistry registry) public view returns (uint256) {
        AggregatorV3Interface ethOracle = registry.getETHOracle();
        IUniswapV2PairOracle pairOracle;

        if (token == PriceToken.USDE) {
            pairOracle = registry.getUSDEUniswapV2Oracle();
        } else if (token == PriceToken.EVOL) {
            pairOracle = registry.getEVOLUniswapV2Oracle();
        } else {
            revert(Errors.UO_INVALID_TOKEN);
        }

        uint256 priceInETH = pairOracle.consult(registry.getWETH(), PRICE_PRECISION);
        (, int256 ethUSDPrice, , ,) = ethOracle.latestRoundData();
        uint8 decimals = ethOracle.decimals();
        uint256 ethPrice = uint256(ethUSDPrice).mul(PRICE_PRECISION).div(uint256(10) ** decimals);
        return ethPrice.mul(PRICE_PRECISION).div(priceInETH);
    }

    /// 直接通过 Token/USDC USDC/USD 交易对获取 token 相对 USD 的币价
    function getPriceInUSDC(PriceToken token, IRegistry registry) public view returns (uint256) {

    }
}
