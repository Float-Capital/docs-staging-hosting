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
      let _ = Helpers.inititialize(
        ~admin=accounts.contents->Array.getUnsafe(0),
      )->JsPromise.map(deployedContracts => {
        contracts := deployedContracts
        let _ = ()
        done()
      })
    })

    it'("Two numbers are equal", done => {
      let {longShort, markets} = contracts.contents
      let testUser = accounts.contents->Array.getUnsafe(1)

      let _testPromise =
        markets
        ->Array.map(({paymentToken}) => {
          (paymentToken, Helpers.randomMintLongShort())
        })
        ->Array.mapWithIndex((marketIndex, (paymentToken, toMint)) => {
          let mintStake = Helpers.mintAndStake(
            ~marketIndex,
            ~token=paymentToken,
            ~user=testUser,
            ~longShort,
          )
          switch toMint {
          | Long(amount) => mintStake(~isLong=true, ~amount)
          | Short(amount) => mintStake(~isLong=false, ~amount)
          | Both(longAmount, shortAmount) =>
            mintStake(~isLong=true, ~amount=longAmount)->JsPromise.then(_ =>
              mintStake(~isLong=false, ~amount=shortAmount)
            )
          }
        })
        ->JsPromise.all
        ->JsPromise.map(_ => {
          ()
        })
        ->JsPromise.map(_ => {
          Chai.bnEqual(Ethers.BigNumber.fromInt(1), Ethers.BigNumber.fromUnsafe("1"))
          Chai.bnCloseTo(Ethers.BigNumber.fromInt(1), Ethers.BigNumber.fromUnsafe("5"), ~distance=4)
          Chai.bnWithin(
            Ethers.BigNumber.fromInt(1),
            ~min=Ethers.BigNumber.fromUnsafe("0"),
            ~max=Ethers.BigNumber.fromInt(2),
          )
          done()
        })
    })
  })
})
