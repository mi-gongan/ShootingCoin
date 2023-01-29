// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IShootingRole {
    function addRelayer(address account) external;

    function removeRelayer(address account) external;

    function isRelayer(address account) external returns (bool);

    function isAdmin(address account) external returns (bool);
}
