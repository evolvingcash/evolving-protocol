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
    function __Registry_init() private {
    }

    /// @dev initialize upgradeable USDEStableCoin contract
    function initialize() public payable initializer {
        // "constructor" code...
        __ReentrancyGuard_init();
        __Ownable_init();
        __EIP712_init("evolving.cash", "0x01");
        __UUPSUpgradeable_init();

        __Registry_init();
    }

    function registerUSDE(address _usde) public onlyOwner {
        usde = _usde;
    }

    function registerEVOL(address _evol) public onlyOwner {
        evol = _evol;
    }
}