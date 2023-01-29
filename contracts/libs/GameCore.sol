// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract GameCore {
    //user on game, user address => game id
    mapping(address => uint256) public isOnGame;

    //game info
    mapping(uint256 => GameInfo) public gameInfo;
    //game history
    mapping(address => GameHistory[]) public gameHistory;
    //coin whitelist
    mapping(address => bool) public whitelist;

    struct BetInfo {
        address userAccount;
        CoinInfo coin1;
        CoinInfo coin2;
        CoinInfo coin3;
        CoinInfo coin4;
        CoinInfo coin5;
    }

    struct CoinInfo {
        address coinAddress;
        uint256 amount;
        //if not, 0
        uint256 statId;
    }

    struct GameInfo {
        BetInfo user1BetInfo;
        BetInfo user2BetInfo;
    }

    struct GameHistory {
        uint256 gameId;
        // digit 1: coin1, digit 2: coin2, digit 3: coin3, digit 4: coin4, digit 5: coin5
        // if 1, win, if 0, lose
        uint8 user1GetCoinId;
        uint8 user2GetCoinId;
        uint240 timeStamp;
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

    function _enterGame(address userAccount, uint256 gameId) internal {
        isOnGame[userAccount] = gameId;
    }

    function _endGame(address userAccount) internal {
        isOnGame[userAccount] = 0;
    }
}
