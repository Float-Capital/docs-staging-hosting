open GqlConverters
module ApolloQueryResult = ApolloClient.Types.ApolloQueryResult

// TODO: make this still work when tests go further than 1000 items
module GetAllStateChanges = %graphql(`query {
  stateChanges (first:1000) {
    id
    txEventParamList {
      eventName
      params {
        param
        paramName
        paramType
      }
    }
    affectedStakes {
      id
    }
    blockNumber
    timestamp
    affectedUsers {
      id
      address
    }
  }
}`)

let getAllStateChanges = () =>
  Client.instance.query(~query=module(GetAllStateChanges), ())->Js.Promise.then_(result => {
    switch result {
    | Ok({ApolloQueryResult.data: {GetAllStateChanges.stateChanges: stateChanges}}) =>
      Js.Promise.resolve(stateChanges)
    | Error(error) => Js.Promise.reject(error->Obj.magic)
    }
  }, _)

module GetLatestMintTime = %graphql(`query ($userAddress: ID!, $blockNumber: Int!) {
  user(id: $userAddress, block: {number: $blockNumber}) {
    id
  }
}`)

let getUsersLatestMintTimeAtBlockNumber = (~blockNumber, ~userAddress) =>
  Client.instance.query(
    ~query=module(GetLatestMintTime),
    {blockNumber: blockNumber, userAddress: userAddress},
  )->Js.Promise.then_(result => {
    switch result {
    | Ok({ApolloQueryResult.data: {GetLatestMintTime.user: Some(_)}}) =>
      Js.Promise.resolve(Some("->"->Obj.magic))
    | Ok({ApolloQueryResult.data: _}) => Js.Promise.resolve(None)
    | Error(error) => Js.Promise.reject(error->Obj.magic)
    }
  }, _)

module GetGlobalState = %graphql(`query ($blockNumber: Int!) {
  globalState(id: "globalState", block: {number: $blockNumber}) {
    id
    contractVersion
    latestMarketIndex
    staker {
      id
    }
    tokenFactory {
      id
    }
    adminAddress
    longShort {
      id
    }
    totalFloatMinted
    totalTxs
    totalGasUsed
    totalUsers
    timestampLaunched
    txHash
  }
}`)

let getGlobalStateAtBlock = (~blockNumber) =>
  Client.instance.query(
    ~query=module(GetGlobalState),
    {blockNumber: blockNumber},
  )->Js.Promise.then_(result => {
    switch result {
    | Ok({ApolloQueryResult.data: {GetGlobalState.globalState: Some(_)}}) =>
      Js.Promise.resolve(Some("->"->Obj.magic))
    | Ok({ApolloQueryResult.data: _}) => Js.Promise.resolve(None)
    | Error(error) => Js.Promise.reject(error->Obj.magic)
    }
  }, _)
