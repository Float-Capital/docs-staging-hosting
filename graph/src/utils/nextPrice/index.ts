import {
  BatchedNextPriceExec,
  NextBatchedNextPriceExec,
  SyntheticMarket,
  User,
  UserNextPriceAction,
  UserNextPriceActionComponent,
  UsersCurrentNextPriceAction,
  UserNextPriceStakeActionComponent,
} from "../../../generated/schema";
import { Address, BigInt, Bytes, ethereum, log } from "@graphprotocol/graph-ts";
import { ACTION_MINT, ACTION_SHIFT, MARKET_SIDE_LONG } from "../../CONSTANTS";
import {
  getOrInitializeBatchedNextPriceExec,
  getOrInitializeUserNextPriceAction,
  getUserNextPriceAction,
  getUsersCurrentNextPriceAction,
} from "../../generated/EntityHelpers";

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
export function generateBatchedNextPriceExecId(
  marketIndex: BigInt,
  updateIndex: BigInt
): string {
  return "batched-" + marketIndex.toString() + "-" + updateIndex.toString();
}
function getNextBatchedNextPriceExecId(marketIndex: BigInt): string {
  return "nextBatch-" + marketIndex.toString();
}
function getUsersCurrentNextPriceActionId(
  userAddress: Bytes,
  marketIndex: BigInt
): string {
  return (
    "userCurrentAction-" + marketIndex.toString() + "-" + userAddress.toHex()
  );
}

export function getCurrentUserNextPriceAction(
  userAddress: Bytes,
  marketIndex: BigInt
): UserNextPriceAction {
  let usersCurrentNextPriceActionId = getUsersCurrentNextPriceActionId(
    userAddress,
    marketIndex
  );
  let usersCurrentNextPriceAction = getUsersCurrentNextPriceAction(
    usersCurrentNextPriceActionId
  );

  return getUserNextPriceAction(usersCurrentNextPriceAction.currentAction);
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
  let isLong = userNextPriceActionComponent.marketSide;
  let actionType = userNextPriceActionComponent.actionType;
  let amount = userNextPriceActionComponent.amount;
  let batchedNextPriceExecId = generateBatchedNextPriceExecId(
    marketIndex,
    updateIndex
  );
  let entityFetchResult = getOrInitializeBatchedNextPriceExec(
    batchedNextPriceExecId
  );
  let batchedNextPriceExec = entityFetchResult.entity;
  if (entityFetchResult.wasCreated) {
    // TODO: move this externally to its own getter (avoid even a remote change of race conditions)
    let nextBatchedNextPriceExecId = getNextBatchedNextPriceExecId(marketIndex);
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

    batchedNextPriceExec.marketIndex = marketIndex;
    batchedNextPriceExec.save();
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
    if (isLong == MARKET_SIDE_LONG) {
      batchedNextPriceExec.amountPaymentTokenForDepositLong = batchedNextPriceExec.amountPaymentTokenForDepositLong.plus(
        amount
      );
    } else {
      batchedNextPriceExec.amountPaymentTokenForDepositShort = batchedNextPriceExec.amountPaymentTokenForDepositShort.plus(
        amount
      );
    }
  } else {
    if (isLong == MARKET_SIDE_LONG) {
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

export function doesBatchExist(
  marketIndex: BigInt,
  updateIndex: BigInt
): boolean {
  let batchedNextPriceExecId = generateBatchedNextPriceExecId(
    marketIndex,
    updateIndex
  );
  let batchedNextPriceExec = BatchedNextPriceExec.load(batchedNextPriceExecId);

  return batchedNextPriceExec != null;
}

export function createUserNextPriceActionComponent(
  user: User,
  syntheticMarket: SyntheticMarket,
  updateIndex: BigInt,
  amount: BigInt,
  actionType: string,
  isLong: bool,
  event: ethereum.Event
): UserNextPriceActionComponent {
  let actionIndex = 0;
  let hasntFoundUnititializedIndex = true;
  let userNextPriceActionComponentId = "";
  // The user can have multiple NextPriceActions, even within the same block or of the same type (long/shrt) - this increments the index until it finds an empty one.
  //        Unbounded here, but the impracticality (and blockchain limitations) of the user creating many thousands of actions means this code is ok.
  while (hasntFoundUnititializedIndex) {
    userNextPriceActionComponentId = generateUserNextPriceActionComponentId(
      user.address,
      syntheticMarket.marketIndex,
      updateIndex,
      actionType,
      actionIndex
    );
    let tempUserNextPriceActionComponent = UserNextPriceActionComponent.load(
      userNextPriceActionComponentId
    );
    hasntFoundUnititializedIndex = tempUserNextPriceActionComponent != null;
    ++actionIndex;
  }
  let userNextPriceActionComponent = new UserNextPriceActionComponent(
    userNextPriceActionComponentId
  );

  userNextPriceActionComponent.actionType = actionType;
  userNextPriceActionComponent.marketSide = isLong ? "Long" : "Short";
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

export function createUserNextPriceStakeActionComponent(
  userAddress: Bytes,
  marketIndex: BigInt,
  updateIndex: BigInt,
  amount: BigInt,
  actionType: string,
  isLong: bool,
  userAggregateActionId: string,
  batchAggregateActionId: string,
  event: ethereum.Event
): UserNextPriceStakeActionComponent {
  let actionIndex = 0;
  let hasntFoundUnititializedIndex = true;
  let userNextPriceActionComponentId = "";
  // The user can have multiple NextPriceActions, even within the same block or of the same type (long/shrt) - this increments the index until it finds an empty one.
  //        Unbounded here, but the impracticality (and blockchain limitations) of the user creating many thousands of actions means this code is ok.
  while (hasntFoundUnititializedIndex) {
    //TODO: Make this generate unique for this component instead of reusing createUserNextPriceStakeActionComponent

    //TODO: Refactor to avoid code duplication?
    userNextPriceActionComponentId = generateUserNextPriceActionComponentId(
      userAddress,
      marketIndex,
      updateIndex,
      actionType,
      actionIndex
    );
    let tempUserNextPriceActionComponent = UserNextPriceStakeActionComponent.load(
      userNextPriceActionComponentId
    );
    hasntFoundUnititializedIndex = tempUserNextPriceActionComponent != null;
    ++actionIndex;
  }
  let userNextPriceActionComponent = new UserNextPriceStakeActionComponent(
    userNextPriceActionComponentId
  );

  userNextPriceActionComponent.actionType = actionType;
  userNextPriceActionComponent.marketSide = isLong ? "Long" : "Short";
  userNextPriceActionComponent.amount = amount;
  userNextPriceActionComponent.timestamp = event.block.timestamp;
  userNextPriceActionComponent.user = userAddress.toHex();
  userNextPriceActionComponent.updateIndex = updateIndex;
  userNextPriceActionComponent.marketIndex = marketIndex;
  userNextPriceActionComponent.userAggregateAction = userAggregateActionId;
  userNextPriceActionComponent.associatedBatch = batchAggregateActionId;

  userNextPriceActionComponent.save();

  return userNextPriceActionComponent as UserNextPriceStakeActionComponent;
}

export function createOrUpdateUserNextPriceAction(
  userNextPriceActionComponent: UserNextPriceActionComponent,
  syntheticMarket: SyntheticMarket,
  user: User
): UserNextPriceAction {
  let userAddress = user.address;
  let marketIndex = userNextPriceActionComponent.marketIndex;
  let updateIndex = userNextPriceActionComponent.updateIndex;
  let associatedBatch = userNextPriceActionComponent.associatedBatch;
  let isLong = userNextPriceActionComponent.marketSide;
  let actionType = userNextPriceActionComponent.actionType;
  let amount = userNextPriceActionComponent.amount;

  let userNextPriceActionId = generateUserNextPriceActionId(
    userAddress,
    marketIndex,
    updateIndex
  );
  let result = getOrInitializeUserNextPriceAction(userNextPriceActionId);
  let userNextPriceAction = result.entity;
  if (result.wasCreated) {
    userNextPriceAction.updateIndex = updateIndex;
    userNextPriceAction.marketIndex = marketIndex;
    userNextPriceAction.user = user.id;
    userNextPriceAction.associatedBatch = associatedBatch;

    userNextPriceAction.save();

    syntheticMarket.nextPriceActions = syntheticMarket.nextPriceActions.concat([
      userNextPriceAction.id,
    ]);
    syntheticMarket.save();

    user.pendingNextPriceActions = user.pendingNextPriceActions.concat([
      userNextPriceAction.id,
    ]);

    // TODO: move this externally to its own getter (avoid even a remote change of race conditions)
    let usersCurrentNextPriceActionId = getUsersCurrentNextPriceActionId(
      userAddress,
      marketIndex
    );
    let usersCurrentNextPriceAction = UsersCurrentNextPriceAction.load(
      usersCurrentNextPriceActionId
    );
    if (usersCurrentNextPriceAction == null) {
      usersCurrentNextPriceAction = new UsersCurrentNextPriceAction(
        usersCurrentNextPriceActionId
      );
    }
    usersCurrentNextPriceAction.currentAction = userNextPriceAction.id;
    usersCurrentNextPriceAction.currentUpdateIndex = updateIndex;

    usersCurrentNextPriceAction.save();

    user.save();
  }
  userNextPriceAction.nextPriceActionComponents = userNextPriceAction.nextPriceActionComponents.concat(
    [userNextPriceActionComponent.id]
  );

  if (actionType == ACTION_MINT) {
    if (isLong == MARKET_SIDE_LONG) {
      userNextPriceAction.amountPaymentTokenForDepositLong = userNextPriceAction.amountPaymentTokenForDepositLong.plus(
        amount
      );
    } else {
      userNextPriceAction.amountPaymentTokenForDepositShort = userNextPriceAction.amountPaymentTokenForDepositShort.plus(
        amount
      );
    }
  } else if (actionType == ACTION_SHIFT) {
    if (isLong == MARKET_SIDE_LONG) {
      userNextPriceAction.amountSynthTokenForShiftFromLong = userNextPriceAction.amountSynthTokenForShiftFromLong.plus(
        amount
      );
    } else {
      userNextPriceAction.amountSynthTokenForShiftFromShort = userNextPriceAction.amountSynthTokenForShiftFromShort.plus(
        amount
      );
    }
  } else {
    if (isLong == MARKET_SIDE_LONG) {
      userNextPriceAction.amountSynthTokenForWithdrawalLong = userNextPriceAction.amountSynthTokenForWithdrawalLong.plus(
        amount
      );
    } else {
      userNextPriceAction.amountSynthTokenForWithdrawalLong = userNextPriceAction.amountSynthTokenForWithdrawalLong.plus(
        amount
      );
    }
  }

  return userNextPriceAction as UserNextPriceAction;
}
