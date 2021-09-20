// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Caml_exceptions = require("rescript/lib/js/caml_exceptions.js");

var JsError = /* @__PURE__ */Caml_exceptions.create("JsPromise.JsError");

function $$catch(promise, callback) {
  return promise.catch(function (err) {
              return Curry._1(callback, Caml_exceptions.caml_is_extension(err) ? err : ({
                              RE_EXN_ID: JsError,
                              _1: err
                            }));
            });
}

exports.JsError = JsError;
exports.$$catch = $$catch;
/* No side effect */
