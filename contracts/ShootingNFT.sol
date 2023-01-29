// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import "./ShootingRole.sol";

contract ShootingNFT is ERC721, ShootingRole {
    using ECDSA for bytes32;

    uint8 constant DEPENSE = 0;

    string public baseURI;

    mapping(address => uint256[]) private stakedNFT;
    mapping(uint256 => StatsInfo) private nftStats;

    struct StatsInfo {
        uint8 statType;
        uint248 amount;
    }

    constructor() ERC721("ShootingNFT", "SNFT") {}

    function mint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
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

    function stakeNFT(
        uint256 tokenId,
        bytes memory userSignature,
        address relayer,
        bytes memory relayerSignature
    ) public {
        require(isRelayer(relayer), "You are not the relayer of this NFT");
        require(verifyStake(msg.sender, userSignature));
        require(verifyStake(relayer, relayerSignature));
        require(
            ownerOf(tokenId) == msg.sender,
            "You are not the owner of this NFT"
        );

        stakedNFT[msg.sender].push(tokenId);
    }

    function unStakeNFT(
        uint256 tokenId,
        bytes memory userSignature,
        address relayer,
        bytes memory relayerSignature
    ) public {
        require(isRelayer(relayer), "You are not the relayer of this NFT");
        require(verifyUnstake(msg.sender, userSignature));
        require(verifyUnstake(relayer, relayerSignature));
        require(
            ownerOf(tokenId) == msg.sender,
            "You are not the owner of this NFT"
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

    function getStat(uint256 tokenId) public view returns (uint8, uint248) {
        return (nftStats[tokenId].statType, nftStats[tokenId].amount);
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

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
