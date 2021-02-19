let useUsersStakes = (~address) => {
  let (executeQuery, _) = Queries.UsersStakes.useLazy()

  React.useEffect1(() => {
    executeQuery({userId: address})
    None
  }, [StateChangeMonitor.useDataFreshnessString()])

  Queries.UsersStakes.use({userId: address})
}
