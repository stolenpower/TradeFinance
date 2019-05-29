var TradeFinance = artifacts.require("./TradeFinance.sol");
var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer) {
  deployer.deploy(TradeFinance);
  deployer.deploy(Migrations);
};
