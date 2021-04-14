import { SyntheticTokenCreated } from "../generated-price-history/LongShort/LongShort";
import { OracleManager } from "../generated-price-history/templates/OracleManager/OracleManager";
import {
  Global,
  Oracle,
  FiveMinPrice,
} from "../generated-price-history/schema";
import { Address, BigInt, ethereum, log } from "@graphprotocol/graph-ts";
import { ONE, FIVE_MINUTES_IN_SECONDS } from "./CONSTANTS";

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
  oracle.address = oracleAddress;
  oracle.marketIndex = marketIndex;
  oracle.marketName = marketName;
  oracle.marketSymbol = marketSymbol;
  oracle.latestPrice = initialFiveMinPrice.startPrice;
  oracle.fiveMinPrices = [];
  oracle.latestFiveMinPrice = initialFiveMinPrice.id;

  return oracle as Oracle;
}

export function createFiveMinPrice(
  timestamp: BigInt,
  oracleAddressStr: string,
  currentOraclePrice: BigInt
): FiveMinPrice {
  let intervalIndex = timestamp.div(FIVE_MINUTES_IN_SECONDS);
  let fiveMinPrice = new FiveMinPrice(
    oracleAddressStr + "-" + intervalIndex.toString()
  );

  fiveMinPrice.intervalIndex = intervalIndex;
  fiveMinPrice.startPrice = currentOraclePrice;
  fiveMinPrice.endPrice = currentOraclePrice;
  fiveMinPrice.averagePrice = currentOraclePrice;
  fiveMinPrice.intervalComplete = false;
  fiveMinPrice.numberOfBlocksInInterval = ONE;
  fiveMinPrice.oracle = oracleAddressStr;

  return fiveMinPrice as FiveMinPrice;
}

function getLatestOraclePrice(oracleAddress: Address): BigInt {
  let oracleInstance = OracleManager.bind(oracleAddress);

  let latestPriceQuery = oracleInstance.try_updatePrice();
  if (latestPriceQuery.reverted) {
    log.warning(
      "Unable to get latest price from oracle manager at {}. Please check the ABI is correct",
      [oracleAddress.toHex()]
    );
  }

  return latestPriceQuery.value;
}

export function handleSyntheticTokenCreated(
  event: SyntheticTokenCreated
): void {
  let marketIndex = event.params.marketIndex;
  let timestamp = event.block.timestamp;

  let oracleAddress = event.params.oracleAddress;
  let oracleAddressStr = oracleAddress.toHex();
  let marketName = event.params.name;
  let marketSymbol = event.params.symbol;

  let state = getOrCreateGlobalState();

  let currentOraclePrice = getLatestOraclePrice(oracleAddress);

  let fiveMinPrice = createFiveMinPrice(
    timestamp,
    oracleAddressStr,
    currentOraclePrice
  );

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
  let state = getOrCreateGlobalState();
  let timestamp = block.timestamp;

  let allOracles = state.oracles;
  log.warning("Block", []);
  for (let i = 0; i < allOracles.length; ++i) {
    let curentOracleId = allOracles[i];
    log.warning("Oracle {}", [curentOracleId]);
    let oracle = Oracle.load(curentOracleId);
    if (oracle == null) {
      log.critical("Oracle with address {} is undefined", [curentOracleId]);
    }

    let latestFiveMinPrice = FiveMinPrice.load(oracle.latestFiveMinPrice);
    if (latestFiveMinPrice == null) {
      log.critical("The latest 5 minute price is undefined", [curentOracleId]);
    }

    let currentOraclePrice = getLatestOraclePrice(oracle.address as Address);

    oracle.latestPrice = currentOraclePrice;

    // FIVE_MINUTES_IN_SECONDS;
    let currentPriceIndex = timestamp.div(FIVE_MINUTES_IN_SECONDS);
    log.warning("currentPriceIndex {} == {}", [
      currentPriceIndex.toString(),
      latestFiveMinPrice.intervalIndex.toString(),
    ]);
    if (currentPriceIndex.equals(latestFiveMinPrice.intervalIndex)) {
      log.warning("Updating", []);

      let newNumberOfBlocksInInterval = latestFiveMinPrice.numberOfBlocksInInterval.plus(
        ONE
      );
      latestFiveMinPrice.endPrice = currentOraclePrice;
      latestFiveMinPrice.averagePrice = latestFiveMinPrice.averagePrice
        .times(latestFiveMinPrice.numberOfBlocksInInterval)
        .plus(currentOraclePrice)
        .div(newNumberOfBlocksInInterval);
      latestFiveMinPrice.numberOfBlocksInInterval = newNumberOfBlocksInInterval;
      latestFiveMinPrice.intervalComplete = false;

      latestFiveMinPrice.save();
    } else {
      log.warning("creating new!", []);
      let fiveMinPrice = createFiveMinPrice(
        timestamp,
        oracle.id,
        currentOraclePrice
      );
      oracle.fiveMinPrices = oracle.fiveMinPrices.concat([fiveMinPrice.id]);
      oracle.latestFiveMinPrice = fiveMinPrice.id;

      fiveMinPrice.save();
    }

    oracle.save();
  }
}
