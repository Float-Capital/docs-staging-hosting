import {
  Approval,
  Transfer as TransferEvent,
} from "../generated/templates/erc20/erc20";
import {
  PaymentToken,
  PaymentTokenTransfer,
  GlobalState,
  SyntheticToken,
  Transfer,
  User,
  TokenApproval,
  UserPaymentTokenApproval,
  LongShortContract,
} from "../generated/schema";
import {
  log,
  dataSource,
  BigInt,
  ethereum,
  Address,
  Bytes,
} from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";
import {
  updateBalanceTransfer,
  updateBalanceFloatTransfer,
  updateCollatoralBalanceTransfer,
} from "./utils/helperFunctions";
import { GLOBAL_STATE_ID, ONE, ZERO, ZERO_ADDRESS } from "./CONSTANTS";
import { getOrCreateUser } from "./utils/globalStateManager";

function saveTransferToStateChange(
  event: TransferEvent,
  paramValues: Array<string>,
  affectedUsers: Array<Bytes>,
  toFloatContracts: bool = true
): void {
  saveEventToStateChange(
    event,
    "Transfer",
    paramValues,
    ["from", "to", "amount"],
    ["address", "address", "uint256"],
    affectedUsers,
    [],
    toFloatContracts
  );
}

export function handleTransfer(event: TransferEvent): void {
  let fromAddress = event.params.from;
  let fromAddressString = fromAddress.toHex();
  let toAddress = event.params.to;
  let toAddressString = toAddress.toHex();
  let amount = event.params.value;

  let stateChangeParams: Array<string> = [
    fromAddressString,
    toAddressString,
    amount.toString(),
  ];
  let bothUsers: Array<Bytes> = [fromAddress, toAddress];

  let context = dataSource.context();
  let tokenAddressString = context.getString("contractAddress");
  let isFloatToken = context.getBoolean("isFloatToken");

  if (isFloatToken) {
    updateBalanceFloatTransfer(fromAddress, amount, true, event);
    updateBalanceFloatTransfer(toAddress, amount, false, event);
    if(toAddressString == ZERO_ADDRESS){
      // token burn
      let globalState = GlobalState.load(GLOBAL_STATE_ID);
      if(globalState != null){
        globalState.totalFloatMinted = globalState.totalFloatMinted.minus(amount);
        globalState.save();
      }
    }
    saveTransferToStateChange(event, stateChangeParams, bothUsers);
  } else {
    let syntheticToken = SyntheticToken.load(tokenAddressString);
    let paymentToken = PaymentToken.load(tokenAddressString);
    if (syntheticToken == null && paymentToken == null) {
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
      saveTransferToStateChange(event, stateChangeParams, bothUsers);
    } else if (paymentToken != null) {
      let transactionHash = event.transaction.hash.toHex();
      let transfer = new PaymentTokenTransfer(
        transactionHash + "-" + paymentToken.id
      );
      transfer.from = fromAddressString;
      transfer.to = toAddressString;
      transfer.value = amount;
      transfer.token = paymentToken.id;
      transfer.save();

      let affectedUsers = new Array<Bytes>(0);

      if (User.load(fromAddressString) != null) {
        updateCollatoralBalanceTransfer(
          tokenAddressString,
          fromAddress,
          amount,
          true,
          event
        );
        affectedUsers.push(fromAddress);
      }
      if (User.load(toAddressString) != null) {
        updateCollatoralBalanceTransfer(
          tokenAddressString,
          toAddress,
          amount,
          false,
          event
        );
        affectedUsers.push(toAddress);
      }
      if (affectedUsers.length != 0) {
        saveTransferToStateChange(
          event,
          stateChangeParams,
          affectedUsers,
          false
        );
      }
    }
  }
}

function createApproval(
  paymentToken: PaymentToken | null,
  user: User,
  approved: BigInt,
  event: ethereum.Event
): TokenApproval {
  let id = "approval-" + paymentToken.id + "-" + event.transaction.hash.toHex();
  let tokenApproval = new TokenApproval(id);
  tokenApproval.paymentToken = paymentToken.id;
  tokenApproval.user = user.id;
  tokenApproval.approvedInnacurate = approved;
  tokenApproval.timestamp = event.block.timestamp;
  return tokenApproval as TokenApproval;
}

function createOrUpdateUserCollateralApproval(
  tokenApproval: TokenApproval,
  user: User,
  event: ethereum.Event
): UserPaymentTokenApproval {
  let id = user.id + "-" + tokenApproval.paymentToken;

  let userCollateral = UserPaymentTokenApproval.load(id);
  if (userCollateral == null) {
    userCollateral = new UserPaymentTokenApproval(id);
    userCollateral.approvalsHistory = [];
    user.collatoralTokenApprovals = user.collatoralTokenApprovals.concat([
      userCollateral.id,
    ]);
    user.save();
  }
  userCollateral.updateTimestamp = event.block.timestamp;
  userCollateral.paymentToken = tokenApproval.paymentToken;
  userCollateral.currentApproval = tokenApproval.id;
  userCollateral.updateTimestamp = tokenApproval.timestamp;

  return userCollateral as UserPaymentTokenApproval;
}

export function decreaseOrCreateUserApprovals(
  userAddress: Address,
  amount: BigInt,
  paymentToken: PaymentToken | null,
  event: ethereum.Event
): void {
  let user = getOrCreateUser(userAddress, event);
  let collateralApproval = UserPaymentTokenApproval.load(
    user.id + "-" + paymentToken.id
  );
  let currentApproval: TokenApproval | null = null;
  if (collateralApproval != null)
    currentApproval = TokenApproval.load(collateralApproval.currentApproval);

  let newApproval: TokenApproval;
  if (currentApproval != null) {
    newApproval = createApproval(
      paymentToken,
      user,
      currentApproval.approvedInnacurate.minus(amount),
      event
    );
  } else {
    newApproval = createApproval(paymentToken, user, ZERO, event);
  }
  let updatedCollateral = createOrUpdateUserCollateralApproval(
    newApproval,
    user,
    event
  );
  newApproval.save();
  updatedCollateral.save();
}

export function handleApproval(event: Approval): void {
  let spender = event.params.spender;
  let spenderAddressString = spender.toHex();

  let globalState = GlobalState.load(GLOBAL_STATE_ID);

  let tokenAddressString = event.address.toHex();
  let paymentToken = PaymentToken.load(tokenAddressString);
  if (paymentToken != null) {
    if (globalState != null) {
      let longShort = LongShortContract.load(globalState.longShort);
      if (longShort.address.toHex() != spenderAddressString) return;
      let owner = event.params.owner;
      let ownerAddressString = owner.toHex();
      let value = event.params.value;

      let user = getOrCreateUser(owner, event);

      let tokenApproval = createApproval(paymentToken, user, value, event);

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
        [],
        false
      );
    }
  }
}
