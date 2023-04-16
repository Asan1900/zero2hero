// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTToken is ERC721Full, ERC721URIStorage, Ownable {
    // for minters
    mapping(address => bool) public _minters;

    constructor() public ERC721Full("NAME", "SYMBOL") {
        _setBaseURI("https://BASEURI");
    }

    function setURIPrefix(string memory baseURI) internal {
        _setBaseURI(baseURI);
    }

    /**
     * @dev Function to mint tokens.
     * @param to The address that will receive the minted token.
     * @param tokenId The token id to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to, uint256 tokenId) external returns (bool) {
        require(_minters[msg.sender], "!minter");
        _mint(to, tokenId);
        _setTokenURI(tokenId, MathwalletUtil.uintToString(tokenId));
        return true;
    }

    /**
     * @dev Function to safely mint tokens.
     * @param to The address that will receive the minted token.
     * @param tokenId The token id to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function safeMint(address to, uint256 tokenId) public returns (bool) {
        require(_minters[msg.sender], "!minter");
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, MathwalletUtil.uintToString(tokenId));
        return true;
    }

    /**
     * @dev Function to safely mint tokens.
     * @param to The address that will receive the minted token.
     * @param tokenId The token id to mint.
     * @param _data bytes data to send along with a safe transfer check.
     * @return A boolean that indicates if the operation was successful.
     */
    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public returns (bool) {
        require(_minters[msg.sender], "!minter");
        _safeMint(to, tokenId, _data);
        _setTokenURI(tokenId, MathwalletUtil.uintToString(tokenId));
        return true;
    }

    function addMinter(address minter) public onlyOwner {
        _minters[minter] = true;
    }

    function removeMinter(address minter) public onlyOwner {
        _minters[minter] = false;
    }

    /**
     * @dev Burns a specific ERC721 token.
     * @param tokenId uint256 id of the ERC721 token to be burned.
     */
    function burn(uint256 tokenId) external {
        //solhint-disable-next-line max-line-length
        require(_minters[msg.sender], "!minter");
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "caller is not owner nor approved"
        );
        _burn(tokenId);
    }
    
    /* @dev Gets the list of token IDs of the requested owner.
     * @param owner address owning the tokens
     * @return uint256[] List of token IDs owned by the requested address
     */
    function tokensOfOwner(address owner) public view returns (uint256[] memory) {
        return _tokensOfOwner(owner);
    }
}