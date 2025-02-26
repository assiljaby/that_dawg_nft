// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToURI;

    constructor() ERC721("That Dawg", "DAWG") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory uri) public {
        s_tokenIdToURI[s_tokenCounter] = uri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToURI[tokenId];
    }

    /* Getter Functions */
    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
