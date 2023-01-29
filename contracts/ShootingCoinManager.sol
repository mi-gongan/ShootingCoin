// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ShootingRole.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ShootingCoinManager is ShootingRole {
    address constant ETH_ADDRESS = address(0);

    //user on game, user address => game id
    mapping(address => uint256) public isOnGame;
    //user betting coin balance, user address => coin address => amount
    mapping(address => mapping(address => uint256))
        public userBettingCoinBalance;
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

    function EnterGame(BetInfo memory userBetInfo, uint256 gameId) public {
        require(userBetInfo.userAccount == msg.sender, "wrong user");
        if (isRelayer(userBetInfo.userAccount)) revert("relayer can't play");
        if (isOnGame[userBetInfo.userAccount] != 0) revert("user is on game");

        //TODO: 사용한 nft가 스테이킹 되어있는지 체크하는 로직 필요
        //TODO: stat 맞는지 체크하는 로직 필요

        //TODO: betting info에 따라 contract에 transferFrom 해야함
        //TODO: transfer 완료되면 userBettingCoinBalance에 추가해야함

        enterGame(userBetInfo.userAccount, gameId);
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

        endGame(user1BetInfo.userAccount);
        endGame(user2BetInfo.userAccount);

        emit GameSettled(
            gameId,
            user1BetInfo.userAccount,
            user2BetInfo.userAccount,
            _gameHistory
        );
    }

    function withdrawCoin(address coinAddress, uint256 amount) public {
        //게임 중인지 체크, 끝났다면 자기 돈은 자기만 인출 가능
        require(
            userBettingCoinBalance[msg.sender][coinAddress] >= amount,
            "not enough coin"
        );

        userBettingCoinBalance[msg.sender][coinAddress] -= amount;
        ditstributeCoin(msg.sender, coinAddress, amount);
    }

    function depositCoin(address coinAddress, uint256 amount) public payable {
        if (coinAddress == ETH_ADDRESS) {
            require(msg.value == amount, "wrong amount");
        } else {
            IERC20(coinAddress).transferFrom(msg.sender, address(this), amount);
        }
    }

    function ditstributeCoin(
        address userAccount,
        address coinAddress,
        uint256 amount
    ) internal {
        if (coinAddress == ETH_ADDRESS) {
            payable(userAccount).transfer(amount);
        } else {
            IERC20(coinAddress).transfer(userAccount, amount);
        }
    }

    function enterGame(address userAccount, uint256 gameId) public {
        isOnGame[userAccount] = gameId;
    }

    function endGame(address userAccount) public {
        isOnGame[userAccount] = 0;
    }
}
