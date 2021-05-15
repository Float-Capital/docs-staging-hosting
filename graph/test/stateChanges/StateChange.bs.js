// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Converters = require("./Converters.bs.js");

function getStateChange(param) {
  var paramsObject = {};
  Belt_Array.forEach(param.params, (function (param) {
          paramsObject[param.paramName] = param.param;
          
        }));
  return Converters.covertToStateChange(param.eventName, paramsObject);
}

function getAllStateChangeEvents(allStateChangesRaw) {
  return allStateChangesRaw.then(function (rawStateChanges) {
              return Promise.resolve(Belt_Array.reduce(rawStateChanges, [], (function (currentArrayOfStateChanges, param) {
                                var timestamp = param.timestamp;
                                var blockNumber = param.blockNumber;
                                var id = param.id;
                                return Belt_Array.concat(currentArrayOfStateChanges, Belt_Array.map(param.txEventParamList, (function (eventRaw) {
                                                  return {
                                                          blockNumber: blockNumber.toNumber(),
                                                          timestamp: timestamp.toNumber(),
                                                          txHash: id,
                                                          data: getStateChange(eventRaw)
                                                        };
                                                })));
                              })));
            });
}

function splitIntoEventGroups(allStateChanges) {
  return allStateChanges.then(function (stateChanges) {
              return Promise.resolve(Belt_Array.reduce(stateChanges, Converters.emptyEventGroups, Converters.addEventToCorrectGrouping));
            });
}

exports.getStateChange = getStateChange;
exports.getAllStateChangeEvents = getAllStateChangeEvents;
exports.splitIntoEventGroups = splitIntoEventGroups;
/* Converters Not a pure module */
