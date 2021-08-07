import {
  Address,
  BigInt,
  Bytes,
  ethereum,
  store,
  Value,
} from "@graphprotocol/graph-ts";
  import {
ExecuteNextPriceMarketSideShiftSettlementUser,
ExecuteNextPriceMintSettlementUser,
ExecuteNextPriceRedeemSettlementUser,
ExecuteNextPriceSettlementsUser,
LongShortV1,
NewMarketLaunchedAndSeeded,
NextPriceDeposit,
NextPriceRedeem,
NextPriceSyntheticPositionShift,
OracleUpdated,
SyntheticMarketCreated,
SystemStateUpdated,} from "../../../generated/LongShort/LongShort";


export function createExecuteNextPriceMarketSideShiftSettlementUserEvent(user: Address, marketIndex: BigInt, isShiftFromLong: boolean, amount: BigInt): ExecuteNextPriceMarketSideShiftSettlementUser {
  let newExecuteNextPriceMarketSideShiftSettlementUserEvent = new ExecuteNextPriceMarketSideShiftSettlementUser();
  newExecuteNextPriceMarketSideShiftSettlementUserEvent.parameters = new Array<ethereum.EventParam>();

  
          let userParam = new ethereum.EventParam();

  userParam.name = "user";
  userParam.value = ethereum.Value.fromAddress(user);
  
  newExecuteNextPriceMarketSideShiftSettlementUserEvent.parameters.push(userParam);

          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newExecuteNextPriceMarketSideShiftSettlementUserEvent.parameters.push(marketIndexParam);

          let isShiftFromLongParam = new ethereum.EventParam();

  isShiftFromLongParam.name = "isShiftFromLong";
  isShiftFromLongParam.value = ethereum.Value.fromBoolean(isShiftFromLong);
  
  newExecuteNextPriceMarketSideShiftSettlementUserEvent.parameters.push(isShiftFromLongParam);

          let amountParam = new ethereum.EventParam();

  amountParam.name = "amount";
  amountParam.value = ethereum.Value.fromSignedBigInt(amount);
  
  newExecuteNextPriceMarketSideShiftSettlementUserEvent.parameters.push(amountParam);

  return newExecuteNextPriceMarketSideShiftSettlementUserEvent;
}

export function createExecuteNextPriceMintSettlementUserEvent(user: Address, marketIndex: BigInt, isLong: boolean, amount: BigInt): ExecuteNextPriceMintSettlementUser {
  let newExecuteNextPriceMintSettlementUserEvent = new ExecuteNextPriceMintSettlementUser();
  newExecuteNextPriceMintSettlementUserEvent.parameters = new Array<ethereum.EventParam>();

  
          let userParam = new ethereum.EventParam();

  userParam.name = "user";
  userParam.value = ethereum.Value.fromAddress(user);
  
  newExecuteNextPriceMintSettlementUserEvent.parameters.push(userParam);

          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newExecuteNextPriceMintSettlementUserEvent.parameters.push(marketIndexParam);

          let isLongParam = new ethereum.EventParam();

  isLongParam.name = "isLong";
  isLongParam.value = ethereum.Value.fromBoolean(isLong);
  
  newExecuteNextPriceMintSettlementUserEvent.parameters.push(isLongParam);

          let amountParam = new ethereum.EventParam();

  amountParam.name = "amount";
  amountParam.value = ethereum.Value.fromSignedBigInt(amount);
  
  newExecuteNextPriceMintSettlementUserEvent.parameters.push(amountParam);

  return newExecuteNextPriceMintSettlementUserEvent;
}

export function createExecuteNextPriceRedeemSettlementUserEvent(user: Address, marketIndex: BigInt, isLong: boolean, amount: BigInt): ExecuteNextPriceRedeemSettlementUser {
  let newExecuteNextPriceRedeemSettlementUserEvent = new ExecuteNextPriceRedeemSettlementUser();
  newExecuteNextPriceRedeemSettlementUserEvent.parameters = new Array<ethereum.EventParam>();

  
          let userParam = new ethereum.EventParam();

  userParam.name = "user";
  userParam.value = ethereum.Value.fromAddress(user);
  
  newExecuteNextPriceRedeemSettlementUserEvent.parameters.push(userParam);

          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newExecuteNextPriceRedeemSettlementUserEvent.parameters.push(marketIndexParam);

          let isLongParam = new ethereum.EventParam();

  isLongParam.name = "isLong";
  isLongParam.value = ethereum.Value.fromBoolean(isLong);
  
  newExecuteNextPriceRedeemSettlementUserEvent.parameters.push(isLongParam);

          let amountParam = new ethereum.EventParam();

  amountParam.name = "amount";
  amountParam.value = ethereum.Value.fromSignedBigInt(amount);
  
  newExecuteNextPriceRedeemSettlementUserEvent.parameters.push(amountParam);

  return newExecuteNextPriceRedeemSettlementUserEvent;
}

export function createExecuteNextPriceSettlementsUserEvent(user: Address, marketIndex: BigInt): ExecuteNextPriceSettlementsUser {
  let newExecuteNextPriceSettlementsUserEvent = new ExecuteNextPriceSettlementsUser();
  newExecuteNextPriceSettlementsUserEvent.parameters = new Array<ethereum.EventParam>();

  
          let userParam = new ethereum.EventParam();

  userParam.name = "user";
  userParam.value = ethereum.Value.fromAddress(user);
  
  newExecuteNextPriceSettlementsUserEvent.parameters.push(userParam);

          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newExecuteNextPriceSettlementsUserEvent.parameters.push(marketIndexParam);

  return newExecuteNextPriceSettlementsUserEvent;
}

export function createLongShortV1Event(admin: Address, treasury: Address, tokenFactory: Address, staker: Address): LongShortV1 {
  let newLongShortV1Event = new LongShortV1();
  newLongShortV1Event.parameters = new Array<ethereum.EventParam>();

  
          let adminParam = new ethereum.EventParam();

  adminParam.name = "admin";
  adminParam.value = ethereum.Value.fromAddress(admin);
  
  newLongShortV1Event.parameters.push(adminParam);

          let treasuryParam = new ethereum.EventParam();

  treasuryParam.name = "treasury";
  treasuryParam.value = ethereum.Value.fromAddress(treasury);
  
  newLongShortV1Event.parameters.push(treasuryParam);

          let tokenFactoryParam = new ethereum.EventParam();

  tokenFactoryParam.name = "tokenFactory";
  tokenFactoryParam.value = ethereum.Value.fromAddress(tokenFactory);
  
  newLongShortV1Event.parameters.push(tokenFactoryParam);

          let stakerParam = new ethereum.EventParam();

  stakerParam.name = "staker";
  stakerParam.value = ethereum.Value.fromAddress(staker);
  
  newLongShortV1Event.parameters.push(stakerParam);

  return newLongShortV1Event;
}

export function createNewMarketLaunchedAndSeededEvent(marketIndex: BigInt, initialSeed: BigInt): NewMarketLaunchedAndSeeded {
  let newNewMarketLaunchedAndSeededEvent = new NewMarketLaunchedAndSeeded();
  newNewMarketLaunchedAndSeededEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newNewMarketLaunchedAndSeededEvent.parameters.push(marketIndexParam);

          let initialSeedParam = new ethereum.EventParam();

  initialSeedParam.name = "initialSeed";
  initialSeedParam.value = ethereum.Value.fromSignedBigInt(initialSeed);
  
  newNewMarketLaunchedAndSeededEvent.parameters.push(initialSeedParam);

  return newNewMarketLaunchedAndSeededEvent;
}

export function createNextPriceDepositEvent(marketIndex: BigInt, isLong: boolean, depositAdded: BigInt, user: Address, oracleUpdateIndex: BigInt): NextPriceDeposit {
  let newNextPriceDepositEvent = new NextPriceDeposit();
  newNextPriceDepositEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newNextPriceDepositEvent.parameters.push(marketIndexParam);

          let isLongParam = new ethereum.EventParam();

  isLongParam.name = "isLong";
  isLongParam.value = ethereum.Value.fromBoolean(isLong);
  
  newNextPriceDepositEvent.parameters.push(isLongParam);

          let depositAddedParam = new ethereum.EventParam();

  depositAddedParam.name = "depositAdded";
  depositAddedParam.value = ethereum.Value.fromSignedBigInt(depositAdded);
  
  newNextPriceDepositEvent.parameters.push(depositAddedParam);

          let userParam = new ethereum.EventParam();

  userParam.name = "user";
  userParam.value = ethereum.Value.fromAddress(user);
  
  newNextPriceDepositEvent.parameters.push(userParam);

          let oracleUpdateIndexParam = new ethereum.EventParam();

  oracleUpdateIndexParam.name = "oracleUpdateIndex";
  oracleUpdateIndexParam.value = ethereum.Value.fromSignedBigInt(oracleUpdateIndex);
  
  newNextPriceDepositEvent.parameters.push(oracleUpdateIndexParam);

  return newNextPriceDepositEvent;
}

export function createNextPriceRedeemEvent(marketIndex: BigInt, isLong: boolean, synthRedeemed: BigInt, user: Address, oracleUpdateIndex: BigInt): NextPriceRedeem {
  let newNextPriceRedeemEvent = new NextPriceRedeem();
  newNextPriceRedeemEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newNextPriceRedeemEvent.parameters.push(marketIndexParam);

          let isLongParam = new ethereum.EventParam();

  isLongParam.name = "isLong";
  isLongParam.value = ethereum.Value.fromBoolean(isLong);
  
  newNextPriceRedeemEvent.parameters.push(isLongParam);

          let synthRedeemedParam = new ethereum.EventParam();

  synthRedeemedParam.name = "synthRedeemed";
  synthRedeemedParam.value = ethereum.Value.fromSignedBigInt(synthRedeemed);
  
  newNextPriceRedeemEvent.parameters.push(synthRedeemedParam);

          let userParam = new ethereum.EventParam();

  userParam.name = "user";
  userParam.value = ethereum.Value.fromAddress(user);
  
  newNextPriceRedeemEvent.parameters.push(userParam);

          let oracleUpdateIndexParam = new ethereum.EventParam();

  oracleUpdateIndexParam.name = "oracleUpdateIndex";
  oracleUpdateIndexParam.value = ethereum.Value.fromSignedBigInt(oracleUpdateIndex);
  
  newNextPriceRedeemEvent.parameters.push(oracleUpdateIndexParam);

  return newNextPriceRedeemEvent;
}

export function createNextPriceSyntheticPositionShiftEvent(marketIndex: BigInt, isShiftFromLong: boolean, synthShifted: BigInt, user: Address, oracleUpdateIndex: BigInt): NextPriceSyntheticPositionShift {
  let newNextPriceSyntheticPositionShiftEvent = new NextPriceSyntheticPositionShift();
  newNextPriceSyntheticPositionShiftEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newNextPriceSyntheticPositionShiftEvent.parameters.push(marketIndexParam);

          let isShiftFromLongParam = new ethereum.EventParam();

  isShiftFromLongParam.name = "isShiftFromLong";
  isShiftFromLongParam.value = ethereum.Value.fromBoolean(isShiftFromLong);
  
  newNextPriceSyntheticPositionShiftEvent.parameters.push(isShiftFromLongParam);

          let synthShiftedParam = new ethereum.EventParam();

  synthShiftedParam.name = "synthShifted";
  synthShiftedParam.value = ethereum.Value.fromSignedBigInt(synthShifted);
  
  newNextPriceSyntheticPositionShiftEvent.parameters.push(synthShiftedParam);

          let userParam = new ethereum.EventParam();

  userParam.name = "user";
  userParam.value = ethereum.Value.fromAddress(user);
  
  newNextPriceSyntheticPositionShiftEvent.parameters.push(userParam);

          let oracleUpdateIndexParam = new ethereum.EventParam();

  oracleUpdateIndexParam.name = "oracleUpdateIndex";
  oracleUpdateIndexParam.value = ethereum.Value.fromSignedBigInt(oracleUpdateIndex);
  
  newNextPriceSyntheticPositionShiftEvent.parameters.push(oracleUpdateIndexParam);

  return newNextPriceSyntheticPositionShiftEvent;
}

export function createOracleUpdatedEvent(marketIndex: BigInt, oldOracleAddress: Address, newOracleAddress: Address): OracleUpdated {
  let newOracleUpdatedEvent = new OracleUpdated();
  newOracleUpdatedEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newOracleUpdatedEvent.parameters.push(marketIndexParam);

          let oldOracleAddressParam = new ethereum.EventParam();

  oldOracleAddressParam.name = "oldOracleAddress";
  oldOracleAddressParam.value = ethereum.Value.fromAddress(oldOracleAddress);
  
  newOracleUpdatedEvent.parameters.push(oldOracleAddressParam);

          let newOracleAddressParam = new ethereum.EventParam();

  newOracleAddressParam.name = "newOracleAddress";
  newOracleAddressParam.value = ethereum.Value.fromAddress(newOracleAddress);
  
  newOracleUpdatedEvent.parameters.push(newOracleAddressParam);

  return newOracleUpdatedEvent;
}

export function createSyntheticMarketCreatedEvent(marketIndex: BigInt, longTokenAddress: Address, shortTokenAddress: Address, paymentToken: Address, initialAssetPrice: BigInt, name: string, symbol: string, oracleAddress: Address, yieldManagerAddress: Address): SyntheticMarketCreated {
  let newSyntheticMarketCreatedEvent = new SyntheticMarketCreated();
  newSyntheticMarketCreatedEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newSyntheticMarketCreatedEvent.parameters.push(marketIndexParam);

          let longTokenAddressParam = new ethereum.EventParam();

  longTokenAddressParam.name = "longTokenAddress";
  longTokenAddressParam.value = ethereum.Value.fromAddress(longTokenAddress);
  
  newSyntheticMarketCreatedEvent.parameters.push(longTokenAddressParam);

          let shortTokenAddressParam = new ethereum.EventParam();

  shortTokenAddressParam.name = "shortTokenAddress";
  shortTokenAddressParam.value = ethereum.Value.fromAddress(shortTokenAddress);
  
  newSyntheticMarketCreatedEvent.parameters.push(shortTokenAddressParam);

          let paymentTokenParam = new ethereum.EventParam();

  paymentTokenParam.name = "paymentToken";
  paymentTokenParam.value = ethereum.Value.fromAddress(paymentToken);
  
  newSyntheticMarketCreatedEvent.parameters.push(paymentTokenParam);

          let initialAssetPriceParam = new ethereum.EventParam();

  initialAssetPriceParam.name = "initialAssetPrice";
  initialAssetPriceParam.value = ethereum.Value.fromSignedBigInt(initialAssetPrice);
  
  newSyntheticMarketCreatedEvent.parameters.push(initialAssetPriceParam);

          let nameParam = new ethereum.EventParam();

  nameParam.name = "name";
  nameParam.value = ethereum.Value.fromString(name);
  
  newSyntheticMarketCreatedEvent.parameters.push(nameParam);

          let symbolParam = new ethereum.EventParam();

  symbolParam.name = "symbol";
  symbolParam.value = ethereum.Value.fromString(symbol);
  
  newSyntheticMarketCreatedEvent.parameters.push(symbolParam);

          let oracleAddressParam = new ethereum.EventParam();

  oracleAddressParam.name = "oracleAddress";
  oracleAddressParam.value = ethereum.Value.fromAddress(oracleAddress);
  
  newSyntheticMarketCreatedEvent.parameters.push(oracleAddressParam);

          let yieldManagerAddressParam = new ethereum.EventParam();

  yieldManagerAddressParam.name = "yieldManagerAddress";
  yieldManagerAddressParam.value = ethereum.Value.fromAddress(yieldManagerAddress);
  
  newSyntheticMarketCreatedEvent.parameters.push(yieldManagerAddressParam);

  return newSyntheticMarketCreatedEvent;
}

export function createSystemStateUpdatedEvent(marketIndex: BigInt, updateIndex: BigInt, underlyingAssetPrice: BigInt, longValue: BigInt, shortValue: BigInt, longPrice: BigInt, shortPrice: BigInt): SystemStateUpdated {
  let newSystemStateUpdatedEvent = new SystemStateUpdated();
  newSystemStateUpdatedEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newSystemStateUpdatedEvent.parameters.push(marketIndexParam);

          let updateIndexParam = new ethereum.EventParam();

  updateIndexParam.name = "updateIndex";
  updateIndexParam.value = ethereum.Value.fromSignedBigInt(updateIndex);
  
  newSystemStateUpdatedEvent.parameters.push(updateIndexParam);

          let underlyingAssetPriceParam = new ethereum.EventParam();

  underlyingAssetPriceParam.name = "underlyingAssetPrice";
  underlyingAssetPriceParam.value = ethereum.Value.fromSignedBigInt(underlyingAssetPrice);
  
  newSystemStateUpdatedEvent.parameters.push(underlyingAssetPriceParam);

          let longValueParam = new ethereum.EventParam();

  longValueParam.name = "longValue";
  longValueParam.value = ethereum.Value.fromSignedBigInt(longValue);
  
  newSystemStateUpdatedEvent.parameters.push(longValueParam);

          let shortValueParam = new ethereum.EventParam();

  shortValueParam.name = "shortValue";
  shortValueParam.value = ethereum.Value.fromSignedBigInt(shortValue);
  
  newSystemStateUpdatedEvent.parameters.push(shortValueParam);

          let longPriceParam = new ethereum.EventParam();

  longPriceParam.name = "longPrice";
  longPriceParam.value = ethereum.Value.fromSignedBigInt(longPrice);
  
  newSystemStateUpdatedEvent.parameters.push(longPriceParam);

          let shortPriceParam = new ethereum.EventParam();

  shortPriceParam.name = "shortPrice";
  shortPriceParam.value = ethereum.Value.fromSignedBigInt(shortPrice);
  
  newSystemStateUpdatedEvent.parameters.push(shortPriceParam);

  return newSystemStateUpdatedEvent;
}