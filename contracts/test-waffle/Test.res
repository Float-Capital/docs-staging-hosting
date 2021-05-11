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
      let {longShort, markets, staker} = contracts.contents
      let testUser = accounts.contents->Array.getUnsafe(1)
      let synthsUserHasStaked = ref([])
      let marketsUserHasStakedIn = ref([])

      let _testPromise =
        markets
        ->Array.map(market => {
          (market, Helpers.randomMintLongShort())
        })
        ->Array.map((({paymentToken, longSynth, shortSynth, marketIndex}, toMint)) => {
          Js.log("Setting up stakes")
          let mintStake = Helpers.mintAndStake(
            ~marketIndex,
            ~token=paymentToken,
            ~user=testUser,
            ~longShort,
          )
          marketsUserHasStakedIn := marketsUserHasStakedIn.contents->Array.concat([marketIndex])
          switch toMint {
          | Long(amount) =>
            synthsUserHasStaked := synthsUserHasStaked.contents->Array.concat([longSynth])
            mintStake(~isLong=true, ~amount)
          | Short(amount) =>
            synthsUserHasStaked := synthsUserHasStaked.contents->Array.concat([shortSynth])
            mintStake(~isLong=false, ~amount)
          | Both(longAmount, shortAmount) =>
            synthsUserHasStaked :=
              synthsUserHasStaked.contents->Array.concat([shortSynth, shortSynth])
            mintStake(~isLong=true, ~amount=longAmount)->JsPromise.then(_ =>
              mintStake(~isLong=false, ~amount=shortAmount)
            )
          }
        })
        ->JsPromise.all
        ->JsPromise.then(_ => {
          Js.log("Claiming float!")
          Js.log(marketsUserHasStakedIn.contents)
          staker->Contract.Staker.claimFloatCustomUser(
            ~user=testUser,
            ~syntheticTokens=synthsUserHasStaked.contents,
            ~markets=marketsUserHasStakedIn.contents,
          )
        })
        ->JsPromise.map(_ => {
          Js.log("got this far")
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
