open LetOps;
open DeployHelpers;

type allContracts = {
  staker: Staker.t,
  longShort: LongShort.t,
  paymentToken: ERC20Mock.t,
  treasury: Treasury_v0.t,
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
      "syntheticName",
      "syntheticSymbol",
      longShort,
      treasury,
      admin,
      "networkName",
      paymentToken: ERC20Mock.t,
    );

  Js.log(
    "Happy console log",
    // Js.log({staker, longShort});
  );

  JsPromise.resolve();
};
