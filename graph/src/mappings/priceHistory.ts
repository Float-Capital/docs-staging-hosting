import {
  SyntheticMarketCreated,
  OracleUpdated,
} from "../../generated-price-history/LongShort/LongShort";
import { OracleManager } from "../../generated-price-history/templates/OracleManager/OracleManager";
import {
  Global,
  Oracle,
  PriceInterval,
  PriceIntervalManager,
} from "../../generated-price-history/schema";
import { Address, BigInt, ethereum, log } from "@graphprotocol/graph-ts";
import { ONE, PRICE_HISTORY_INTERVALS } from "../CONSTANTS";

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
  latestPrice: BigInt,
  blockTimestamp: BigInt
): Oracle {
  let oracle = new Oracle(oracleAddress.toHex());
  oracle.address = oracleAddress;
  oracle.marketIndex = marketIndex;
  oracle.marketName = marketName;
  oracle.marketSymbol = marketSymbol;
  oracle.latestPrice = latestPrice;
  oracle.lastUpdatedTimestamp = blockTimestamp;
  oracle.active = true;
  oracle.priceIntervals = [];

  return oracle as Oracle;
}

export function updateOracle(
  oldOracleAddress: Address,
  newOracleAddress: Address
): Oracle {
  let prevOracle = Oracle.load(oldOracleAddress.toHexString());
  prevOracle.active = false;
  prevOracle.save();

  let oracle = new Oracle(newOracleAddress.toHex());
  oracle.address = newOracleAddress;
  oracle.marketIndex = prevOracle.marketIndex;
  oracle.marketName = prevOracle.marketName;
  oracle.marketSymbol = prevOracle.marketSymbol;
  oracle.latestPrice = prevOracle.latestPrice;
  oracle.lastUpdatedTimestamp = prevOracle.lastUpdatedTimestamp;
  oracle.active = true;
  oracle.priceIntervals = prevOracle.priceIntervals;

  return oracle as Oracle;
}

export function createPriceInterval(
  timestamp: BigInt,
  oracleAddressStr: string,
  intervalLength: BigInt,
  currentOraclePrice: BigInt
): PriceInterval {
  let intervalIndex = timestamp.div(intervalLength);
  let priceHistory = new PriceInterval(
    oracleAddressStr +
      "-" +
      intervalLength.toString() +
      "-" +
      intervalIndex.toString()
  );

  priceHistory.intervalIndex = intervalIndex;
  priceHistory.intervalLength = intervalLength;
  priceHistory.startTimestamp = intervalIndex.times(intervalLength);
  priceHistory.startPrice = currentOraclePrice;
  priceHistory.endPrice = currentOraclePrice;
  priceHistory.averagePrice = currentOraclePrice;
  priceHistory.intervalComplete = false;
  priceHistory.numberOfBlocksInInterval = ONE;
  priceHistory.oracle = oracleAddressStr;

  return priceHistory as PriceInterval;
}

export function createPriceIntervalManager(
  oracleAddressStr: string,
  intervalLength: BigInt,
  initialPriceInterval: PriceInterval
): PriceIntervalManager {
  let priceHistoryManager = new PriceIntervalManager(
    oracleAddressStr + "-" + intervalLength.toString()
  );

  priceHistoryManager.oracle = oracleAddressStr;
  priceHistoryManager.intervalLength = intervalLength;
  priceHistoryManager.latestPriceInterval = initialPriceInterval.id;
  priceHistoryManager.prices = [initialPriceInterval.id];

  return priceHistoryManager as PriceIntervalManager;
}

function getLatestOraclePrice(oracleAddress: Address): BigInt {
  let oracleInstance = OracleManager.bind(oracleAddress);

  let latestPriceQuery = oracleInstance.try_updatePrice();
  if (latestPriceQuery.reverted) {
    log.critical(
      "Unable to get latest price from oracle manager at {}. Please check the ABI is correct",
      [oracleAddress.toHex()]
    );
  }

  return latestPriceQuery.value;
}

export function handleSyntheticMarketCreated(
  event: SyntheticMarketCreated
): void {
  let marketIndex = event.params.marketIndex;
  let timestamp = event.block.timestamp;

  let oracleAddress = event.params.oracleAddress;
  let oracleAddressStr = oracleAddress.toHex();
  let marketName = event.params.name;
  let marketSymbol = event.params.symbol;

  let state = getOrCreateGlobalState();

  let currentOraclePrice = getLatestOraclePrice(oracleAddress);

  let oracle = createOracle(
    oracleAddress,
    marketIndex,
    marketName,
    marketSymbol,
    currentOraclePrice,
    timestamp
  );

  for (let i = 0; i < PRICE_HISTORY_INTERVALS.length; ++i) {
    let interval = PRICE_HISTORY_INTERVALS[i];
    let initialPriceInterval = createPriceInterval(
      timestamp,
      oracleAddressStr,
      interval,
      currentOraclePrice
    );
    let priceIntervalManager = createPriceIntervalManager(
      oracleAddressStr,
      interval,
      initialPriceInterval
    );

    priceIntervalManager.prices = priceIntervalManager.prices.concat([
      initialPriceInterval.id,
    ]);
    oracle.priceIntervals = oracle.priceIntervals.concat([
      priceIntervalManager.id,
    ]);

    priceIntervalManager.save();
    initialPriceInterval.save();
  }

  state.oracles = state.oracles.concat([oracle.id]);

  state.save();
  oracle.save();
}

export function handleMarketOracleUpdated(event: OracleUpdated): void {
  let state = getOrCreateGlobalState();
  let oldOracleAddress = event.params.oldOracleAddress;
  let newOracleAddress = event.params.newOracleAddress;
  let oracle = updateOracle(oldOracleAddress, newOracleAddress);
  oracle.save();

  let stateOracles = state.oracles;
  stateOracles.push(oracle.id);
  state.oracles = stateOracles;

  state.save();
}

export function handleBlock(block: ethereum.Block): void {
  let state = getOrCreateGlobalState();
  let timestamp = block.timestamp;

  // To make this subgraph a bit more efficient (hacky interim solution) only run on every 6th block (every 12 seconds)
  if (block.number.toI32() % 6 != 0) {
    return;
  }

  let allOracles = state.oracles;
  for (let i = 0; i < allOracles.length; ++i) {
    let currentOracleId = allOracles[i];
    let oracle = Oracle.load(currentOracleId);
    if (oracle == null) {
      log.critical("Oracle with address {} is undefined", [currentOracleId]);
    }
    if (oracle.active == true) {
      let oraclePriceIntervals = oracle.priceIntervals;
      for (let i = 0; i < oraclePriceIntervals.length; ++i) {
        let currentPriceIntervalManagerId = oraclePriceIntervals[i];
        let priceIntervalManager = PriceIntervalManager.load(
          currentPriceIntervalManagerId
        );
        if (priceIntervalManager == null) {
          log.critical(
            "The PriceIntervalManager for oracle {} with id {} is undefined",
            [currentOracleId, currentPriceIntervalManagerId]
          );
        }
        let latestPriceInterval = PriceInterval.load(
          priceIntervalManager.latestPriceInterval
        );
        if (latestPriceInterval == null) {
          log.critical("The latest PriceInterval with id {} is undefined", [
            priceIntervalManager.latestPriceInterval,
          ]);
        }

        let currentOraclePrice = getLatestOraclePrice(
          oracle.address as Address
        );

        if (oracle.latestPrice != null) {
          if (oracle.latestPrice != currentOraclePrice) {
            oracle.lastUpdatedTimestamp = timestamp;
          }
        }
        oracle.latestPrice = currentOraclePrice;

        // FIVE_MINUTES_IN_SECONDS;
        let currentPriceIndex = timestamp.div(
          latestPriceInterval.intervalLength
        );
        if (currentPriceIndex.equals(latestPriceInterval.intervalIndex)) {
          let newNumberOfBlocksInInterval = latestPriceInterval.numberOfBlocksInInterval.plus(
            ONE
          );
          latestPriceInterval.endPrice = currentOraclePrice;
          latestPriceInterval.averagePrice = latestPriceInterval.averagePrice
            .times(latestPriceInterval.numberOfBlocksInInterval)
            .plus(currentOraclePrice)
            .div(newNumberOfBlocksInInterval);
          latestPriceInterval.numberOfBlocksInInterval = newNumberOfBlocksInInterval;
          latestPriceInterval.intervalComplete = false;

          latestPriceInterval.save();
        } else {
          let nextIntervalPrice = createPriceInterval(
            timestamp,
            oracle.id,
            priceIntervalManager.intervalLength,
            currentOraclePrice
          );
          priceIntervalManager.prices = priceIntervalManager.prices.concat([
            nextIntervalPrice.id,
          ]);
          priceIntervalManager.latestPriceInterval = nextIntervalPrice.id;
          nextIntervalPrice.save();
          priceIntervalManager.save();
        }

        oracle.save();
      }
    }
  }
}
