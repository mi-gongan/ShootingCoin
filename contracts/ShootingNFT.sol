// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./interface/IShootingRole.sol";
import "./interface/IShootingGame.sol";
import "./interface/IStaking.sol";

contract ShootingNFT is ERC721EnumerableUpgradeable, IStaking {
    using ECDSA for bytes32;

    uint8 constant DEPENSE = 0;

    string public baseURI;
    address public shootingRole;
    address public shootingManager;

    mapping(address => uint256[]) private stakedNFT;
    mapping(uint256 => StatsInfo) private nftStats;

    struct StatsInfo {
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

    function initialize(address roleContract, address managerContract)
        public
        initializer
    {
        shootingRole = roleContract;
        shootingManager = managerContract;
    }

    function mint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    //ownable 필요
    function setBaseURI(string memory afterBaseURI) public onlyAdmin {
        baseURI = afterBaseURI;
    }

    function stakeNFT(uint256 tokenId, bytes memory userSignature) public {
        require(verifyStake(msg.sender, userSignature));
        require(
            ownerOf(tokenId) == msg.sender,
            "You are not the owner of this NFT"
        );

        stakedNFT[msg.sender].push(tokenId);
    }

    function unStakeNFT(uint256 tokenId, bytes memory userSignature) public {
        require(verifyUnstake(msg.sender, userSignature));
        require(
            ownerOf(tokenId) == msg.sender,
            "You are not the owner of this NFT"
        );
        require(
            IShootingGame(shootingManager).checkOnGame(msg.sender) != 0,
            "You are on the game"
        );

        delete stakedNFT[msg.sender][tokenId];
    }

    function isStake(address user, uint256 tokenId) public view returns (bool) {
        uint256[] memory userStakedNFT = stakedNFT[user];

        for (uint256 i = 0; i < userStakedNFT.length; i++) {
            if (userStakedNFT[i] == tokenId) {
                return true;
            }
        }

        return false;
    }

    function getStat(uint256 tokenId) public view returns (uint8, uint88) {
        return (nftStats[tokenId].statType, nftStats[tokenId].value);
    }

    function verifyStake(address _signer, bytes memory _signature)
        public
        pure
        returns (bool)
    {
        string memory message = "I agree to stake";

        bytes32 origin = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", message)
        );

        address signer = origin.recover(_signature);

        require(signer == _signer, "Invalid signer");

        return true;
    }

    function verifyUnstake(address _signer, bytes memory _signature)
        public
        pure
        returns (bool)
    {
        string memory message = "I agree to unstake";

        bytes32 origin = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n36", message)
        );

        address signer = origin.recover(_signature);

        require(signer == _signer, "Invalid signer");

        return true;
    }

    function getShootingRole() public view returns (address) {
        return shootingRole;
    }

    function getShootingManger() public view returns (address) {
        return shootingManager;
    }
}
