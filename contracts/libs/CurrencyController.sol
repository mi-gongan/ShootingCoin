// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CurrencyController {
    address constant ETH_ADDRESS = address(0);
    uint256 gameFeePercent;
    mapping(address => bool) public whitelist;

    function despositCoin(address coinAddress, uint256 amount) public payable {
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

    uint256[47] private __gap;
}
