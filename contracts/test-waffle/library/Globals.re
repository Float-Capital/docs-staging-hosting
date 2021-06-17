open BsMocha;
open LetOps;
let (it', it_only', it_skip', before_each', before') =
  Promise.(it, it_only, it_skip, before_each, before);

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
let (describe, it, it_skip, describe_skip, before, before_each) =
  Mocha.(describe, describe_skip, it, it_skip, before, before_each);
