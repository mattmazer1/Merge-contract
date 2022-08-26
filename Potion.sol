// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Potion is ERC721, ERC721Enumerable,Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint8 maxSupply;
    mapping(address => bool) public minted;
    string public baseTokenURI;

    constructor() ERC721("Emojis", "EMJS") {
           _tokenIdCounter.increment();
           maxSupply=2;
           baseTokenURI="ipfs://QmYAZPnU3v8Datfg24UnfZgpaniL9LR9EVu4otbToRdscp/";
    }

         function setURI(string memory newURI) public onlyOwner {
        baseTokenURI = newURI;
    }

     function mint(address to) public payable {
        
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId <= maxSupply, "All nfts have been minted");
        require(minted[to]==false,"You can only mint once"); 
        _safeMint(to, tokenId);
        _tokenIdCounter.increment();
        minted[to]=true;
     }


  function tokenURI(uint256 tokenId) public view override returns (string memory){
        require( _exists(tokenId), "ERC721Metadata: URI query for nonexistent token" );
        string memory currentBaseURI = baseTokenURI;
        return
            bytes(currentBaseURI).length > 0 ? string(
            abi.encodePacked(currentBaseURI,Strings.toString(tokenId),".json"))
                : "";
    }

    function tokensOfOwner(address _owner) public view returns (uint256[] memory){
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
