open LetOps;
open Mocha;

let it'' = (str, fn) => it'(str, () => {fn()->JsPromise.resolve});

let before_once' = fn => {
  let ranRef = ref(false);
  before_each'(() =>
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
