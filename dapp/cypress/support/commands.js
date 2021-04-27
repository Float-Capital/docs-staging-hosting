// NOTE: this code is heavily inspired by uniswap UI testing.

// ***********************************************
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************

import { JsonRpcProvider } from "@ethersproject/providers";
import { Wallet } from "@ethersproject/wallet";
import { Eip1193Bridge } from "@ethersproject/experimental/lib/eip1193-bridge";

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

class CustomizedBridge extends Eip1193Bridge {
  async sendAsync(...args) {
    console.debug("sendAsync called", ...args);
    return this.send(...args);
  }
  async send(...args) {
    console.debug("send called", ...args);
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
      } else {
        return Promise.resolve([TEST_ADDRESS_NEVER_USE]);
      }
    }
    if (method === "eth_chainId") {
      if (isCallbackForm) {
        callback(null, { result: kovanChainIdHex });
      } else {
        return Promise.resolve(kovanChainIdHex);
      }
    }
    try {
      const result = await super.send(method, params);
      console.debug("result received", method, params, result);
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
      const provider = new JsonRpcProvider(
        "https://kovan.infura.io/v3/4bf032f2d38a4ed6bb975b80d6340847",
        42
      );
      const signer = new Wallet(TEST_PRIVATE_KEY, provider);
      console.log("GOT THIS SIGNER...", signer);

      win.ethereum = new CustomizedBridge(signer, provider);
      // win.ethereum = new Eip1193Bridge(signer, provider);
    },
  });
});
