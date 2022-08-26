
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Mutation is ERC721, ERC721Enumerable, ERC721Holder, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    IERC721 public emojis;
    IERC721 public potion;
    address burnAddress;
    mapping(address => bool) public minted;
    uint256 maxSupply;
    string public baseTokenURI;

    constructor(address _emojis, address _potion) ERC721("mutation", "mut") {
        emojis = IERC721(_emojis);
        potion = IERC721(_potion);
        burnAddress=0x5e84BDda5426F59Db64991157e081AE653FB0c6f;
        maxSupply = 2;
        baseTokenURI="ipfs://Qmdp7fTb7f1gTEYe6JkC22h4jScuwqxMgpAFFpeUmrk8Tq/";
    }


          function setURI(string memory newURI) public onlyOwner {
        baseTokenURI = newURI;
    }


    function mint(address to, uint256 emojisId, uint256 potionId) public {
        uint256 mutatedId = emojisId;
        uint256 tokenId = _tokenIdCounter.current();
        require(emojisId > 0 && potionId > 0,"You don't have an emoji or potion");
        require(tokenId <= maxSupply, "All nfts have been minted");
        require(minted[to]==false,"You can only mint once"); 
        emojis.safeTransferFrom(msg.sender,address(this), emojisId);
        potion.safeTransferFrom(msg.sender,address(this), potionId);
        _safeMint(to, mutatedId);
        _tokenIdCounter.increment(); 
        minted[to]=true;
        potion.transferFrom(address(this),burnAddress,potionId);
        emojis.transferFrom(address(this), msg.sender,emojisId);
    
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

  function tokenURI(uint256 tokenId) public view override returns (string memory){
        require( _exists(tokenId), "ERC721Metadata: URI query for nonexistent token" );
        string memory currentBaseURI = baseTokenURI;
        return
            bytes(currentBaseURI).length > 0 ? string(
            abi.encodePacked(currentBaseURI,Strings.toString(tokenId),".json"))
                : "";
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
