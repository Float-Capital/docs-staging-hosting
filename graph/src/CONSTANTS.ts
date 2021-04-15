import { BigInt, Address } from "@graphprotocol/graph-ts";

export const GLOBAL_STATE_ID = "globalState";
export const ORACLE_AGREGATOR_ID = "oracleAgregator";
export const YIELD_MANAGER_ID = "yieldManager";
export const STAKER_ID = "staker";
export const TOKEN_FACTORY_ID = "tokenFactory";
export const LONG_SHORT_ID = "longShort";
export const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
export let ZERO_ADDRESS_BYTES = Address.fromString(
  "0x0000000000000000000000000000000000000000"
);

export let ZERO = BigInt.fromI32(0);
export let ONE = BigInt.fromI32(1);
export let BILLION = BigInt.fromI32(1000000000); // 10^9
export let TEN_TO_THE_18 = BILLION.times(BILLION);

export let FIVE_MINUTES_IN_SECONDS = BigInt.fromI32(300);
export let ONE_HOUR_IN_SECONDS = BigInt.fromI32(3600);
export let ONE_DAY_IN_SECONDS = BigInt.fromI32(86400);
export let ONE_WEEK_IN_SECONDS = BigInt.fromI32(604800);
export let ONE_MONTH_IN_SECONDS = BigInt.fromI32(2628029); // Assuming a month has ~30.417 days in it on average
export let PRICE_HISTORY_INTERVALS: BigInt[] = [
  FIVE_MINUTES_IN_SECONDS,
  ONE_HOUR_IN_SECONDS,
  ONE_DAY_IN_SECONDS,
  ONE_WEEK_IN_SECONDS,
  ONE_MONTH_IN_SECONDS,
];
