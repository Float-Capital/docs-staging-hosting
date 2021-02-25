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
import { ZERO } from "../CONSTANTS";

export function createNewTokenDataSource(address: Address): void {
  let context = new DataSourceContext();
  context.setString("contractAddress", address.toHex());
  erc20.createWithContext(address, context);
}
