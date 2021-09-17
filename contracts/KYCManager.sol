// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./KYCNFT.sol";

interface KYCNFTInterface {
  function awardItem(address player, string memory tokenURI) external returns (uint256);
}

contract KYCManager is Ownable {
  //KYC Provider is owner
  
  //KYCNFT：0xfAe53841d623a35851C00F66742768Cf28B01268
  //KYCManager：0x5D39F07686c6782121Ffc5Cda4f65dE45220Aba9
  address KYCNFTInterFaceAddress = 0xfAe53841d623a35851C00F66742768Cf28B01268;
  KYCNFTInterface kycNFTContract = KYCNFTInterface(KYCNFTInterFaceAddress);

  //NFTid到管理者地址
  mapping(uint => address) private NFTidToOwner;
  //管理者地址到累加器
  mapping(address => string) private OwnerToAccumulatorAddr;
  //NFT有效性
  mapping(uint => bool) private NFTidToAvailable;
  
  
  //限制函数调用者为KYCNFT的拥有者
  modifier onlyOwnerOf(uint _NFTid){
      require(msg.sender == NFTidToOwner[_NFTid]);
      _;
  }
  
  
  /*
   (1) 创建NFT（ owner权限）
   (2) 设置NFT有效性
  */
  //设置KYCNFT合约地址
  function setKYCNFTContractAddress(address _kycnftContractAddr) public onlyOwner {
    kycNFTContract = KYCNFTInterface(_kycnftContractAddr);
  }
  
  
  //创建某个用户的KYCNFT
  function createKYCNFT(string memory tokenUrl, address manager) public onlyOwner{
    kycNFTContract = KYCNFTInterface(KYCNFTInterFaceAddress);
    //NFT给合约地址而不是合约的owner
    address kycnftmanager = (address)(this);
    uint256 NFTid = kycNFTContract.awardItem(kycnftmanager, tokenUrl);
    //将NFTid设为可用
    setNFTAvailable(NFTid, true);
    //创建完就绑定NFTid与管理地址
    createNFTidToManagerAddr(NFTid, manager);
  }
  
  //设置NFT有效性
  function setNFTAvailable(uint NFTid, bool _available)  public onlyOwner{
    NFTidToAvailable[NFTid] = _available;
  }
  
  
  
/*
  （3）Map1:绑定NFTid与管理地址
  
*/
 
   //create是owner权限
  function createNFTidToManagerAddr(uint NFTid, address manager) public onlyOwner {
    NFTidToOwner[NFTid] = manager;
  }  
   //modify是Manager addr权限
  function modifyNFTidToManagerAddr(uint NFTid, address newManager) public onlyOwnerOf(NFTid) {
    NFTidToOwner[NFTid] = newManager;
  }



/*
  （4）Map2:绑定管理地址与累加器地址（查询管理地址已经有了对应的KYCNFT）
*/
  function bindMangerToAccumulator(string memory _AddrOfAccumulator) public {
    OwnerToAccumulatorAddr[msg.sender] = _AddrOfAccumulator;
  }
  
  

/*
  （5）查询某NFT id对应的管理地址与累加器地址
*/
 
  //由NFTid 找Owner地址
  function ownerOfNFTid(uint NFTid) public view returns(address) {
      address addr = NFTidToOwner[NFTid];
      return addr;
  }
   //由NFTid 找Accumulator地址
  function accumulatorAddrOfNFTID(uint NFTid) public view returns(string memory){
      address addr = NFTidToOwner[NFTid];
      string memory accumulatorAddr = OwnerToAccumulatorAddr[addr];
      return accumulatorAddr;
  }
   //由Owner 找Accumulator地址
  function accumulatorAddrOfOwner(address ownerAddr) public view returns(string memory){
      string memory accumulatorAddr = OwnerToAccumulatorAddr[ownerAddr];
      return accumulatorAddr;
  }
  //由NFTid查询有效性
  function availableOfNFTid(uint NFTid) public view returns(bool){
      return NFTidToAvailable[NFTid];
  }
 
}
