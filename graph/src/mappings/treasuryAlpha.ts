import { BasePriceUpdated } from "../../generated/TreasuryAlpha/TreasuryAlpha";

import { GlobalState } from "../../generated/schema";

import { GLOBAL_STATE_ID } from "../CONSTANTS";

import {
  getOrCreateGlobalState,
} from "../utils/globalStateManager";

import { log } from "@graphprotocol/graph-ts";

export function handleBasePriceUpdated(event: BasePriceUpdated): void {
  // handle the event
  log.warning("HERE WE ARE",[]);
  let basePrice = event.params.newBasePrice;
  log.warning("Log this {}", [basePrice.toString()]);

  let globalState = getOrCreateGlobalState();

  globalState.treasuryBasePrice = basePrice;

  globalState.save();
}
