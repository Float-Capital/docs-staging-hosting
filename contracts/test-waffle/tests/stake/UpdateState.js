// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Chai = require("../../bindings/chai/Chai.js");
var LetOps = require("../../library/LetOps.js");
var Globals = require("../../library/Globals.js");
var Helpers = require("../../library/Helpers.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var StakerHelpers = require("./StakerHelpers.js");
var LongShortSmocked = require("../../library/smock/LongShortSmocked.js");
var Smock = require("@eth-optimism/smock");

function test(contracts, accounts) {
  describe("_updateState", (function () {
          var stakerRef = {
            contents: ""
          };
          var longShortSmockedRef = {
            contents: undefined
          };
          var marketIndex = Helpers.randomJsInteger(undefined);
          var syntheticAddress = Helpers.randomAddress(undefined);
          beforeEach(function () {
                return LetOps.AwaitThen.let_(StakerHelpers.deployAndSetupStakerToUnitTest(stakerRef, "_updateState", contracts, accounts), (function (param) {
                              return LetOps.AwaitThen.let_(Smock.smockit(contracts.contents.longShort), (function (longShortSmocked) {
                                            longShortSmockedRef.contents = longShortSmocked;
                                            LongShortSmocked.mockUpdateSystemStateToReturn(longShortSmocked);
                                            return LetOps.AwaitThen.let_(stakerRef.contents.set_updateStateParams(longShortSmocked.address, syntheticAddress, marketIndex), (function (param) {
                                                          return stakerRef.contents._updateStateExternal(syntheticAddress);
                                                        }));
                                          }));
                            }));
              });
          return Globals.it$p("calls longShort updateState with the market index of the token", (function (param) {
                        return Chai.recordEqualFlat(Belt_Array.getExn(LongShortSmocked.updateSystemStateCalls(longShortSmockedRef.contents), 0), {
                                    marketIndex: marketIndex
                                  });
                      }));
        }));
  
}

exports.test = test;
/* Chai Not a pure module */
