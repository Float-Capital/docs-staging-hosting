import {
  Approval,
  Transfer as TransferEvent,
} from "../generated/templates/erc20/erc20";
import {
  CollateralToken,
  CollateralTransfer,
  GlobalState,
  SyntheticToken,
  Transfer,
  User,
  TokenApproval,
  UserCollateralTokenApproval,
} from "../generated/schema";
import { log, dataSource, BigInt, ethereum } from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";
import {
  updateBalanceTransfer,
  updateBalanceFloatTransfer,
  updateCollatoralBalanceTransfer,
} from "./utils/helperFunctions";
import { GLOBAL_STATE_ID } from "./CONSTANTS";
import { getOrCreateUser } from "./utils/globalStateManager";

export function handleTransfer(event: TransferEvent): void {
  let fromAddress = event.params.from;
  let fromAddressString = fromAddress.toHex();
  let toAddress = event.params.to;
  let toAddressString = toAddress.toHex();
  let amount = event.params.value;

  let context = dataSource.context();
  let tokenAddressString = context.getString("contractAddress");
  let isFloatToken = context.getBoolean("isFloatToken");

  if (isFloatToken) {
    updateBalanceFloatTransfer(fromAddress, amount, true, event);
    updateBalanceFloatTransfer(toAddress, amount, false, event);
  } else {
    let syntheticToken = SyntheticToken.load(tokenAddressString);
    let collateralToken = CollateralToken.load(tokenAddressString);
    if (syntheticToken == null && collateralToken == null) {
      log.critical(
        "Token should be defined as either a synthetic token or a collateral token",
        []
      );
    }

    if (syntheticToken != null) {
      let transactionHash = event.transaction.hash.toHex();
      let transfer = new Transfer(transactionHash + "-" + syntheticToken.id);
      transfer.from = fromAddressString;
      transfer.to = toAddressString;
      transfer.value = amount;
      transfer.token = syntheticToken.id;
      transfer.save();

      updateBalanceTransfer(
        tokenAddressString,
        fromAddress,
        amount,
        true,
        event
      );
      updateBalanceTransfer(
        tokenAddressString,
        toAddress,
        amount,
        false,
        event
      );
    } else if (collateralToken != null) {
      let transactionHash = event.transaction.hash.toHex();
      let transfer = new CollateralTransfer(
        transactionHash + "-" + collateralToken.id
      );
      transfer.from = fromAddressString;
      transfer.to = toAddressString;
      transfer.value = amount;
      transfer.token = collateralToken.id;
      transfer.save();

      if (User.load(fromAddressString) != null) {
        updateCollatoralBalanceTransfer(
          tokenAddressString,
          fromAddress,
          amount,
          true,
          event
        );
      }
      if (User.load(toAddressString) != null) {
        updateCollatoralBalanceTransfer(
          tokenAddressString,
          toAddress,
          amount,
          false,
          event
        );
      }
    }
  }

  saveEventToStateChange(
    event,
    "Transfer",
    [fromAddressString, toAddressString, amount.toString()],
    ["from", "to", "amount"],
    ["address", "address", "uint256"],
    [fromAddress, toAddress],
    []
  );
}

function createApproval(
  collateralToken: CollateralToken | null,
  user: User,
  approved: BigInt,
  event: ethereum.Event
): TokenApproval {
  let id =
    "approval-" + collateralToken.id + "-" + event.transaction.hash.toHex();
  let tokenApproval = new TokenApproval(id);
  tokenApproval.collateralToken = collateralToken.id;
  tokenApproval.user = user.id;
  tokenApproval.approved = approved;
  tokenApproval.timestamp = event.block.timestamp;
  return tokenApproval as TokenApproval;
}

function createOrUpdateUserCollateralApproval(
  tokenApproval: TokenApproval,
  user: User,
  event: ethereum.Event
): UserCollateralTokenApproval {
  let id = user.id + "-" + tokenApproval.collateralToken;

  let userCollateral = UserCollateralTokenApproval.load(id);
  if (userCollateral == null) {
    userCollateral = new UserCollateralTokenApproval(id);
    userCollateral.approvalsHistory = [];
    user.collatoralTokenApprovals = user.collatoralTokenApprovals.concat([
      userCollateral.id,
    ]);
    user.save();
  }
  userCollateral.updateTimestamp = event.block.timestamp;
  userCollateral.currentApproval = tokenApproval.id;
  userCollateral.updateTimestamp = tokenApproval.timestamp;

  return userCollateral as UserCollateralTokenApproval;
}

export function handleApproval(event: Approval): void {
  let spender = event.params.spender;
  let spenderAddressString = spender.toHex();

  let globalState = GlobalState.load(GLOBAL_STATE_ID);

  let tokenAddressString = event.address.toHex();
  let collateralToken = CollateralToken.load(tokenAddressString);
  if (collateralToken != null) {
    if (globalState != null && spenderAddressString == globalState.longShort) {
      let owner = event.params.owner;
      let ownerAddressString = owner.toHex();
      let value = event.params.value;

      let user = getOrCreateUser(owner, event);

      let tokenApproval = createApproval(collateralToken, user, value, event);

      let userTokenApproval = createOrUpdateUserCollateralApproval(
        tokenApproval,
        user,
        event
      );

      tokenApproval.save();
      userTokenApproval.save();

      saveEventToStateChange(
        event,
        "Approval",
        [ownerAddressString, spenderAddressString, value.toString()],
        ["owner", "spender", "value"],
        ["address", "address", "uint256"],
        [owner],
        []
      );
    }
  }
}
