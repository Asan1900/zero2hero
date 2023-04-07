// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "ipfs/core/interface/CID.sol";

contract MyNFT is ERC721URIStorage, Ownable {
    using CID for bytes;

    uint256 private _tokenIdCounter;
    mapping (uint256 => string) private _tokenURIs;

    constructor() ERC721("MyNFT", "MNFT") {}

    function mintNFT(string memory tokenURI) public onlyOwner {
        _safeMint(msg.sender, _tokenIdCounter);
        _setTokenURI(_tokenIdCounter, tokenURI);
        _tokenIdCounter++;
    }

    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
        string memory _tokenURI = _tokenURIs[tokenId];
        bytes memory _tokenURICid = abi.encodePacked(_tokenURI).cid();
        string memory baseURI = "https://ipfs.io/ipfs/";
        
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, _tokenURICid.toString())) : _tokenURI;
        }
}