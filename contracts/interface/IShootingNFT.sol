// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IShootingNFT {
    function stake(uint256 tokenId) external;

    function unStake(uint256 tokenId) external;
}
