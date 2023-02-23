// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interface/IShootingRole.sol";

contract GameCore {
    address public shootingRole;
    address public shootingNft;
    mapping(address => uint256) public isOnGame;
    //user on game, user address => bet info
    mapping(address => BetInfo) public betInfo;

    //game info
    mapping(uint256 => GameInfo) public gameInfo;
    //game history
    mapping(address => GameHistory[]) public gameHistory;
    //coin whitelist
    mapping(address => bool) public whitelist;

    struct BetInfo {
        address coinAddress;
        uint256 betAmount;
        uint256 nftSkinId;
    }

    struct GameInfo {
        address user1;
        address user2;
        BetInfo user1BetInfo;
        BetInfo user2BetInfo;
    }

    struct GameHistory {
        uint256 gameId;
        address user1;
        address user2;
        BetInfo user1BetInfo;
        uint256 user1GetAmount;
        BetInfo user2BetInfo;
        uint256 user2GetAmount;
        uint240 timeStamp;
    }

    modifier onlyRelayer() {
        require(
            IShootingRole(shootingRole).isRelayer(msg.sender),
            "ShootingRole: only relayer"
        );
        _;
    }

    modifier onlyAdmin() {
        require(
            IShootingRole(shootingRole).isAdmin(msg.sender),
            "ShootingRole: only admin"
        );
        _;
    }

    function updateShootingRole(address roleContract) public onlyAdmin {
        shootingRole = roleContract;
    }

    function updateShootingNft(address nftContract) public onlyAdmin {
        shootingNft = nftContract;
    }

    function getShootingRole() public view returns (address) {
        return shootingRole;
    }

    function getShootingNft() public view returns (address) {
        return shootingNft;
    }

    function _enterGame(address userAccount, BetInfo memory _betInfo) internal {
        betInfo[userAccount] = _betInfo;
        isOnGame[userAccount] = 1;
    }

    function _endGame(address userAccount) internal {
        delete betInfo[userAccount];
        isOnGame[userAccount] = 0;
    }
}
