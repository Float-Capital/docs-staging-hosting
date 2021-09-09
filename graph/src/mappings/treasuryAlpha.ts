import { BasePriceUpdated } from "../../generated/TreasuryAlpha/TreasuryAlpha";

import {
  getOrCreateGlobalState,
} from "../utils/globalStateManager";

import {
  bigIntArrayToStringArray,
  saveEventToStateChange,
} from "../utils/txEventHelpers";

export function handleBasePriceUpdated(event: BasePriceUpdated): void {
  let basePrice = event.params.newBasePrice;

  let globalState = getOrCreateGlobalState();

  globalState.treasuryBasePrice = basePrice;

  globalState.save();

  saveEventToStateChange(
    event,
    "BasePriceUpdated",
    bigIntArrayToStringArray([
      basePrice,
    ]),
    ["newBasePrice"],
    ["uint256"],
    [],
    []
  );
}
