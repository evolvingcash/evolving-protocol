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
}
