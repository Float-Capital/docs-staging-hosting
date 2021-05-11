@module("synchronized-promise") external await: JsPromise.t<'a> => 'a = "default"
