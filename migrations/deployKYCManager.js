const KYCManager = artifacts.require("KYCManager");

module.exports = function (deployer){
  deployer.deploy(KYCManager);
};
