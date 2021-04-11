import { erc20 } from "../../generated/templates";
import {
  BigInt,
  Address,
  ethereum,
  DataSourceContext,
  log,
} from "@graphprotocol/graph-ts";
import { ZERO, ZERO_ADDRESS } from "../CONSTANTS";

import {
  getOrCreateUser,
  getOrCreateBalanceObject,
  getOrCreateCollatoralBalanceObject,
} from "./globalStateManager";
import {
  SyntheticToken,
  UserSyntheticTokenMinted,
} from "../../generated/schema";

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
  send: boolean, // user sending or receiving,
  event: ethereum.Event
): void {
  let userAddressString = userAddress.toHex();

  if (userAddressString != ZERO_ADDRESS) {
    let user = getOrCreateUser(userAddress, event);
    user.save(); // necessary incase new user.

    let balanceFromObject = getOrCreateBalanceObject(
      tokenAddressString,
      userAddressString
    );
    balanceFromObject.timeLastUpdated = event.block.timestamp;

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
  } else {
    let token = SyntheticToken.load(tokenAddressString);

    if (send) {
      token.tokenSupply = token.tokenSupply.plus(amount);
    } else {
      token.tokenSupply = token.tokenSupply.minus(amount);
    }

    token.save();
  }
}

export function updateCollatoralBalanceTransfer(
  tokenAddressString: string,
  userAddress: Address,
  amount: BigInt,
  send: boolean, // user sending or receiving,
  event: ethereum.Event
): void {
  let userAddressString = userAddress.toHex();

  let user = getOrCreateUser(userAddress, event);
  user.save(); // necessary incase new user.

  let balanceFromObject = getOrCreateCollatoralBalanceObject(
    tokenAddressString,
    userAddressString
  );
  balanceFromObject.timeLastUpdated = event.block.timestamp;

  if (send) {
    balanceFromObject.balance = balanceFromObject.balance.minus(amount);
  } else {
    balanceFromObject.balance = balanceFromObject.balance.plus(amount);
  }

  // Add to previouslyOwnedTokens if not already there
  user.collatoralBalances =
    user.collatoralBalances.indexOf(balanceFromObject.id) === -1
      ? user.collatoralBalances.concat([balanceFromObject.id])
      : user.collatoralBalances;

  balanceFromObject.save();
  user.save();
}

export function updateBalanceFloatTransfer(
  userAddress: Address,
  amount: BigInt,
  send: boolean, // user sending or receiving
  event: ethereum.Event
): void {
  if (userAddress.toHex() != ZERO_ADDRESS) {
    let user = getOrCreateUser(userAddress, event);
    if (send) {
      user.floatTokenBalance = user.floatTokenBalance.minus(amount);
    } else {
      user.floatTokenBalance = user.floatTokenBalance.plus(amount);
    }
    user.save();
  }
}

export function increaseUserMints(
  userAddress: Address,
  syntheticToken: SyntheticToken | null,
  tokensMinted: BigInt, // user sending or receiving
  event: ethereum.Event
): void {
  //load user
  let user = getOrCreateUser(userAddress, event);
  let userAddressString = user.address.toHex();
  let tokenAddressString = syntheticToken.tokenAddress.toHex();

  let minted = UserSyntheticTokenMinted.load(
    tokenAddressString + "-" + userAddressString + "-minted"
  );
  if (minted == null) {
    minted = new UserSyntheticTokenMinted(
      tokenAddressString + "-" + userAddressString + "-minted"
    );
    minted.user = user.id;
    minted.syntheticToken = syntheticToken.id;
    minted.tokensMinted = ZERO;
  }

  minted.tokensMinted = minted.tokensMinted.plus(tokensMinted);

  // Add to previouslyOwnedTokens if not already there
  user.tokenMints =
    user.tokenMints.indexOf(minted.id) === -1
      ? user.tokenMints.concat([minted.id])
      : user.tokenMints;

  user.save();
  minted.save();
}
