// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./RegistryStorage.sol";
import "../interfaces/IRegistry.sol";
import "../libraries/Errors.sol";

/**
 * @title evolving address Registry
 * @dev module instance address registry
 * @author evolving-protocol
 */
contract Registry is Initializable,
                    OwnableUpgradeable,
                    UUPSUpgradeable,
                    ReentrancyGuardUpgradeable,
                    EIP712Upgradeable,
                    IRegistry,
                    RegistryStorage {
    using SafeMath for uint256;
    // using EnumerableSet for EnumerableSet.AddressSet;

    /* ========== INITIALIZE ========== */

    /// @dev _authorizeUpgrade authorize upgrade role
    function _authorizeUpgrade(address newImplementation) internal view override {
        newImplementation;
        require(msg.sender == owner(), Errors.NO_AUTH);
    }

    /// @dev __Registry_init init
    function __Registry_init(address _weth) private {
        weth = _weth;
    }

    /// @dev initialize upgradeable USDEStableCoin contract
    function initialize(address _weth) public payable initializer {
        // "constructor" code...
        __ReentrancyGuard_init();
        __Ownable_init();
        __EIP712_init("evolving.cash", "0x01");
        __UUPSUpgradeable_init();

        __Registry_init(_weth);
    }

    /* ========== PUBLIC FUNCTIONS ========== */

    function getUSDEToken() external override view returns (address usdeToken) {
        usdeToken = _usdeToken;
    }

    function getEVOLToken() external override view returns (address evolToken) {
        evolToken = _evolToken;
    }

    function getTreasury() external override view returns (address) {
        return _treasury;
    }
    
    function getETHOracle() external override view returns (AggregatorV3Interface) {
        return _ethOracle;
    }

    /// @dev getUSDEUniswapV2Oracle get Uniswap pair USDE/ETH address
    function getUSDEUniswapV2Oracle() external override view returns (IUniswapV2PairOracle) {
        return _usdePairOracle;
    }

    /// @dev getEVOLUniswapV2Oracle get Uniswap pair EVOL/ETH address
    function getEVOLUniswapV2Oracle() external override view returns (IUniswapV2PairOracle) {
        return _evolPairOracle;
    }

    function getWETH() external override view returns (address) {
        return weth;
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

    function registerUSDE(address _usde) public onlyOwner {
        _usdeToken = _usde;
    }

    function registerEVOL(address _evol) public onlyOwner {
        _evolToken = _evol;
    }

    function registerTreasury(address _addr) public onlyOwner {
        _treasury = _addr;
    }

    function registerETHOracle(address _addr) public onlyOwner {
        _ethOracle = AggregatorV3Interface(_addr);
    }

    function registerUSDEOracle(address _addr) public onlyOwner {
        _usdePairOracle = IUniswapV2PairOracle(_addr);
    }

    function registerEVOLOracle(address _addr) public onlyOwner {
        _evolPairOracle = IUniswapV2PairOracle(_addr);
    }

    function registerChainlinkOracle(address _token, address _oracle) public onlyOwner {
        _chainlinkOracles[_token] = AggregatorV3Interface(_oracle);
    }
}
