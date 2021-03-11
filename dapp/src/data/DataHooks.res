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
