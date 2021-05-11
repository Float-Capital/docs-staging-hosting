let {it: it', it_skip: it_skip', before_each, before} = module(BsMocha.Async)
let {describe, it, it_skip} = module(BsMocha.Mocha)

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

    it'("should update correct markets in the 'claimFloatCustom' function", done => {
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
          staker->Contract.Staker.claimFloatCustomUser(
            ~user=testUser,
            ~syntheticTokens=synthsUserHasStaked.contents,
            ~markets=marketsUserHasStakedIn.contents,
          )
        })
        ->JsPromise.map(_ => {
          synthsUserHasStaked.contents
          ->Array.map(synth => {
            JsPromise.all2((
              staker->Contract.Staker.userIndexOfLastClaimedReward(
                ~synthTokenAddr=synth.address,
                ~user=testUser.address,
              ),
              staker->Contract.Staker.latestRewardIndex(~synthTokenAddr=synth.address),
            ))->JsPromise.map(((userLastClaimed, latestRewardIndex)) =>
              Chai.bnEqual(userLastClaimed, latestRewardIndex)
            )
          })
          ->JsPromise.all
          ->JsPromise.map(_ => done())
        })
    })
  })
})
