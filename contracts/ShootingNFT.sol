// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./interface/IShootingRole.sol";

contract ShootingNFT is ERC721EnumerableUpgradeable {
    using ECDSA for bytes32;

    uint8 constant DEPENSE = 0;

    string public baseURI;
    address public shootingRole;
    address public shootingManager;

    mapping(uint256 => StatsInfo) private nftStats;

    struct StatsInfo {
        // 0: defense, 1: attack
        uint8 statType;
        uint88 value;
    }

    modifier onlyAdmin() {
        require(
            IShootingRole(shootingRole).isAdmin(msg.sender),
            "ShootingRole: only amdin"
        );
        _;
    }

    modifier onlyRelayer() {
        require(
            IShootingRole(shootingRole).isRelayer(msg.sender),
            "ShootingRole: only relayer"
        );
        _;
    }

    modifier onlyManager() {
        require(msg.sender == shootingManager, "ShootingRole: only manager");
        _;
    }

    function initialize(
        address roleContract,
        address managerContract
    ) public initializer {
        shootingRole = roleContract;
        shootingManager = managerContract;
    }

    function mint(
        address to,
        uint256 tokenId,
        uint8 statType,
        uint88 value
    ) public onlyAdmin {
        _mint(to, tokenId);
        nftStats[tokenId].statType = statType;
        nftStats[tokenId].value = value;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory afterBaseURI) public onlyAdmin {
        baseURI = afterBaseURI;
    }

    function getStat(uint256 tokenId) public view returns (uint8, uint88) {
        return (nftStats[tokenId].statType, nftStats[tokenId].value);
    }

    function getShootingRole() public view returns (address) {
        return shootingRole;
    }

    function getShootingManger() public view returns (address) {
        return shootingManager;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        super._beforeTokenTransfer(from, to, tokenId, 0);
    }

    uint256[45] private __gap;
}
