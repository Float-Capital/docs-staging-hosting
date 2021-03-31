import { Transfer as TransferEvent } from "../generated/templates/erc20/erc20";
import { SyntheticToken, Transfer } from "../generated/schema";
import { log, dataSource } from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";
import {
  updateBalanceTransfer,
  updateBalanceFloatTransfer,
} from "./utils/helperFunctions";

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
    if (syntheticToken == null) {
      log.critical("Token should be defined", []);
    }

    let transactionHash = event.transaction.hash.toHex();
    let transfer = new Transfer(transactionHash);
    transfer.from = fromAddressString;
    transfer.to = toAddressString;
    transfer.value = amount;
    transfer.token = syntheticToken.id;
    transfer.save();

    updateBalanceTransfer(tokenAddressString, fromAddress, amount, true, event);
    updateBalanceTransfer(tokenAddressString, toAddress, amount, false, event);
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
