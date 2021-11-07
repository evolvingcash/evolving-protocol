// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "../interfaces/AggregatorV3Interface.sol";

contract ChainlinkETHUSDOracle {
    AggregatorV3Interface internal priceFeed;


    constructor (address addr) {
        /// 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        priceFeed = AggregatorV3Interface(addr);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            , 
            int price,
            ,
            ,
            
        ) = priceFeed.latestRoundData();
        return price;
    }

    function getDecimals() public view returns (uint8) {
        return priceFeed.decimals();
    }
}