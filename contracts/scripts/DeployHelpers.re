open Ethers;
open LetOps;
open Globals;

let minSenderBalance = bnFromString("50000000000000000");
let minRecieverBalance = bnFromString("20000000000000000");

let topupBalanceIfLow = (~from: Wallet.t, ~to_: Wallet.t) => {
  let%AwaitThen senderBalance = from->Wallet.getBalance;

  Js.log({"sender balance": senderBalance->bnToString});
  if (senderBalance->bnLt(minSenderBalance)) {
    Js.log(
      "WARNING - Sender doesn't have enough eth - need at least 0.05 ETH! (top up to over 1 ETH to be safe)",
      // %raw
      // {|throw "Sender doesn't have enough eth - need at least 0.05 ETH! (top up to over 1 ETH to be safe)"|};
    );
  };
  let%Await recieverBalance = to_->Wallet.getBalance;
  if (recieverBalance->bnLt(minRecieverBalance)) {
    let _ =
      from->Wallet.sendTransaction({
        to_: to_.address,
        value: minRecieverBalance,
      });
    ();
  };
};

let mintAndApprove = (token, amount, user, approvedAddress) => {
  let%AwaitThen _ = token->ERC20Mock.mint(~_to=user.address, ~amount);

  token
  ->ContractHelpers.connect(~address=user)
  ->ERC20Mock.approve(~spender=approvedAddress, ~amount);
};

let deployTestMarket =
    (
      syntheticName,
      syntheticSymbol,
      longShortInstance: LongShort.t,
      treasuryInstance: Treasury_v0.t,
      admin,
      networkName,
      paymentToken: ERC20Mock.t,
    ) => {
  let%AwaitThen oracleManager = OracleManagerMock.make(~admin=admin.address);

  let%AwaitThen yieldManager =
    YieldManagerMock.make(
      ~longShort=longShortInstance.address,
      ~treasury=treasuryInstance.address,
      ~token=paymentToken.address,
    );

  let%AwaitThen mintRole = paymentToken->ERC20Mock.mINTER_ROLE;

  let%AwaitThen _ =
    paymentToken->ERC20Mock.grantRole(
      ~role=mintRole,
      ~account=yieldManager.address,
    );

  let%AwaitThen _ =
    longShortInstance->LongShort.createNewSyntheticMarket(
      ~syntheticName,
      ~syntheticSymbol,
      ~paymentToken=paymentToken.address,
      ~oracleManager=oracleManager.address,
      ~yieldManager=yieldManager.address,
    );

  let%AwaitThen latestMarket = longShortInstance->LongShort.latestMarket;
  let kInitialMultiplier = bnFromString("5000000000000000000"); // 5x
  let kPeriod = bnFromInt(864000); // 10 days

  // let%AwaitThen _ =
  //   mintAndApprove(
  //     paymentToken,
  //     bnFromString("2000000000000000000"),
  //     admin,
  //     longShortInstance.address,
  //   );

  let%AwaitThen _ =
    mintAndApprove(
      paymentToken,
      bnFromString("2000000000000000000"),
      admin,
      longShortInstance.address,
    );
  let unstakeFee_e18 = bnFromString("5000000000000000"); // 50 basis point unstake fee
  let initialMarketSeedForEachMarketSide =
    bnFromString("1000000000000000000");
  longShortInstance->LongShort.initializeMarket(
    ~marketIndex=latestMarket,
    ~kInitialMultiplier,
    ~kPeriod,
    ~unstakeFee_e18, // 50 basis point unstake fee
    ~initialMarketSeedForEachMarketSide,
    ~balanceIncentiveCurve_exponent=bnFromInt(5),
    ~balanceIncentiveCurve_equilibriumOffset=bnFromInt(0),
    ~marketTreasurySplitGradient_e18=bnFromInt(1),
  );
};
