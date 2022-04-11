// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";




contract KYCNFT is ERC721URIStorage,Ownable {
  address public owner = msg.sender;
  uint public last_completed_migration;
  mapping(uint => uint) public NFTID_To_ExpirationTime;
/*
  （1）创建NFT（ owner权限）

*/

 using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    constructor() ERC721("KYCNFT", "KYCNFT") {}
  
    function awardItem(address player, string memory tokenURI)
        external
        onlyOwner
        returns (uint256) 
    {  
        
        //_tokenIds自增，保证每个NFT的id唯一
        _tokenIds.increment();
        //指定nft的id
        uint256 newItemId = _tokenIds.current();
        //创建nft
        _mint(player, newItemId);
        //给这个nft添加tokenurl，这个url就是nft内容文件的存储地址
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function updateExpirationTime(uint tokenId,uint timestamp) onlyOwner{
        require(tokenId <= _tokenIds.current());
        NFTID_To_ExpirationTime[tokenId] = timestamp;
    }

    function expirationTimeOfNFTId(uint tokenId) public view returns(uint){
        return NFTID_To_ExpirationTime[tokenId];
    }
  
}
