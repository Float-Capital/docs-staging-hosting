let useGetStakes = () => {
  let stakeDetailsQuery = Queries.StakingDetails.use()
  let client = Client.useApolloClient()

  React.useEffect0(() => {
    let _ = client.query(~query=module(Queries.StakingDetails), ())->JsPromise.map(queryResult =>
      switch queryResult {
      | Ok({data: {syntheticMarkets}}) =>
        let _ = syntheticMarkets->Array.map(({syntheticLong, syntheticShort}) => {
          let _ = client.writeQuery(
            ~query=module(Queries.SyntheticToken),
            ~data={syntheticToken: Some(syntheticLong)},
            {tokenId: syntheticLong.id},
          )
          let _ = client.writeQuery(
            ~query=module(Queries.SyntheticToken),
            ~data={syntheticToken: Some(syntheticShort)},
            {tokenId: syntheticShort.id},
          )
        })
      | Error(_) => ()
      }
    )
    None
  })

  stakeDetailsQuery
}

@ocaml.doc(`Represents a graphql query response.`)
type graphResponse<'a> = Loading | GraphError(string) | Response('a)

@ocaml.doc(`Returns a live estimate of how much float the user is owed for the given synthetic token stake.`)
let useFloatDetailsForUser = (~userId, ~synthToken) => {
  let currentTimestamp = Misc.Time.useCurrentTimeBN(~updateInterval=1000)
  let floatDetailsQuery = Queries.UsersFloatDetails.use({
    userId: userId,
    synthToken: synthToken,
  })

  switch floatDetailsQuery {
  | {
      data: Some({
        states: [{accumulativeFloatPerToken, floatRatePerTokenOverInterval}],
        currentStakes: [
          {
            lastMintState: {accumulativeFloatPerToken: lastAccumulativeFloatPerToken, timestamp},
            currentStake: {amount},
          },
        ],
      }),
    } => {
      // The amount of float the user is owed up to the last staker state.
      // Note that accumulativeFloatPerToken is in e42 scale (see Staker.sol).
      let claimableFloat =
        Ethers.BigNumber.sub(accumulativeFloatPerToken, lastAccumulativeFloatPerToken)
        ->Ethers.BigNumber.mul(amount)
        ->Ethers.BigNumber.div(CONSTANTS.tenToThe42)

      // The amount of float the user is predicted to earn between the last
      // staker state and now. This is an estimate, as we don't have data
      // from the LongShort contract to compute the true float rate.
      let predictedFloat =
        Ethers.BigNumber.sub(currentTimestamp, timestamp)
        ->Ethers.BigNumber.mul(floatRatePerTokenOverInterval)
        ->Ethers.BigNumber.mul(amount)
        ->Ethers.BigNumber.div(CONSTANTS.tenToThe42)

      Response((claimableFloat, predictedFloat))
    }
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}

@ocaml.doc(`Returns a list of stakes for the given user.`)
let useStakesForUser = (~userId) => {
  let activeStakesQuery = Queries.UsersStakes.use({
    userId: userId,
  })

  switch activeStakesQuery {
  | {data: Some({currentStakes})} => Response(currentStakes)
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}
