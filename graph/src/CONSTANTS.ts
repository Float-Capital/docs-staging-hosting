import { BigInt } from "@graphprotocol/graph-ts";

export const GLOBAL_STATE_ID = "globalState";
export const ORACLE_AGREGATOR_ID = "oracleAgregator";
export const YIELD_MANAGER_ID = "yieldManager";
export const STAKER_ID = "staker";
export const TOKEN_FACTORY_ID = "tokenFactory";
export const LONG_SHORT_ID = "longShort";

export let ZERO = BigInt.fromI32(0);
export let BILLION = BigInt.fromI32(1000000000); // 10^9
export let TEN_TO_THE_18 = BILLION.times(BILLION);
