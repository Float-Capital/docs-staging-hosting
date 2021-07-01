// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Belt_Array = require("rescript/lib/js/belt_Array.js");

function mockAdminToReturn(_r, _param0) {
  ((_r.smocked.admin.will.return.with([_param0])));
  
}

function adminCalls(_r) {
  var array = _r.smocked.admin.calls;
  return Belt_Array.map(array, (function (param) {
                
              }));
}

function mockInitializeToReturn(_r) {
  ((_r.smocked.initialize.will.return()));
  
}

function initializeCalls(_r) {
  var array = _r.smocked.initialize.calls;
  return Belt_Array.map(array, (function (_m) {
                var admin = _m[0];
                return {
                        admin: admin
                      };
              }));
}

function mockChangeAdminToReturn(_r) {
  ((_r.smocked.changeAdmin.will.return()));
  
}

function changeAdminCalls(_r) {
  var array = _r.smocked.changeAdmin.calls;
  return Belt_Array.map(array, (function (_m) {
                var admin = _m[0];
                return {
                        admin: admin
                      };
              }));
}

var uninitializedValue;

exports.uninitializedValue = uninitializedValue;
exports.mockAdminToReturn = mockAdminToReturn;
exports.adminCalls = adminCalls;
exports.mockInitializeToReturn = mockInitializeToReturn;
exports.initializeCalls = initializeCalls;
exports.mockChangeAdminToReturn = mockChangeAdminToReturn;
exports.changeAdminCalls = changeAdminCalls;
/* No side effect */
