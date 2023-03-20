// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract DocumentSignature is ERC721 {
bytes32 public merkleRoot;
mapping(address => bool) public whitelist;

constructor(bytes32 _merkleRoot) ERC721("Document Signature", "DOCSIG") {
    merkleRoot = _merkleRoot;
}

function addToWhitelist(address[] memory _addresses) public {
    for (uint256 i = 0; i < _addresses.length; i++) {
        whitelist[_addresses[i]] = true;
    }
}

function removeFromWhitelist(address[] memory _addresses) public {
    for (uint256 i = 0; i < _addresses.length; i++) {
        whitelist[_addresses[i]] = false;
    }
}

function sign(bytes32 _proposalHash, bytes32[] calldata _proof) public {
    require(whitelist[msg.sender], "Not authorized to sign");
    require(MerkleProof.verify(_proof, merkleRoot, _proposalHash), "Invalid proof");

    uint256 tokenId = uint256(keccak256(abi.encodePacked(_proposalHash, msg.sender, block.number)));
    _safeMint(msg.sender, tokenId);
    }
}