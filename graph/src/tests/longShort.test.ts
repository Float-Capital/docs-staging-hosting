import {
  addMetadata,
  assert,
  createMockedFunction,
  clearStore,
  test,
} from "matchstick-as/assembly/index";
import { log } from "matchstick-as/assembly/log";
import {
  Address,
  BigInt,
  Bytes,
  ethereum,
  store,
  Value,
} from "@graphprotocol/graph-ts";
// import {  } from "../../generated/schema";
import {
  LongShortV1,
  SyntheticMarketCreated,
  SystemStateUpdated,
  OracleUpdated,
  NextPriceDeposit,
  NewMarketLaunchedAndSeeded,
  NextPriceRedeem,
  ExecuteNextPriceSettlementsUser,
  ExecuteNextPriceRedeemSettlementUser,
  ExecuteNextPriceMintSettlementUser,
} from "../../generated/LongShort/LongShort";
import { createLongShortV1Event } from "./generated/LongShortHelpers";

/// TODO: add metadata to events
// let base: ethereum.Event = new LongShortV1();
// let newLongShortV1Event = addMetadata(base) as LongShortV1;

export function runTests(): void {
  test("Example test that test that you can create an event and it has all the correct parameters", () => {
    let admin = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    );
    let tokenFactory = Address.fromString(
      "0x0000000000000000000000000000000000000003"
    );
    let staker = Address.fromString(
      "0x0000000000000000000000000000000000000004"
    );
    let longShortEvent = createLongShortV1Event(admin, tokenFactory, staker);

    assert.equals(
      ethereum.Value.fromAddress(longShortEvent.params.admin),
      ethereum.Value.fromAddress(admin)
    );
    assert.equals(
      ethereum.Value.fromAddress(longShortEvent.params.tokenFactory),
      ethereum.Value.fromAddress(tokenFactory)
    );
    assert.equals(
      ethereum.Value.fromAddress(longShortEvent.params.staker),
      ethereum.Value.fromAddress(staker)
    );
  });
}
