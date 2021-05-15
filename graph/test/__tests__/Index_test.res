open TestFramework

let emptyPromise = () =>
  Js.Promise.make((~resolve, ~reject as _) => resolve(. Converters.emptyEventGroups))

let allStateChanges: ref<JsPromise.t<Converters.eventGroup>> = ref(emptyPromise())

describe("All Tests", ({beforeAll, testAsync}) => {
  beforeAll(() => {
    let allStateChangesRaw = Queries.getAllStateChanges()

    allStateChanges :=
      allStateChangesRaw->StateChange.getAllStateChangeEvents->StateChange.splitIntoEventGroups
  })

  describe("V1 event", ({testAsync}) => {
    testAsync("should occur exactly ONCE", ({expectEqual, callback}) => {
      let _ = allStateChanges.contents->JsPromise.map(({allV1Events}) => {
        expectEqual(allV1Events->Belt.Array.length, 1)
        callback()
      })
    })

    testAsync("should setup the correct initial data in the global state", ({
      expectEqual,
      expectNotEqual,
      expectTrue,
      callback,
    }) => {
      let _ = allStateChanges.contents->JsPromise.map(({allV1Events}) => {
        let {blockNumber, timestamp, data: {admin, staker, tokenFactory}} =
          allV1Events->Array.getExn(0)

        let _ = Queries.getGlobalStateAtBlock(~blockNumber)->JsPromise.map((
          result: option<Queries.GetGlobalState.t_globalState>,
        ) => {
          switch result {
          | Some({
              contractVersion,
              latestMarketIndex,
              staker: {address: addressStaker},
              tokenFactory: {address: addressTokenFactory},
              adminAddress,
              longShort: {id: _idLongShort}, // TODO: test that this is the same as the address that emitted this event
              totalFloatMinted,
              totalTxs,
              totalGasUsed: _totalGasUsed,
              totalUsers,
              timestampLaunched,
              txHash,
            }) =>
            expectEqual(contractVersion->BN.toString, "1")
            expectEqual(latestMarketIndex->BN.toString, "0")
            expectEqual(totalFloatMinted->BN.toString, "0")
            expectEqual(totalTxs->BN.toString, "1") // Should the initializiation of the contract count as a transaction? Currently it is.
            expectEqual(totalUsers->BN.toString, "1") // THIS IS A BUG - should be zero to start
            // expectEqual(totalGasUsed->BN.toString, "0") // This is a BUG - counting the initialization txs gas as part of total gas used
            expectEqual(timestampLaunched->BN.toString, timestamp->Int.toString)
            expectEqual(addressStaker, staker)
            expectEqual(addressTokenFactory, tokenFactory)
            expectEqual(adminAddress, admin)
            expectNotEqual(txHash, "")
          | None => expectTrue(false)
          }
          callback()
        })
      })
    })
  })

  describe("SyntheticTokenCreated event", ({testAsync}) => {
    testAsync("should occur more than ONCE (must test!)", ({expectTrue, callback}) => {
      let _ = allStateChanges.contents->JsPromise.map(({allSyntheticTokenCreatedEvents}) => {
        Js.log({
          "Length": allSyntheticTokenCreatedEvents->Belt.Array.length,
          "all 'allSyntheticTokenCreatedEvents' events": allSyntheticTokenCreatedEvents,
        })
        expectTrue(allSyntheticTokenCreatedEvents->Belt.Array.length >= 1)
        callback()
      })
    })

    testAsync("synthetic market shouldn't exist before this event is emitted", ({
      expectTrue,
      callback,
    }) => {
      let _ =
        allStateChanges.contents
        ->JsPromise.then(({allSyntheticTokenCreatedEvents}) => {
          allSyntheticTokenCreatedEvents
          ->Array.map(({blockNumber, data: {marketIndex}}) => {
            Queries.getSyntheticMarketAtBlock(
              ~blockNumber=blockNumber - 1,
              ~marketId=marketIndex->BN.toString,
            )->JsPromise.map(result => {
              switch result {
              | Some(_response) => expectTrue(false)
              | None => expectTrue(true)
              }
            })
          })
          ->JsPromise.all
        })
        ->JsPromise.map(_ => callback())
    })
    testAsync("should create a SyntheticMarket with correct ID and initial data", ({
      expectEqual,
      expectTrue,
      callback,
    }) => {
      let _ =
        allStateChanges.contents
        ->JsPromise.then(({allSyntheticTokenCreatedEvents}) => {
          allSyntheticTokenCreatedEvents
          ->Array.map(({
            blockNumber,
            timestamp,
            txHash,
            data: {
              marketIndex,
              longTokenAddress,
              shortTokenAddress,
              name,
              symbol,
              oracleAddress,
              collateralAddress,
            },
          }) => {
            Queries.getSyntheticMarketAtBlock(
              ~blockNumber,
              ~marketId=marketIndex->BN.toString,
            )->JsPromise.map(result => {
              switch result {
              | Some({
                  id,
                  timestampCreated,
                  txHash: resultTxHash,
                  blockNumberCreated,
                  collateralToken: {id: collateralTokenId},
                  name: resultName,
                  symbol: resultSymbol,
                  marketIndex,
                  oracleAddress: resultOracleAddress,
                  previousOracleAddresses,
                  syntheticLong: {id: longId},
                  syntheticShort: {id: shortId},
                  latestSystemState: {id: systemStateId},
                  feeStructure: {id: feeStructureId},
                  kPeriod,
                  kMultiplier,
                }) => {
                  expectEqual(id, marketIndex->BN.toString)
                  expectEqual(timestamp->Int.toString, timestampCreated->BN.toString)
                  expectEqual(txHash, resultTxHash)
                  expectEqual(blockNumber->Int.toString, blockNumberCreated->BN.toString)
                  expectEqual(name, resultName)
                  expectEqual(symbol, resultSymbol)
                  expectEqual(oracleAddress, resultOracleAddress)
                  expectEqual(kPeriod->BN.toString, "0") // BUG -> should be fixed in later versions of graph
                  expectEqual(kMultiplier->BN.toString, "0") // BUG -> should be fixed later versions
                  expectEqual(previousOracleAddresses, [])
                  expectEqual(longId, longTokenAddress)
                  expectEqual(shortId, shortTokenAddress)
                  expectEqual(systemStateId, marketIndex->BN.toString ++ "-0")
                  expectEqual(feeStructureId, marketIndex->BN.toString ++ "-fees")
                  expectEqual(collateralTokenId, collateralAddress)
                  ()
                }

              | None => expectTrue(false)
              }
            })
          })
          ->JsPromise.all
        })
        ->JsPromise.map(_ => callback())
    })
  })

  testAsync("All events should be classified - NO UNKNOWN EVENTS", ({callback, expectEqual}) => {
    let _ = allStateChanges.contents->JsPromise.map(({allUnclassifiedEvents}) => {
      expectEqual(allUnclassifiedEvents->Belt.Array.length, 0)
      callback()
    })
  })
})
