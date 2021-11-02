// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./USDEStorage.sol";
import "../interfaces/IUSDEStableCoin.sol";
import "../libraries/Errors.sol";

/**
 * @title evolving USDE StableCoin ERC20 token
 * @dev Implementation of the USDE StableCoin ERC20 token for the evolving protocol
 * @author evolving-protocol
 */
contract USDEStableCoin is Initializable,
                            AccessControlEnumerableUpgradeable,
                            UUPSUpgradeable,
                            ReentrancyGuardUpgradeable,
                            ERC20Upgradeable,
                            EIP712Upgradeable,
                            IUSDEStableCoin,
                            USDEStorage {
    using SafeMath for uint256;
    // using EnumerableSet for EnumerableSet.AddressSet;

    /* ========== INITIALIZE ========== */

    /// @dev _authorizeUpgrade authorize upgrade role
    function _authorizeUpgrade(address newImplementation) internal view override {
        newImplementation;
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), Errors.NO_AUTH);
    }

    /// @dev __USDEStablecoin_init init
    function __USDEStablecoin_init() private {
        ratioStep = 2500; // 6 decimals of precision, equal to 0.25%
        collateralRatio = 1000000; // system starts off fully collateralized (6 decimals of precision)
        refreshCooldown = 3600; // Refresh cooldown period is set to 1 hour (3600 seconds) at genesis
        priceAnchor = 1000000; // Collateral ratio will adjust according to the $1 price target at genesis
        priceBand   =    5000; // [0.995-1.005]

        stage1Supply = 3000000e18;  // 3M, when reach this supply, we allow mint USDE by ETH BTC etc
        stage2Supply = 10000000e18; // 10M, when reach this supply, we allow mint USDE by EVOL
    }

    /// @dev initialize upgradeable USDEStableCoin contract
    function initialize() public payable initializer {
        // "constructor" code...
        __ReentrancyGuard_init();
        __AccessControlEnumerable_init();
        __ERC20_init("USDE", "USDE");
        __EIP712_init("evolving.cash", "0x01");
        __UUPSUpgradeable_init();

        __USDEStablecoin_init();
    }

    /* ========== MODIFIERS ========== */

    /// @dev auth mintable pool
    modifier onlyPools() {
       require(hasRole(MINTABLE_POOL_ROLE, msg.sender), Errors.NO_AUTH);
        _;
    }

    /// @dev auth mintable pool
    modifier onlyOwnerOrGovernor() {
       require(hasRole(OWNER_OR_GOVERN_ROLE, msg.sender), Errors.NO_AUTH);
        _;
    }

    /* ========== PUBLIC FUNCTIONS ========== */
    
    // There needs to be a time interval that this can be called. Otherwise it can be called multiple times per expansion.
    function refreshCollateralRatio() public {
        require(collateralRatioPaused == false, Errors.US_Collateral_Paused);

        _refreshCollateralRatio();
    }

    function _refreshCollateralRatio() private {
        if (block.timestamp < lastRefreshTime + refreshCooldown) {
            return;
        }

        uint256 usdePrice = frax_price();
        // Step increments are 0.25% (upon genesis, changable by setRatioStep()) 
        if (usdePrice > priceAnchor.add(priceBand)) { //decrease collateral ratio
            if(collateralRatio <= ratioStep){ //if within a step of 0, go to 0
                collateralRatio = 0;
            } else {
                collateralRatio = collateralRatio.sub(ratioStep);
            }
        } else if (usdePrice < priceAnchor.sub(priceBand)) { //increase collateral ratio
            if (collateralRatio.add(ratioStep) >= 1000000) {
                collateralRatio = 1000000; // cap collateral ratio at 1.000000
            } else {
                collateralRatio = collateralRatio.add(ratioStep);
            }
        }

        // solhint-disable-next-line
        lastRefreshTime = block.timestamp; // Set the time of the last expansion

        emit CollateralRatioRefreshed(collateralRatio);
    }

    /// @dev burn this can only burn msg.sender's token, so it's ok
    /// @param amount amount to burn
    function burn(uint256 amount) public {
        super._burn(msg.sender, amount);
        
        _refreshCollateralRatio();
        emit USDEBurned(msg.sender, amount);
    }
    
    /* ========== RESTRICTED FUNCTIONS ========== */

    /// @notice poolMint mint USDE
    /// @param to account to recv USDE token
    /// @param amount amount
    function poolMint(address to, uint256 amount) public onlyPools {
        super._mint(to, amount);

        _refreshCollateralRatio();
        emit USDEMinted(msg.sender, to, amount);
    }

    /// @dev setCollateralRatio set collateralRatio
    /// @param ratio new collateralRatio
    function setCollateralRatio(uint256 ratio) external onlyOwnerOrGovernor {
        collateralRatio = ratio;

        emit CollateralRatioSet(ratio);
    }

    /// @dev setPriceBand set priceBand
    /// @param _band new priceBand
    function setPriceBand(uint256 _band) external onlyOwnerOrGovernor {
        priceBand = _band;

        emit PriceBandSet(_band);
    }

    /// @dev setRefreshCooldown set refreshCooldown
    /// @param seconds new refreshCooldown seconds
    function setRefreshCooldown(uint256 _seconds) external onlyOwnerOrGovernor {
        refreshCooldown = _seconds;

        emit RefreshCooldownSet(_seconds);
    }
    
    /// @dev setPriceAnchor set priceAnchor
    /// @param price new priceAnchor
    function setPriceAnchor(uint256 price) external onlyOwnerOrGovernor {
        priceAnchor = price;

        emit PriceAnchorSet(price);
    }

    /// @dev setRatioStep set ratioStep
    /// @param step new ratioStep
    function setRatioStep(uint256 step) external onlyOwnerOrGovernor {
        ratioStep = step;

        emit RatioStepSet(step);
    }

    /// @dev setCollateralRatioPaused set collateralRatioPaused
    /// @param v new value
    function setCollateralRatioPaused(bool v) external onlyOwnerOrGovernor {
        collateralRatioPaused = v;
    }
}
