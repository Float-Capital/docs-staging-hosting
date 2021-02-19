let useUsersStakes = (~address) => {
  let userId = address->Ethers.Utils.toString->Js.String.toLowerCase
  let (executeQuery, _) = Queries.UsersStakes.useLazy()

  React.useEffect1(() => {
    executeQuery({userId: userId})
    None
  }, [StateChangeMonitor.useDataFreshnessString()])

  Queries.UsersStakes.use({userId: userId})
}
