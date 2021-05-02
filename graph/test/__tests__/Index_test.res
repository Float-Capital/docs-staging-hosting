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
      callback,
    }) => {
      let _ = allStateChanges.contents->JsPromise.map(({allV1Events}) => {
        expectEqual(allV1Events->Belt.Array.length, 1)

        callback()
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
