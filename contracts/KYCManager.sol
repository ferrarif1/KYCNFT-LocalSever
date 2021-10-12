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
    struct UserData{
    uint NFTid;
    string accumulator;
    string modN;
    string generator;
    }
  //KYC Provider is owner ：0x892953Cb6cDC87c8aD7c4aAfb06A716CBa231D8a
  
  address KYCNFTInterFaceAddress = 0xfAe53841d623a35851C00F66742768Cf28B01268;
  KYCNFTInterface kycNFTContract = KYCNFTInterface(KYCNFTInterFaceAddress);
 
 
  //NFTid到管理者地址
  mapping(uint => address) private NFTidToOwner;
  //管理者地址到累加器
  mapping(address => UserData) private OwnerToUserData;
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
    OwnerToUserData[manager].NFTid = NFTid;
    OwnerToUserData[manager].accumulator = "1";
  }  
   //modify是Manager addr权限
  function modifyNFTidToManagerAddr(uint NFTid, address newManager) public onlyOwnerOf(NFTid) {
    address oldmanager = NFTidToOwner[NFTid];
    UserData storage userdata = OwnerToUserData[oldmanager];
    OwnerToUserData[newManager] = userdata;
    NFTidToOwner[NFTid] = newManager;
  }



  /*
  （4）Map2:绑定管理地址与累加器
  */
  function setUpAccumulator(string memory _accumulator,string memory _modN,string memory _generator) public {
      UserData storage userdata = OwnerToUserData[msg.sender];
      userdata.accumulator = _accumulator;
      userdata.modN = _modN;
      userdata.generator = _generator;
  }
  
  function updateAccumulator(string memory _accumulator) public {
      UserData storage userdata = OwnerToUserData[msg.sender];
      userdata.accumulator = _accumulator;
  }
  
  
  

   /*
  （5）查询某NFT id对应的管理地址与累加器地址
  */
 
  //由NFTid 找managerAddr地址
  function ownerOfNFTid(uint NFTid) public view returns(address) {
      address addr = NFTidToOwner[NFTid];
      return addr;
  }
   //由NFTid 找Accumulator
  function accumulatorOfNFTID(uint NFTid) public view returns(string memory){
      address addr = NFTidToOwner[NFTid];
      UserData memory userdata = OwnerToUserData[addr];
      return userdata.accumulator;
  }
   //由Manager addr找Accumulator
  function accumulatorOfOwner(address managerAddr) public view returns(string memory){
      UserData memory userdata = OwnerToUserData[managerAddr];
      return userdata.accumulator;
  }
  //由NFTid查询有效性
  function availableOfNFTid(uint NFTid) public view returns(bool){
      return NFTidToAvailable[NFTid];
  }
  //由Manager addr找由NFTid
  function NFTidOfOwner(address managerAddr) public view returns(uint){
      UserData memory userdata = OwnerToUserData[managerAddr];
      return userdata.NFTid;
  }
}
