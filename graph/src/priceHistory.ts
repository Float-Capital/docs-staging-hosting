import { SyntheticTokenCreated } from "../generated-price-history/LongShort/LongShort";
import { OracleManager } from "../generated-price-history/templates/OracleManager/OracleManager";
import {
  Global,
  Oracle,
  FiveMinPrice,
} from "../generated-price-history/schema";
import { Address, BigInt, ethereum, log } from "@graphprotocol/graph-ts";
import { ONE, ZERO } from "./CONSTANTS";
export function getOrCreateGlobalState(): Global {
  let globalState = Global.load("GLOBAL");
  if (globalState == null) {
    globalState = new Global("GLOBAL");
    globalState.oracles = [];
  }

  return globalState as Global;
}

export function createOracle(
  oracleAddress: Address,
  marketIndex: BigInt,
  marketName: string,
  marketSymbol: string,
  initialFiveMinPrice: FiveMinPrice
): Oracle {
  let oracle = new Oracle(oracleAddress.toHex());
  oracle.marketIndex = marketIndex;
  oracle.marketName = marketName;
  oracle.marketSymbol = marketSymbol;
  oracle.latestPrice = initialFiveMinPrice.startPrice;
  oracle.fiveMinPrices = [];
  oracle.latestFiveMinPrice = initialFiveMinPrice.id;

  return oracle as Oracle;
}

export function handleSyntheticTokenCreated(
  event: SyntheticTokenCreated
): void {
  let marketIndex = event.params.marketIndex;

  let oracleAddress = event.params.oracleAddress;
  let oracleAddressStr = oracleAddress.toHex();
  let marketName = event.params.name;
  let marketSymbol = event.params.symbol;

  let marketIndexString = marketIndex.toString();

  let state = getOrCreateGlobalState();

  let oracleInstance = OracleManager.bind(oracleAddress);

  let latestPriceQuery = oracleInstance.try_updatePrice();
  if (latestPriceQuery.reverted) {
    log.warning(
      "Unable to get latest price from oracle manager at {}. Please check the ABI is correct",
      [oracleAddressStr]
    );
  }

  let currentOraclePrice = latestPriceQuery.value;

  let fiveMinPrice = new FiveMinPrice(oracleAddressStr + "-0");

  fiveMinPrice.startPrice = currentOraclePrice;
  fiveMinPrice.endPrice = currentOraclePrice;
  fiveMinPrice.averagePrice = currentOraclePrice;
  fiveMinPrice.intervalComplete = false;
  fiveMinPrice.numberOfBlocksInInterval = ONE;

  let oracle = createOracle(
    oracleAddress,
    marketIndex,
    marketName,
    marketSymbol,
    fiveMinPrice
  );

  state.oracles = state.oracles.concat([oracle.id]);

  state.save();
  oracle.save();
  fiveMinPrice.save();
}

export function handleBlock(block: ethereum.Block): void {
  log.warning("New block", []);
}
