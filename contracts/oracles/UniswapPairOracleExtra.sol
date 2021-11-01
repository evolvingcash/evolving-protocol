// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

import '../interfaces/uniswap/IUniswapV2Factory.sol';
import '../interfaces/uniswap/IUniswapV2Pair.sol';
import '../libraries/FixedPoint.sol';
import "../libraries/Errors.sol";
import '../libraries/uniswap/UniswapV2OracleLibrary.sol';
import '../libraries/uniswap/UniswapV2Library.sol';

// Fixed window oracle that recomputes the average price for the entire period once every period
// Note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period
contract UniswapPairOracleExtra is Ownable {
    using FixedPoint for *;
    
    address timelock;

    uint public PERIOD = 3600; // 1 hour TWAP (time-weighted average price)
    uint public CONSULT_LENIENCY = 120; // Used for being able to consult past the period end
    bool public ALLOW_STALE_CONSULTS = true; // If false, consult() will fail if the TWAP is stale

    IUniswapV2Pair public immutable pair;
    address public immutable token0;
    address public immutable token1;

    uint    public price0CumulativeLast;
    uint    public price1CumulativeLast;
    uint32  public blockTimestampLast;
    FixedPoint.uq112x112 public price0Average;
    FixedPoint.uq112x112 public price1Average;

    // Custom
    address addressToConsult;
    uint256 public PRICE_PRECISION = 1e18;

    // AggregatorV3Interface stuff
    uint8 public decimals = 18;
    string public description;
    uint256 public version = 1;

    /* ========== CONSTRUCTOR ========== */

    constructor (
        address _pairAddr, 
        address _timelock,
        string memory _description,
        address _addressToConsult
    ) {
        IUniswapV2Pair _pair = IUniswapV2Pair(_pairAddr);
        token0 = _pair.token0();
        token1 = _pair.token1();
        price0CumulativeLast = _pair.price0CumulativeLast(); // Fetch the current accumulated price value (1 / 0)
        price1CumulativeLast = _pair.price1CumulativeLast(); // Fetch the current accumulated price value (0 / 1)
        uint112 reserve0;
        uint112 reserve1;
        (reserve0, reserve1, blockTimestampLast) = _pair.getReserves();
        require(reserve0 != 0 && reserve1 != 0, Errors.UO_NO_RESERVES); // Ensure that there's liquidity in the pair

        timelock = _timelock;

        pair = _pair;
        description = _description;
        addressToConsult = _addressToConsult;
    }

    /* ========== MODIFIERS ========== */

    modifier onlyByOwnGov() {
        require(msg.sender == owner() || msg.sender == timelock, Errors.UO_NO_AUTH);
        _;
    }

    /* ========== VIEWS ========== */

    // Note this will always return 0 before update has been called successfully for the first time.
    function consult(address token, uint amountIn) public view returns (uint amountOut) {
        uint32 blockTimestamp = UniswapV2OracleLibrary.currentBlockTimestamp();
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // Overflow is desired

        // Ensure that the price is not stale
        require((timeElapsed < (PERIOD + CONSULT_LENIENCY)) || ALLOW_STALE_CONSULTS, Errors.UO_PRICE_NEED_UPDATE);

        if (token == token0) {
            amountOut = price0Average.mul(amountIn).decode144();
        } else {
            require(token == token1, Errors.UO_INVALID_TOKEN);
            amountOut = price1Average.mul(amountIn).decode144();
        }
    }

    // AggregatorV3Interface stuff
    function getRoundData(uint80 _roundId) external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        // Returns nothing
    }

    function latestRoundData() external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        int256 result = int256(consult(addressToConsult, PRICE_PRECISION));
        return (0, result, 0, 0, 0);
    }

    /* ========== PUBLIC FUNCTIONS ========== */

    // Check if update() can be called instead of wasting gas calling it
    function canUpdate() public view returns (bool) {
        uint32 blockTimestamp = UniswapV2OracleLibrary.currentBlockTimestamp();
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // Overflow is desired
        return (timeElapsed >= PERIOD);
    }

    function update() external {
        (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =
            UniswapV2OracleLibrary.currentCumulativePrices(address(pair));
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // Overflow is desired

        // Ensure that at least one full period has passed since the last update
        require(timeElapsed >= PERIOD,  Errors.UO_PERIOD_NOT_ELAPSED);

        // Overflow is desired, casting never truncates
        // Cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
        price0Average = FixedPoint.uq112x112(uint224((price0Cumulative - price0CumulativeLast) / timeElapsed));
        price1Average = FixedPoint.uq112x112(uint224((price1Cumulative - price1CumulativeLast) / timeElapsed));

        price0CumulativeLast = price0Cumulative;
        price1CumulativeLast = price1Cumulative;
        blockTimestampLast = blockTimestamp;
    }

    /* ========== RESTRICTED GOVERNANCE FUNCTIONS ========== */

    function setTimelock(address _timelock) external onlyByOwnGov {
        timelock = _timelock;
    }

    function setPeriod(uint _period) external onlyByOwnGov {
        PERIOD = _period;
    }

    function setConsultLeniency(uint _consultLeniency) external onlyByOwnGov {
        CONSULT_LENIENCY = _consultLeniency;
    }

    function setAllowStaleConsults(bool _allowStaleConsults) external onlyByOwnGov {
        ALLOW_STALE_CONSULTS = _allowStaleConsults;
    }

    function setAddressToConsult(address _addressToConsult) external onlyByOwnGov {
        addressToConsult = _addressToConsult;
    }
}
