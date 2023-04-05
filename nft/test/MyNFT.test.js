const { expect } = require("chai");
const { ethers } = require("hardhat");
const axios = require("axios");
const ipfs = require("ipfs-http-client");

describe("MyNFT", function () {
let MyNFT;
let myNFT;

beforeEach(async function () {
MyNFT = await ethers.getContractFactory("MyNFT");
myNFT = await MyNFT.deploy();
await myNFT.deployed();
});

it("Should mint new NFT", async function () {
const metadata = {
name: "My NFT",
description: "This is my NFT",
image: "https://ipfs.io/ipfs/QmXUADZD1Rb6Uf81ixKjxTPUwJwYUz2Pqo3X9Kb1ZDv1U6",
};
const ipfsClient = ipfs.create();
const cid = await ipfsClient.add(JSON.stringify(metadata));
const tokenURI = https://ipfs.io/ipfs/${cid.cid.toString()};
await myNFT.mintNFT(tokenURI);
const tokenOwner = await myNFT.ownerOf(0);
expect(tokenOwner).to.equal(await ethers.getSigner(0).getAddress());
});

it("Should return token URI", async function () {
const metadata = {
name: "My NFT",
description: "This is my NFT",
image: "https://ipfs.io/ipfs/QmXUADZD1Rb6Uf81ixKjxTPUwJwYUz2Pqo3X9Kb1ZDv1U6",
};
const ipfsClient = ipfs.create();
const cid = await ipfsClient.add(JSON.stringify(metadata));
const tokenURI = https://ipfs.io/ipfs/${cid.cid.toString()};
await myNFT.mintNFT(tokenURI);
const returnedTokenURI = await myNFT.tokenURI(0);
expect(returnedTokenURI).to.equal(tokenURI);
});

it("Should reject minting by unauthorized address", async function () {
    const metadata = {
    name: "My NFT",
    description: "This is my NFT",
    image: "https://ipfs.io/ipfs/QmXUADZD1Rb6Uf81ixKjxTPUwJwYUz2Pqo3X9Kb1ZDv1U6",
    };
    const ipfsClient = ipfs.create();
    const cid = await ipfsClient.add(JSON.stringify(metadata));
    const tokenURI = https://ipfs.io/ipfs/${cid.cid.toString()};
    const [, unauthorized] = await ethers.getSigners();
    await expect(myNFT.connect(unauthorized).mintNFT(tokenURI)).to.be.revertedWith("Ownable: caller is not the owner");
});

});