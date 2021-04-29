// NOTE: this code is heavily inspired by uniswap UI testing.

// ***********************************************
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************

// BEWARE - there are dragons in this file!

import { JsonRpcProvider } from "@ethersproject/providers";
import { Wallet } from "@ethersproject/wallet";
import { Eip1193Bridge } from "@ethersproject/experimental/lib/eip1193-bridge";
// I wish I could use ethersjs exclusively, but that seems to be an issue, so using web3js for problematic functions
import Web3 from "web3";
import HDWalletProvider from "@truffle/hdwallet-provider";

import { ethers } from "ethers";

let TEST_PRIVATE_KEY = Cypress.env("INTEGRATION_TEST_PRIVATE_KEY");

if (!TEST_PRIVATE_KEY) {
  console.log(
    "The `CYPRESS_INTEGRATION_TEST_PRIVATE_KEY` variable isn't set, falling back to default integration test private key"
  );
  TEST_PRIVATE_KEY =
    "0x190b31ed0edad3c4a1ee6b42e568c67cf6237eb5b80502cafe15817fd08863cf";
}

// address of the above key
export const TEST_ADDRESS_NEVER_USE = new Wallet(TEST_PRIVATE_KEY).address;

const kovanChainIdHex = "0x2A";

// There aren't a lot of docs on the `eip1193bridge` unfortunately: https://docs.ethers.io/v5/api/experimental/#experimental-eip1193bridge
//    And here is the EIP spec: https://eips.ethereum.org/EIPS/eip-1193
class CustomizedBridge extends Eip1193Bridge {
  constructor(signer, wallet, web3Obj) {
    // Constructor
    super(signer, wallet);

    this.web3Obj = web3Obj;
  }
  async sendAsync(...args) {
    console.log("sendAsync called", ...args);
    return this.send(...args);
  }
  async send(...args) {
    console.log("send called", ...args);
    const isCallbackForm =
      typeof args[0] === "object" && typeof args[1] === "function";
    let callback;
    let method;
    let params;
    if (isCallbackForm) {
      callback = args[1];
      method = args[0].method;
      params = args[0].params;
    } else {
      method = args[0];
      params = args[1];
    }
    if (method === "eth_requestAccounts" || method === "eth_accounts") {
      if (isCallbackForm) {
        callback({ result: [TEST_ADDRESS_NEVER_USE] });
        return;
      } else {
        return Promise.resolve([TEST_ADDRESS_NEVER_USE]);
      }
    }
    if (method === "eth_chainId") {
      if (isCallbackForm) {
        callback(null, { result: kovanChainIdHex });
        return;
      } else {
        return Promise.resolve(kovanChainIdHex);
      }
    }
    // NOTE: there should be no need for this extra code or the use of web3js (rather than ethers).
    //       This is here because without it the call for the users balance was not working - couldn't find any other fixes.
    //       TODO: use ethersjs rather than web3js for this.
    if (method === "eth_call") {
      try {
        if (isCallbackForm) {
          this.web3Obj.eth.call(params[0], params[1], callback);
          console.log("Yhere!");
          return;
        } else {
          return await this.web3Obj.eth.call(params[0], params[1]);
        }
      } catch (error) {
        if (isCallbackForm) {
          callback(error, null);
        } else {
          throw error;
        }
      }
    }
    // if (method === "eth_sendTransaction") {
    //   // NOTE: for some reason you need to rename "gas" to "gasPrice" to get this transaction to work.
    //   const newParams = {
    //     gasLimit: params[0].gas,
    //     to: params[0].to,
    //     data: params[0].data,
    //   };
    //   // delete Object.assign(newParams, params[0], {
    //   //   gasLimit: params[0].gas,
    //   // }).gas;
    //   // delete newParams.from;
    // }
    if (method === "eth_sendTransaction") {
      // I'm at a loss here... Try this? https://github.com/ethers-io/ethers.js/blob/4898e7baacc4ed40d880b48e894b61118776dddb/packages/experimental/src.ts/eip1193-bridge.ts#L85
      try {
        if (isCallbackForm) {
          this.web3Obj.eth.sendTransaction(
            { ...params[0], from: (await this.web3Obj.eth.getAccounts())[0] },
            callback
          );
          return;
        } else {
          return await this.web3Obj.eth.sendTransaction({
            ...params[0],
            from: (await this.web3Obj.eth.getAccounts())[0],
          });
        }
      } catch (error) {
        if (isCallbackForm) {
          callback(error, null);
        } else {
          throw error;
        }
      }
    }
    try {
      const result = await super.send(method, params);
      if (isCallbackForm) {
        callback(null, { result });
      } else {
        return result;
      }
    } catch (error) {
      if (isCallbackForm) {
        callback(error, null);
      } else {
        throw error;
      }
    }
  }
}

// sets up the injected provider to be a mock ethereum provider with the given mnemonic/index
Cypress.Commands.overwrite("visit", (original, url, options) => {
  return original(url, {
    ...options,
    onBeforeLoad(win) {
      console.log("Calling the before load from options");
      options && options.onBeforeLoad && options.onBeforeLoad(win);
      win.localStorage.clear();

      const providerUrl =
        "https://eth-kovan.alchemyapi.io/v2/oxbTbIRuvEAetPHd7QHgaAW-ba-T_lNQ";
      console.log(
        "using this key",
        "https://eth-kovan.alchemyapi.io/v2/oxbTbIRuvEAetPHd7QHgaAW-ba-T_lNQ"
      );
      const provider = new JsonRpcProvider(
        providerUrl, // "https://kovan.infura.io/v3/4bf032f2d38a4ed6bb975b80d6340847",
        42
      );
      const signer = new Wallet(TEST_PRIVATE_KEY, provider);
      console.log("GOT THIS SIGNER...", signer);

      let web3jsProvider = new HDWalletProvider({
        privateKeys: [TEST_PRIVATE_KEY],
        providerOrUrl: providerUrl,
      });
      const web3 = new Web3(web3jsProvider);
      web3.eth
        .getAccounts()
        .then((accounts) => console.log("using these accounts", accounts));

      win.ethereum = new CustomizedBridge(signer, provider, web3);
      // win.ethereum = new ethers.providers.Web3Provider(web3jsProvider);
    },
  });
});
