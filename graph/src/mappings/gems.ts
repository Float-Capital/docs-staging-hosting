import { GemsCollected } from "../../generated/GEMS/GEMS";

import { saveEventToStateChange } from "../utils/txEventHelpers";

import {
  getOrInitializeUser,
  getOrInitializeGems,
} from "../generated/EntityHelpers";
import { getOrCreateUser } from "../utils/globalStateManager";

export function handleGemsCollected(event: GemsCollected): void {
  let userParam = event.params.user;
  let gemsParam = event.params.gems;
  let streak = event.params.streak;

  let gemsLoad = getOrInitializeGems(userParam.toHex());
  let gems = gemsLoad.entity;

  gems.balance = gemsParam;
  gems.streak = streak;
  gems.lastUpdated = event.block.timestamp;

  gems.save();

  let user = getOrCreateUser(userParam, event);

  user.gems = gems.id;

  user.save();

  saveEventToStateChange(
    event,
    "GemsCollected",
    [userParam.toHex(), gemsParam.toString(), streak.toString()],
    ["user", "gems", "streak"],
    ["address", "uint256", "uint256"],
    [userParam],
    []
  );
}
