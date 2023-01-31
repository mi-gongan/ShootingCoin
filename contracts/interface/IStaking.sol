// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IStaking {
    function isStake(address user, uint256 tokenId)
        external
        view
        returns (bool);
}
