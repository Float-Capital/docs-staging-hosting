/*╔════════════════════════════════════════════════════════════════════════════════════════╗
  ║  This file contains hepler functions that define canonical way te generate entity IDs  ║
  ╚════════════════════════════════════════════════════════════════════════════════════════╝*/

import { BigInt, Bytes } from "@graphprotocol/graph-ts";

export function generateSystemStateId(
  marketIndex: BigInt,
  txHash: Bytes
): string {
  return `${marketIndex.toString()}-${txHash.toHex()}`;
}
