// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IShootingGame {
    function checkOnGame(address userAccount) external view returns (uint256);
}
