let {it: it', it_skip: it_skip', before_each} = module(BsMocha.Async)
let {describe, it, it_skip} = module(BsMocha.Mocha)

describe("Float System", () => {
  describe("List.map", () => {
    before_each(done => {
      let _ = Helpers.inititialize()->JsPromise.map(_ => done())
    })
    it("it worked", () => Js.log("It worked, yay"))
  })
})
