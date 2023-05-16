// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interface/IShootingRole.sol";

contract GameCore {
    address public shootingRole;
    address public shootingNft;
    address public feeRecieveAddress;
    mapping(address => uint256) public isOnGame;
    //user on game, user address => bet info
    mapping(address => BetInfo) public betInfo;

    //game info
    mapping(uint256 => GameInfo) public gameInfo;
    //game history
    mapping(address => GameHistory[]) public gameHistory;
    //coin whitelist
    mapping(address => bool) public whitelist;

    mapping(uint256 => uint256) public usedSalt;

    struct BetInfo {
        address coinAddress;
        uint256 betAmount;
        uint256[5] nftSkinId;
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
        address user1coinAddress;
        uint256 user1GetAmount;
        address user2;
        address user2coinAddress;
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

    function updateWhiteList(
        address coinAddress,
        bool isWhite
    ) public onlyAdmin {
        whitelist[coinAddress] = isWhite;
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

    uint256[41] private __gap;
}
