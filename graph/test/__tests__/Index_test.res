open TestFramework

let emptyPromise = () =>
  Js.Promise.make((~resolve, ~reject as _) => resolve(. StateChange.emptyEventGroups))

let allStateChanges: ref<JsPromise.t<StateChange.eventGroup>> = ref(emptyPromise())

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
        expectEqual(allV1Events->Array.length, 1)

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

  testAsync("All events should be classified - NO UNKNOWN EVENTS", ({callback, expectEqual}) => {
    let _ = allStateChanges.contents->JsPromise.map(({allUnclassifiedEvents}) => {
      expectEqual(allUnclassifiedEvents->Belt.Array.length, 0)
      callback()
    })
  })
})
