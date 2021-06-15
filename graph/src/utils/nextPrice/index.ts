import {
  BatchedNextPriceExec,
  NextBatchedNextPriceExec,
  SyntheticMarket,
  User,
  UserNextPriceAction,
} from "../../../generated/schema";
import { BigInt } from "@graphprotocol/graph-ts";
import { ZERO } from "../../CONSTANTS";

export function getOrCreateBatchedNextPriceExec(
  marketIndex: BigInt,
  updateIndex: BigInt
): BatchedNextPriceExec {
  let marketIndexId = marketIndex.toString();
  let updateIndexStr = updateIndex.toString();
  let batchedNextPriceExecId =
    "batched-" + marketIndexId + "-" + updateIndexStr;
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
    let nextBatchedNextPriceExecId = "nextBatch-" + marketIndexId;
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

  return batchedNextPriceExec as BatchedNextPriceExec;
}

export function createOrUpdateUserNextPriceAction(
  user: User,
  syntheticMarket: SyntheticMarket,
  updateIndex: BigInt,
  associatedBatch: BatchedNextPriceExec
): UserNextPriceAction {
  let userNextPriceActionId =
    "nextPrice-" +
    user.id +
    "-" +
    syntheticMarket.marketIndex.toString() +
    "-" +
    updateIndex.toString();
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
