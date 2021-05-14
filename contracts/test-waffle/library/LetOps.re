module AwaitThen = {
  let let_ = (prom, cb) => JsPromise.then_(prom, cb);
};
module Await = {
  let let_ = (prom, cb) => JsPromise.map(prom, cb);
};
