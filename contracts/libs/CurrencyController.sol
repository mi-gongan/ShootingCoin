// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CurrencyController {
    address constant ETH_ADDRESS = address(0);
    //user betting coin balance, user address => coin address => amount
    mapping(address => mapping(address => uint256))
        public userBettingCoinBalance;

    function despositCoin(address coinAddress, uint256 amount) public payable {
        if (coinAddress == ETH_ADDRESS) {
            require(msg.value == amount, "wrong amount");
        } else {
            IERC20(coinAddress).transferFrom(msg.sender, address(this), amount);
        }
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
}
