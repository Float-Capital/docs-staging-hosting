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
export let HALF_DAY_IN_SECONDS = BigInt.fromI32(43200);
export let ONE_DAY_IN_SECONDS = BigInt.fromI32(86400);
export let THREE_DAYS_IN_SECONDS = BigInt.fromI32(259200);
export let ONE_WEEK_IN_SECONDS = BigInt.fromI32(604800);
export let TWO_WEEKS_IN_SECONDS = BigInt.fromI32(1209600);
export let ONE_MONTH_IN_SECONDS = BigInt.fromI32(2628029); // Assuming a month has ~30.417 days in it on average
export let FLOAT_ISSUANCE_FIXED_DECIMAL = BigInt.fromString(
  "1000000000000000000000000000000000000000000"
);

export let PRICE_HISTORY_INTERVALS: BigInt[] = [
  FIVE_MINUTES_IN_SECONDS,
  ONE_HOUR_IN_SECONDS,
  HALF_DAY_IN_SECONDS,
  ONE_DAY_IN_SECONDS,
  THREE_DAYS_IN_SECONDS,
  ONE_WEEK_IN_SECONDS,
  TWO_WEEKS_IN_SECONDS,
  ONE_MONTH_IN_SECONDS,
];

export let MARKET_SIDE_LONG: string = "Long";
export let MARKET_SIDE_SHORT: string = "Short";
export let ACTION_SHIFT: string = "Shift";
export let ACTION_MINT: string = "Mint";
export let ACTION_REDEEM: string = "Redeem";
