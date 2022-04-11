// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./KYCNFT.sol";

interface KYCNFTInterface {
  function awardItem(address player, string memory tokenURI) external returns (uint256);
}

/*
n, accumulator数字较大，常超过300位10进制数，超过uint256范围，使用string
*/
contract KYCManager is Ownable {
    struct UserData{
    uint NFTid;
    string accumulator;
    string n;
    uint g;
    }
  
  address KYCNFTInterFaceAddress = 0xfAe53841d623a35851C00F66742768Cf28B01268;
  KYCNFTInterface kycNFTContract = KYCNFTInterface(KYCNFTInterFaceAddress);

 
  //NFTid到管理者地址
  mapping(uint => address) private NFTidToManager;
  //管理者地址到累加器
  mapping(address => UserData) private ManagerToUserData;
  //NFT有效性
  mapping(uint => bool) private NFTidToAvailable;
  
  
  //限制函数调用者为KYCNFT的拥有者
  modifier onlyManagerOf(uint _NFTid){
      require(msg.sender == NFTidToManager[_NFTid]);
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
  function createKYCNFT(string memory tokenUrl, address manager, uint expirationTime) public onlyOwner{
    kycNFTContract = KYCNFTInterface(KYCNFTInterFaceAddress);//保证最新
    //NFT给合约地址而不是合约的owner
    address kycnftmanager = (address)(this);
    uint256 NFTid = kycNFTContract.awardItem(kycnftmanager, tokenUrl);
    kycNFTContract.updateExpirationTime(NFTid, expirationTime);
    //将NFTid设为可用
    setNFTAvailable(NFTid, true);
    //绑定NFTid与管理地址
    initManagerAddr(NFTid, manager);
  }
  
  //设置NFT有效性
  function setNFTAvailableOfNFTId(uint NFTid, bool _available)  public onlyOwner{
    NFTidToAvailable[NFTid] = _available;
  }
  
  
  /*
  （3）Map1:绑定NFTid与管理地址
  
   */
   //init是owner权限
  function initManagerAddr(uint NFTid, address manager) public onlyOwner {
    NFTidToManager[NFTid] = manager;
    ManagerToUserData[manager].NFTid = NFTid;
  }  
   //modify是Manager addr权限
  function modifyManagerAddr(uint NFTid, address newManager) public onlyManagerOf(NFTid) {
    address oldmanager = NFTidToManager[NFTid];
    UserData storage userdata = ManagerToUserData[oldmanager];
    ManagerToUserData[newManager] = userdata;//userdata迁移
    NFTidToManager[NFTid] = newManager;//manager重置
  }


  /*
  （4）Map2:绑定管理地址与累加器
  */

  function updateAccumulator(string memory _accumulator, string memory _n, string _g) public {
      UserData storage userdata = ManagerToUserData[msg.sender];
      userdata.accumulator = _accumulator;
      userdata.n = _n;
      userdata.g = _g;
  }

  function updateAccumulatorPublicKey(string memory _n, uint _g) public {
      UserData storage userdata = ManagerToUserData[msg.sender];
      userdata.n = _n;
      userdata.g = _g;
  }

  function updateAccumulatorValue(string memory _accumulator) public {
      UserData storage userdata = ManagerToUserData[msg.sender];
      userdata.accumulator = _accumulator;
  }
  

   /*
  （5）查询某NFT id对应的管理地址与累加器地址
  */
 
  //由NFTid 找managerAddr地址
  function managerOfNFTId(uint NFTid) public view returns(address) {
      address addr = NFTidToManager[NFTid];
      return addr;
  }
   //由NFTid 找Accumulator
  function userDataOfNFTId(uint NFTid) public view returns(UserData memory){
      address addr = NFTidToManager[NFTid];
      UserData memory userdata = ManagerToUserData[addr];
      return userdata;
  }
   //由Manager addr找Accumulator
  function userDataOfManager(address managerAddr) public view returns(UserData memory){
      UserData memory userdata = ManagerToUserData[managerAddr];
      return userdata;
  }
  //由NFTid查询有效性
  function availableOfNFTId(uint NFTid) public view returns(bool){
      return NFTidToAvailable[NFTid];
  }
  //由Manager addr找由NFTid
  function NFTIdOfManager(address managerAddr) public view returns(uint){
      UserData memory userdata = ManagerToUserData[managerAddr];
      return userdata.NFTid;
  }
}
