// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ShootingRole is Initializable, AccessControlUpgradeable {
    bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");

    function initialize() public initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    modifier onlyAdmin() {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "ShootingRole: only admin"
        );
        _;
    }

    modifier onlyRelayer() {
        require(
            hasRole(RELAYER_ROLE, msg.sender),
            "ShootingRole: only relayer"
        );
        _;
    }

    function addRelayer(address account) public onlyAdmin {
        grantRole(RELAYER_ROLE, account);
    }

    function removeRelayer(address account) public onlyAdmin {
        revokeRole(RELAYER_ROLE, account);
    }

    function isRelayer(address account) public view returns (bool) {
        return hasRole(RELAYER_ROLE, account);
    }

    function isAdmin(address account) public view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, account);
    }
}
