import { erc20 } from "../../generated/templates";
import {
  BigInt,
  Address,
  Bytes,
  log,
  ethereum,
  dataSource,
  DataSourceContext,
} from "@graphprotocol/graph-ts";
import { ZERO, ZERO_ADDRESS } from "../CONSTANTS";

import {
  getOrCreateUser,
  getOrCreateBalanceObject,
} from "./globalStateManager";

export function createNewTokenDataSource(address: Address): void {
  let context = new DataSourceContext();
  context.setString("contractAddress", address.toHex());
  context.setBoolean("isFloatToken", false);
  erc20.createWithContext(address, context);
}

export function updateBalanceTransfer(
  tokenAddressString: string,
  userAddress: Address,
  amount: BigInt,
  send: boolean // user sending or receiving
): void {
  let userAddressString = userAddress.toHex();

  if (userAddressString != ZERO_ADDRESS) {
    let user = getOrCreateUser(userAddress);
    user.save(); // necessary incase new user.

    let balanceFromObject = getOrCreateBalanceObject(
      tokenAddressString,
      userAddressString
    );
    if (send) {
      balanceFromObject.tokenBalance = balanceFromObject.tokenBalance.minus(
        amount
      );
    } else {
      balanceFromObject.tokenBalance = balanceFromObject.tokenBalance.plus(
        amount
      );
    }

    // Add to previouslyOwnedTokens if not already there
    user.tokenBalances =
      user.tokenBalances.indexOf(balanceFromObject.id) === -1
        ? user.tokenBalances.concat([balanceFromObject.id])
        : user.tokenBalances;

    balanceFromObject.save();
    user.save();
  }
}

export function updateBalanceFloatTransfer(
  userAddress: Address,
  amount: BigInt,
  send: boolean // user sending or receiving
): void {
  if (userAddress.toHex() != ZERO_ADDRESS) {
    let user = getOrCreateUser(userAddress);
    if (send) {
      user.floatTokenBalance = user.floatTokenBalance.minus(amount);
    } else {
      user.floatTokenBalance = user.floatTokenBalance.plus(amount);
    }
    user.save();
  }
}
