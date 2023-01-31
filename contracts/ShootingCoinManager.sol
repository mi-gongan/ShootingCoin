// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ShootingRole.sol";
import "./libs/GameCore.sol";
import "./libs/CurrencyController.sol";

import "./interface/IShootingRole.sol";
import "./interface/IShootingGame.sol";

contract ShootingCoinManager is GameCore, CurrencyController, IShootingGame {
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

    constructor(address roleContract) {
        shootingRole = roleContract;
    }

    function EnterGame(BetInfo memory userBetInfo, uint256 gameId) public {
        require(userBetInfo.userAccount == msg.sender, "wrong user");
        if (IShootingRole(shootingRole).isRelayer(userBetInfo.userAccount))
            revert("relayer can't play");
        if (isOnGame[userBetInfo.userAccount] != 0) revert("user is on game");

        //TODO: 사용한 nft가 스테이킹 되어있는지 체크하는 로직 필요
        //TODO: stat 맞는지 체크하는 로직 필요

        //TODO: betting info에 따라 contract에 transferFrom 해야함
        //TODO: transfer 완료되면 userBettingCoinBalance에 추가해야함

        _enterGame(userBetInfo.userAccount, gameId);
    }

    function startGame(
        uint256 gameId,
        address user1,
        address user2,
        BetInfo memory user1BetInfo,
        BetInfo memory user2BetInfo
    ) public onlyRelayer {
        require(isOnGame[user1] == gameId, "not match game");
        require(isOnGame[user2] == gameId, "not match game");

        GameInfo memory _gameInfo = GameInfo(user1BetInfo, user2BetInfo);
        gameInfo[gameId] = _gameInfo;

        emit GameInited(gameId, user1, user2, _gameInfo);
    }

    function stopGame() public onlyRelayer {
        // TODO: 중간에 정산하는 로직 필요
    }

    function settleGame(
        uint256 gameId,
        uint8 user1GetCoinId,
        uint8 user2GetCoinId
    ) public payable {
        BetInfo memory user1BetInfo = gameInfo[gameId].user1BetInfo;
        BetInfo memory user2BetInfo = gameInfo[gameId].user2BetInfo;

        // user get coin id에서 획득한 코인 id들 추출
        // game info에서 user1, user2의 코인에 걸린 돈들 추출
        // 각각 얻은 돈들 총 합산해서 settle 해주기

        GameHistory memory _gameHistory = GameHistory(
            gameId,
            user1GetCoinId,
            user2GetCoinId,
            uint240(block.timestamp)
        );

        gameHistory[user1BetInfo.userAccount].push(_gameHistory);
        gameHistory[user2BetInfo.userAccount].push(_gameHistory);

        _endGame(user1BetInfo.userAccount);
        _endGame(user2BetInfo.userAccount);

        emit GameSettled(
            gameId,
            user1BetInfo.userAccount,
            user2BetInfo.userAccount,
            _gameHistory
        );
    }

    function checkOnGame(address userAccount) public view returns (uint256) {
        return isOnGame[userAccount];
    }
}
