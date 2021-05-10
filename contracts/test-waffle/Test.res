let {it: it', it_skip: it_skip', before_each, before} = module(BsMocha.Async)
let {describe, it, it_skip} = module(BsMocha.Mocha)

// let stakeFor5Users
describe("Float System", () => {
  describe("Staking", () => {
    let contracts: ref<Helpers.coreContracts> = ref(None->Obj.magic)
    let accounts: ref<array<Ethers.Wallet.t>> = ref(None->Obj.magic)

    before(done => {
      let _ = Ethers.getSigners()->JsPromise.map(loadedAccounts => {
        accounts := loadedAccounts
        done()
      })
    })

    before_each(done => {
      let _ = Helpers.inititialize()->JsPromise.map(deployedContracts => {
        contracts := deployedContracts
        let _ = ()
        done()
      })
    })

    it("Two numbers are equal", () => {
      Js.log2("The loaded accounts", accounts.contents)
      Chai.bnEqual(Ethers.BigNumber.fromInt(1), Ethers.BigNumber.fromUnsafe("1"))
      Chai.bnCloseTo(Ethers.BigNumber.fromInt(1), Ethers.BigNumber.fromUnsafe("5"), ~distance=4)
      Chai.bnWithin(
        Ethers.BigNumber.fromInt(1),
        ~min=Ethers.BigNumber.fromUnsafe("0"),
        ~max=Ethers.BigNumber.fromInt(2),
      )
    })
  })
  describe("DELETE ASAP - example tests", () => {
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
