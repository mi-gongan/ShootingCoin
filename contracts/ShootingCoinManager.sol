// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./ShootingRole.sol";
import "./libs/GameCore.sol";
import "./libs/CurrencyController.sol";

import "./interface/IShootingRole.sol";
import "./interface/IStaking.sol";
import "./interface/IShootingGame.sol";

contract ShootingCoinManager is
    Initializable,
    GameCore,
    CurrencyController,
    IShootingGame
{
    event Entered(address user, uint256 gameId);

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

    function enterGame(BetInfo memory userBetInfo, uint256 gameId) public {
        require(userBetInfo.userAccount == msg.sender, "wrong user");
        if (IShootingRole(shootingRole).isRelayer(userBetInfo.userAccount))
            revert("relayer can't play");
        if (isOnGame[userBetInfo.userAccount] != 0) revert("user is on game");

        // require(
        //     IStaking(shootingNft).isStake(userBetInfo.userAccount, gameId),
        //     "not stake"
        // );

        despositCoin(userBetInfo.coin1.coinAddress, userBetInfo.coin1.amount);
        despositCoin(userBetInfo.coin2.coinAddress, userBetInfo.coin2.amount);
        despositCoin(userBetInfo.coin3.coinAddress, userBetInfo.coin3.amount);
        despositCoin(userBetInfo.coin4.coinAddress, userBetInfo.coin4.amount);
        despositCoin(userBetInfo.coin5.coinAddress, userBetInfo.coin5.amount);

        userBettingCoinBalance[userBetInfo.userAccount][
            userBetInfo.coin1.coinAddress
        ] += userBetInfo.coin1.amount;
        userBettingCoinBalance[userBetInfo.userAccount][
            userBetInfo.coin2.coinAddress
        ] += userBetInfo.coin2.amount;
        userBettingCoinBalance[userBetInfo.userAccount][
            userBetInfo.coin3.coinAddress
        ] += userBetInfo.coin3.amount;
        userBettingCoinBalance[userBetInfo.userAccount][
            userBetInfo.coin4.coinAddress
        ] += userBetInfo.coin4.amount;
        userBettingCoinBalance[userBetInfo.userAccount][
            userBetInfo.coin5.coinAddress
        ] += userBetInfo.coin5.amount;

        _enterGame(userBetInfo.userAccount, gameId);
        emit Entered(userBetInfo.userAccount, gameId);
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

    function settleGame(
        uint256 gameId,
        uint8 user1GetCoinId,
        uint8 user2GetCoinId
    ) public payable onlyRelayer {
        BetInfo memory user1BetInfo = gameInfo[gameId].user1BetInfo;
        BetInfo memory user2BetInfo = gameInfo[gameId].user2BetInfo;

        // user2가 user1에게 줄 코인들
        if (user1GetCoinId & 1 == 1) {
            userBettingCoinBalance[user1BetInfo.userAccount][
                user2BetInfo.coin1.coinAddress
            ] += user2BetInfo.coin1.amount;
        }
        if (user1GetCoinId & 2 == 2) {
            userBettingCoinBalance[user1BetInfo.userAccount][
                user2BetInfo.coin2.coinAddress
            ] += user2BetInfo.coin2.amount;
        }
        if (user1GetCoinId & 4 == 4) {
            userBettingCoinBalance[user1BetInfo.userAccount][
                user2BetInfo.coin3.coinAddress
            ] += user2BetInfo.coin3.amount;
        }
        if (user1GetCoinId & 8 == 8) {
            userBettingCoinBalance[user1BetInfo.userAccount][
                user2BetInfo.coin4.coinAddress
            ] += user2BetInfo.coin4.amount;
        }
        if (user1GetCoinId & 16 == 16) {
            userBettingCoinBalance[user1BetInfo.userAccount][
                user2BetInfo.coin5.coinAddress
            ] += user2BetInfo.coin5.amount;
        }

        // user1이 user2에게 줄 코인들
        if (user2GetCoinId & 1 == 1) {
            userBettingCoinBalance[user2BetInfo.userAccount][
                user1BetInfo.coin1.coinAddress
            ] += user1BetInfo.coin1.amount;
        }
        if (user2GetCoinId & 2 == 2) {
            userBettingCoinBalance[user2BetInfo.userAccount][
                user1BetInfo.coin2.coinAddress
            ] += user1BetInfo.coin2.amount;
        }
        if (user2GetCoinId & 4 == 4) {
            userBettingCoinBalance[user2BetInfo.userAccount][
                user1BetInfo.coin3.coinAddress
            ] += user1BetInfo.coin3.amount;
        }
        if (user2GetCoinId & 8 == 8) {
            userBettingCoinBalance[user2BetInfo.userAccount][
                user1BetInfo.coin4.coinAddress
            ] += user1BetInfo.coin4.amount;
        }
        if (user2GetCoinId & 16 == 16) {
            userBettingCoinBalance[user2BetInfo.userAccount][
                user1BetInfo.coin5.coinAddress
            ] += user1BetInfo.coin5.amount;
        }

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

    function getGameInfo(uint256 gameId) public view returns (GameInfo memory) {
        return gameInfo[gameId];
    }

    function getHistory(address userAccount)
        public
        view
        returns (GameHistory[] memory)
    {
        return gameHistory[userAccount];
    }

    function checkOnGame(address userAccount) public view returns (uint256) {
        return isOnGame[userAccount];
    }
}
