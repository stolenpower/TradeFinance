var HDWalletProvider = require("truffle-hdwallet-provider");
var Web3 = require("web3");

var RPC_ENDPOINT = "http://52.175.245.187:8083/api/node/rpc";
var MNEMONIC = "chapter noise taxi manage attitude rapid list pull jar crucial brave myself";

module.exports = {
    networks: {
      development: {
        host: "localhost",
        port: 8545,
        network_id: "*"
      },
      eleven01: {
        provider: function() {
          return new HDWalletProvider(MNEMONIC, RPC_ENDPOINT)
        },
        network_id: "*",
        gasPrice: 0,
        gas: 2000000,
      }
    }
  }