// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";

import "./ShootingRole.sol";
import "./libs/GameCore.sol";
import "./libs/CurrencyController.sol";

import "./interface/IShootingRole.sol";
import "./interface/IShootingNFT.sol";

contract ShootingCoinManager is Initializable, GameCore, CurrencyController {
    event Entered(address user, BetInfo betInfo, uint256 salt);

    event Quited(address user, BetInfo betInfo, uint256 salt);

    event GameInited(
        uint256 indexed gameId,
        address indexed user1,
        address indexed user2,
        GameInfo gameInfo
    );

    event GameSettled(
        uint256 indexed gameId,
        address indexed user1,
        address indexed user2,
        GameHistory gameHistory
    );

    function initialize(
        address roleContract,
        uint256 _gameFee,
        address _feeRecieveAddress
    ) public initializer {
        shootingRole = roleContract;
        gameFeePercent = _gameFee;
        feeRecieveAddress = _feeRecieveAddress;
    }

    function enterGame(
        address account,
        BetInfo memory _betInfo,
        uint256 salt
    ) public {
        require(usedSalt[salt] == 0, "salt used");
        require(account == msg.sender, "wrong user");
        if (IShootingRole(shootingRole).isRelayer(account))
            revert("relayer can't play");
        if (isOnGame[account] == 1) revert("user is on game");

        for (uint256 i = 0; i < _betInfo.nftSkinId.length; i++) {
            if (_betInfo.nftSkinId[i] != 0) {
                require(
                    IERC721Upgradeable(shootingNft).ownerOf(
                        _betInfo.nftSkinId[i]
                    ) == account,
                    "not owner"
                );
            }
        }

        despositCoin(_betInfo.coinAddress, _betInfo.betAmount);

        _enterGame(account, _betInfo);

        usedSalt[salt] = 1;
        emit Entered(account, _betInfo, salt);
    }

    function quitGame(address account, uint256 salt) public {
        require(usedSalt[salt] == 1, "not used salt");
        require(account == msg.sender, "wrong user");
        if (isOnGame[account] == 0) revert("user is not on game");

        BetInfo memory _betInfo = betInfo[account];

        ditstributeCoin(account, _betInfo.coinAddress, _betInfo.betAmount);
        emit Quited(account, _betInfo, salt);
    }

    function startGame(
        uint256 gameId,
        address user1,
        address user2
    ) public onlyRelayer {
        GameInfo memory _gameInfo = GameInfo(
            user1,
            user2,
            betInfo[user1],
            betInfo[user2]
        );
        gameInfo[gameId] = _gameInfo;

        emit GameInited(gameId, user1, user2, _gameInfo);
    }

    function settleGame(
        uint256 gameId,
        address user1,
        address user2,
        uint256 user1GetAmount,
        uint256 user2GetAmount
    ) public payable onlyRelayer {
        BetInfo memory user1BetInfo = gameInfo[gameId].user1BetInfo;
        BetInfo memory user2BetInfo = gameInfo[gameId].user2BetInfo;

        GameHistory memory _gameHistory = GameHistory(
            gameId,
            user1,
            user1BetInfo.coinAddress,
            user1GetAmount,
            user2,
            user2BetInfo.coinAddress,
            user2GetAmount,
            uint240(block.timestamp)
        );

        uint256 user1Share = user1GetAmount -
            (user1GetAmount * gameFeePercent) /
            100;
        uint256 user2Share = user2GetAmount -
            (user2GetAmount * gameFeePercent) /
            100;

        ditstributeCoin(
            feeRecieveAddress,
            user2BetInfo.coinAddress,
            user1GetAmount - user1Share
        );
        ditstributeCoin(
            feeRecieveAddress,
            user1BetInfo.coinAddress,
            user2GetAmount - user2Share
        );

        ditstributeCoin(user1, user2BetInfo.coinAddress, user1Share);
        ditstributeCoin(user2, user1BetInfo.coinAddress, user2Share);

        gameHistory[user1].push(_gameHistory);
        gameHistory[user2].push(_gameHistory);

        _endGame(user1);
        _endGame(user2);

        emit GameSettled(gameId, user1, user2, _gameHistory);
    }

    function getGameInfo(uint256 gameId) public view returns (GameInfo memory) {
        return gameInfo[gameId];
    }

    function getBetInfo(
        address userAccount
    ) public view returns (BetInfo memory) {
        return betInfo[userAccount];
    }

    function getHistory(
        address userAccount
    ) public view returns (GameHistory[] memory) {
        return gameHistory[userAccount];
    }

    function checkOnGame(address account) public view returns (bool) {
        return isOnGame[account] == 1;
    }

    function updateWhiteList(
        address coinAddress,
        bool isWhite
    ) public onlyAdmin {
        whitelist[coinAddress] = isWhite;
    }

    receive() external payable {}

    uint256[50] private __gap;
}
