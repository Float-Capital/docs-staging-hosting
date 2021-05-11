let {it: it', it_skip: it_skip', before_each} = module(BsMocha.Async)
let {describe, it, it_skip} = module(BsMocha.Mocha)

describe("Float System", () => {
  describe("List.map", () => {
    before_each(done => {
      let _ = Helpers.inititialize()->JsPromise.map(_ => done())
    })
    it("it worked", () => Js.log("It worked, yay"))
    it("Two numbers are equal", () => {
      Chai.bnEqual(Ethers.BigNumber.fromInt(1), Ethers.BigNumber.fromUnsafe("1"))
      Chai.bnCloseTo(Ethers.BigNumber.fromInt(1), Ethers.BigNumber.fromUnsafe("5"), ~distance=4)
      Chai.bnWithin(
        Ethers.BigNumber.fromInt(1),
        ~min=Ethers.BigNumber.fromUnsafe("0"),
        ~max=Ethers.BigNumber.fromInt(2),
      )
    })
  })
})
