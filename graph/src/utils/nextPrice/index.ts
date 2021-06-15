import {
  BatchedNextPriceExec,
  NextBatchedNextPriceExec,
  SyntheticMarket,
  User,
  UserNextPriceAction,
  UserNextPriceActionComponent,
} from "../../../generated/schema";
import { Address, BigInt, Bytes, ethereum } from "@graphprotocol/graph-ts";
import { ACTION_MINT, MARKET_SIDE_LONG, ZERO } from "../../CONSTANTS";

function generateUserNextPriceActionId(
  userAddress: Bytes,
  marketIndex: BigInt,
  updateIndex: BigInt
): string {
  return (
    "nextPrice-" +
    userAddress.toHex() +
    "-" +
    marketIndex.toString() +
    "-" +
    updateIndex.toString()
  );
}
function generateBatchedNextPriceExecId(
  marketIndex: BigInt,
  updateIndex: BigInt
): string {
  return "batched-" + marketIndex.toString() + "-" + updateIndex.toString();
}
function getNetxBatchedNextPriceExecId(marketIndex: BigInt): string {
  return "nextBatch-" + marketIndex.toString();
}

function generateUserNextPriceActionComponentId(
  userAddress: Bytes,
  marketIndex: BigInt,
  updateIndex: BigInt,
  actionType: string,
  actionIndex: i32
): string {
  return (
    "actionComponent-" +
    userAddress.toHex() +
    "-" +
    marketIndex.toString() +
    "-" +
    updateIndex.toString() +
    "-" +
    actionType +
    "-" +
    actionIndex.toString()
  );
}
export function createOrUpdateBatchedNextPriceExec(
  userNextPriceActionComponent: UserNextPriceActionComponent
): BatchedNextPriceExec {
  let marketIndex = userNextPriceActionComponent.marketIndex;
  let updateIndex = userNextPriceActionComponent.updateIndex;
  let userAddress = Address.fromString(userNextPriceActionComponent.user);
  let syntheticTokenType = userNextPriceActionComponent.marketSide;
  let actionType = userNextPriceActionComponent.actionType;
  let amount = userNextPriceActionComponent.amount;

  let batchedNextPriceExecId = generateBatchedNextPriceExecId(
    marketIndex,
    updateIndex
  );
  let batchedNextPriceExec = BatchedNextPriceExec.load(batchedNextPriceExecId);
  if (batchedNextPriceExec == null) {
    batchedNextPriceExec = new BatchedNextPriceExec(batchedNextPriceExecId);

    batchedNextPriceExec.updateIndex = updateIndex;
    batchedNextPriceExec.marketIndex = marketIndex;
    batchedNextPriceExec.amountPaymentTokenForDepositLong = ZERO;
    batchedNextPriceExec.amountPaymentTokenForDepositShort = ZERO;
    batchedNextPriceExec.amountSynthTokenForWithdrawalLong = ZERO;
    batchedNextPriceExec.amountSynthTokenForWithdrawalShort = ZERO;
    batchedNextPriceExec.mintPriceSnapshot = ZERO;
    batchedNextPriceExec.redeemPriceSnapshot = ZERO;
    batchedNextPriceExec.executedTimestamp = ZERO;
    batchedNextPriceExec.linkedUserNextPriceActions = [];
    batchedNextPriceExec.save();

    // TODO: move this externally to its own getter (avoid race conditions)
    let nextBatchedNextPriceExecId = getNetxBatchedNextPriceExecId(marketIndex);
    let nextBatchedNextPriceExec = NextBatchedNextPriceExec.load(
      nextBatchedNextPriceExecId
    );
    if (nextBatchedNextPriceExec == null) {
      nextBatchedNextPriceExec = new NextBatchedNextPriceExec(
        nextBatchedNextPriceExecId
      );
    }

    nextBatchedNextPriceExec.nextBatch = batchedNextPriceExec.id;
    nextBatchedNextPriceExec.currentUpdateIndex = updateIndex;

    nextBatchedNextPriceExec.save();
  }

  let userNextPriceActionId = generateUserNextPriceActionId(
    userAddress,
    marketIndex,
    updateIndex
  );

  if (
    batchedNextPriceExec.linkedUserNextPriceActions.indexOf(
      userNextPriceActionId
    ) == -1
  ) {
    batchedNextPriceExec.linkedUserNextPriceActions = batchedNextPriceExec.linkedUserNextPriceActions.concat(
      [userNextPriceActionId]
    );
  }

  if (actionType == ACTION_MINT) {
    if (syntheticTokenType == MARKET_SIDE_LONG) {
      batchedNextPriceExec.amountPaymentTokenForDepositLong = batchedNextPriceExec.amountPaymentTokenForDepositLong.plus(
        amount
      );
    } else {
      batchedNextPriceExec.amountPaymentTokenForDepositShort = batchedNextPriceExec.amountPaymentTokenForDepositShort.plus(
        amount
      );
    }
  } else {
    if (syntheticTokenType == MARKET_SIDE_LONG) {
      batchedNextPriceExec.amountSynthTokenForWithdrawalLong = batchedNextPriceExec.amountSynthTokenForWithdrawalLong.plus(
        amount
      );
    } else {
      batchedNextPriceExec.amountSynthTokenForWithdrawalLong = batchedNextPriceExec.amountSynthTokenForWithdrawalLong.plus(
        amount
      );
    }
  }

  return batchedNextPriceExec as BatchedNextPriceExec;
}

export function createUserNextPriceActionComponent(
  user: User,
  syntheticMarket: SyntheticMarket,
  updateIndex: BigInt,
  amount: BigInt,
  actionType: string,
  syntheticTokenType: string,
  event: ethereum.Event
): UserNextPriceActionComponent {
  let actionIndex = 0;
  let hasntFoundUnititializedIndex = true;
  let userNextPriceActionComponent: UserNextPriceActionComponent | null;
  // The user can have multiple NextPriceActions, even within the same block or of the same type (long/shrt) - this increments the index until it finds an empty one.
  //        Unbounded here, but the impracticality (and blockchain limitations) of the user creating many thousands of actions means this code is ok.
  while (hasntFoundUnititializedIndex) {
    let userNextPriceActionComponentId = generateUserNextPriceActionComponentId(
      user.address,
      syntheticMarket.marketIndex,
      updateIndex,
      actionType,
      actionIndex
    );
    userNextPriceActionComponent = UserNextPriceActionComponent.load(
      userNextPriceActionComponentId
    );
    hasntFoundUnititializedIndex = userNextPriceActionComponent != null;
  }

  userNextPriceActionComponent.actionType = actionType;
  userNextPriceActionComponent.marketSide = syntheticTokenType;
  userNextPriceActionComponent.amount = amount;
  userNextPriceActionComponent.timestamp = event.block.timestamp;
  userNextPriceActionComponent.user = user.id;
  userNextPriceActionComponent.updateIndex = updateIndex;
  userNextPriceActionComponent.marketIndex = syntheticMarket.marketIndex;
  userNextPriceActionComponent.userAggregateAction = generateUserNextPriceActionId(
    user.address,
    syntheticMarket.marketIndex,
    updateIndex
  );
  userNextPriceActionComponent.associatedBatch = generateBatchedNextPriceExecId(
    syntheticMarket.marketIndex,
    updateIndex
  );

  userNextPriceActionComponent.save();

  return userNextPriceActionComponent as UserNextPriceActionComponent;
}

// type UserNextPriceActionComponent @entity {
//   id: ID! # actionComponent-<userAddress>-<marketIndex>-<update-index>-<type>-<index-of-type> // the index-of-type is for the case that multiple actions of the same type occur
// }

export function createOrUpdateUserNextPriceAction(
  user: User,
  syntheticMarket: SyntheticMarket,
  updateIndex: BigInt,
  associatedBatch: BatchedNextPriceExec,
  amount: BigInt
): UserNextPriceAction {
  let userNextPriceActionId = generateUserNextPriceActionId(
    user.address,
    syntheticMarket.marketIndex,
    updateIndex
  );
  let userNextPriceAction = UserNextPriceAction.load(userNextPriceActionId);

  if (userNextPriceAction == null) {
    userNextPriceAction = new UserNextPriceAction(userNextPriceActionId);

    userNextPriceAction.updateIndex = updateIndex;
    userNextPriceAction.marketIndex = syntheticMarket.marketIndex;
    userNextPriceAction.user = user.id;
    userNextPriceAction.amountPaymentTokenForDepositLong = ZERO;
    userNextPriceAction.amountPaymentTokenForDepositShort = ZERO;
    userNextPriceAction.amountSynthTokenForWithdrawalLong = ZERO;
    userNextPriceAction.amountSynthTokenForWithdrawalShort = ZERO;
    userNextPriceAction.confirmedTimestamp = ZERO;
    userNextPriceAction.associatedBatch = associatedBatch.id;
    userNextPriceAction.settledTimestamp = ZERO;
    userNextPriceAction.nextPriceActionComponents = [];

    userNextPriceAction.save();

    syntheticMarket.nextPriceActions = syntheticMarket.nextPriceActions.concat([
      userNextPriceAction.id,
    ]);
    syntheticMarket.save();

    user.pendingNextPriceActions = user.pendingNextPriceActions.concat([
      userNextPriceAction.id,
    ]);
    user.save();
  }

  return userNextPriceAction as UserNextPriceAction;
}
