// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./ShootingRole.sol";
import "./libs/GameCore.sol";
import "./libs/CurrencyController.sol";

import "./interface/IShootingRole.sol";
import "./interface/IShootingNFT.sol";

contract ShootingCoinManager is Initializable, GameCore, CurrencyController {
    event Entered(address user, BetInfo betInfo);

    event GameInited(
        uint256 gameId,
        address user1,
        address user2,
        GameInfo gameInfo
    );

    event GameSettled(
        uint256 gameId,
        address user1,
        address user2,
        GameHistory gameHistory
    );

    function initialize(address roleContract) public initializer {
        shootingRole = roleContract;
    }

    function enterGame(address account, BetInfo memory _betInfo) public {
        require(account == msg.sender, "wrong user");
        if (IShootingRole(shootingRole).isRelayer(account))
            revert("relayer can't play");
        if (isOnGame[account] == 1) revert("user is on game");

        IShootingNFT(shootingNft).stake(_betInfo.nftSkinId);

        despositCoin(_betInfo.coinAddress, _betInfo.betAmount);

        _enterGame(account, _betInfo);
        emit Entered(account, _betInfo);
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
            user2,
            user1BetInfo,
            user1GetAmount,
            user2BetInfo,
            user2GetAmount,
            uint240(block.timestamp)
        );

        ditstributeCoin(user1, user2BetInfo.coinAddress, user1GetAmount);
        ditstributeCoin(user2, user1BetInfo.coinAddress, user2GetAmount);

        gameHistory[user1].push(_gameHistory);
        gameHistory[user2].push(_gameHistory);

        IShootingNFT(shootingNft).unStake(user1BetInfo.nftSkinId);
        IShootingNFT(shootingNft).unStake(user2BetInfo.nftSkinId);

        _endGame(user1);
        _endGame(user2);

        emit GameSettled(gameId, user1, user2, _gameHistory);
    }

    function getGameInfo(uint256 gameId) public view returns (GameInfo memory) {
        return gameInfo[gameId];
    }

    function getBetInfo(address userAccount)
        public
        view
        returns (BetInfo memory)
    {
        return betInfo[userAccount];
    }

    function getHistory(address userAccount)
        public
        view
        returns (GameHistory[] memory)
    {
        return gameHistory[userAccount];
    }

    function checkOnGame(address account) public view returns (bool) {
        return isOnGame[account] == 1;
    }
}
