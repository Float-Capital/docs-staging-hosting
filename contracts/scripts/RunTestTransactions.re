open LetOps;
open DeployHelpers;
open ContractHelpers;
open Globals;

type allContracts = {
  staker: Staker.t,
  longShort: LongShort.t,
  paymentToken: ERC20Mock.t,
  treasury: Treasury_v0.t,
  syntheticToken: SyntheticToken.t,
};

let runTestTransactions = ({staker, longShort, treasury, paymentToken}) => {
  let%Await loadedAccounts = Ethers.getSigners();

  let admin = loadedAccounts->Array.getUnsafe(1);
  let user1 = loadedAccounts->Array.getUnsafe(2);
  let user2 = loadedAccounts->Array.getUnsafe(3);
  let user3 = loadedAccounts->Array.getUnsafe(4);

  let%AwaitThen _ = DeployHelpers.topupBalanceIfLow(~from=admin, ~to_=user1);
  let%AwaitThen _ = DeployHelpers.topupBalanceIfLow(~from=admin, ~to_=user2);
  let%AwaitThen _ = DeployHelpers.topupBalanceIfLow(~from=admin, ~to_=user3);

  let%AwaitThen _ =
    deployTestMarket(
      "ETH Killers",
      "ETHK",
      longShort,
      treasury,
      admin,
      "networkName",
      paymentToken: ERC20Mock.t,
    );

  let%AwaitThen _ =
    deployTestMarket(
      "The Flippening",
      "EBD",
      longShort,
      treasury,
      admin,
      "networkName",
      paymentToken: ERC20Mock.t,
    );

  let%AwaitThen _ =
    deployTestMarket(
      "Doge Market",
      "FL_DOGE",
      longShort,
      treasury,
      admin,
      "networkName",
      paymentToken: ERC20Mock.t,
    );
  let initialMarkets = [|1, 2, 3|];

  let longMintAmount = bnFromString("10000000000000000000");
  let shortMintAmount = longMintAmount->div(bnFromInt(2));
  let redeemShortAmount = shortMintAmount->div(bnFromInt(2));
  let longStakeAmount = bnFromInt(1);

  let%AwaitThen currentMarketIndex = longShort->LongShort.latestMarket;
  Js.log("running update system state");
  let%AwaitThen _ =
    executeOnMarkets(
      initialMarkets,
      LongShort.updateSystemState(longShort, ~marketIndex=_),
    );
  Js.log("Executing Long Mints");
  let%AwaitThen _ =
    executeOnMarkets(
      initialMarkets,
      mintLongNextPriceWithSystemUpdate(
        longMintAmount,
        _,
        paymentToken,
        longShort,
        user1,
        admin,
      ),
    );

  Js.log("Executing Short Mints");
  let%AwaitThen _ =
    executeOnMarkets(
      initialMarkets,
      mintShortNextPriceWithSystemUpdate(
        shortMintAmount,
        _,
        paymentToken,
        longShort,
        user1,
        admin,
      ),
    );

  Js.log("Executing Short Position Redeem");
  let%AwaitThen _ =
    executeOnMarkets(
      initialMarkets,
      redeemShortNextPriceWithSystemUpdate(
        redeemShortAmount,
        _,
        longShort,
        user1,
        admin,
      ),
    );

  let%AwaitThen _ =
    executeOnMarkets(
      initialMarkets,
      setOracleManagerPrice(longShort, _, admin),
    );

  Js.log("Executing update system state");
  let%AwaitThen _ =
    executeOnMarkets(
      initialMarkets,
      LongShort.updateSystemState(longShort, ~marketIndex=_),
    );
  Js.log("Staking long position");
  let%AwaitThen _ =
    executeOnMarkets(
      initialMarkets,
      stakeSynthLong(longStakeAmount, longShort, _, user1),
    );

  Js.log("End deploy tests");

  JsPromise.resolve();
};
