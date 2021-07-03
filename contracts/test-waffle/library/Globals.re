open LetOps;
open Mocha;

let before_once' = fn => {
  let ranRef = ref(false);
  before_each(() =>
    if (ranRef^) {
      ()->JsPromise.resolve;
    } else {
      let%Await _ = fn();
      ranRef := true;
    }
  );
};

let (
  add,
  sub,
  bnFromString,
  bnFromInt,
  mul,
  div,
  bnToString,
  bnToInt,
  bnGt,
  bnGte,
  bnLt,
) =
  Ethers.BigNumber.(
    add,
    sub,
    fromUnsafe,
    fromInt,
    mul,
    div,
    toString,
    toNumber,
    gt,
    gte,
    lt,
  );

let describeIntegration = Config.dontRunIntegrationTests ? describe_skip : describe;

let describeUnit = Config.dontRunUnitTests ? describe_skip : describe;
