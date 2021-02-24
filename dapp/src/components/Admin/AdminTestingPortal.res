open Globals

// Functionality that is for testing only can go here (temporarily)

module AdminContext = {
  type t = {privateKeyMode: bool, ethersWallet: option<Ethers.Wallet.t>}
  let context = React.createContext(None)

  module Provider = {
    let privKeyStorageId = "admin-private-key"
    @react.component
    let make = (~children) => {
      let getPrivateKeyFromLocalStorage = Dom.Storage2.getItem(_, privKeyStorageId)
      let optAuthHeader = Misc.optLocalstorage->Option.flatMap(getPrivateKeyFromLocalStorage)
      let (authSet, setAuthSet) = {
        React.useState(_ => optAuthHeader->Option.isSome)
      }
      let (authHeader, setAuthHeader) = React.useState(() =>
        optAuthHeader->Option.getWithDefault("")
      )
      let (privateKeyMode, setPrivateKeyMode) = React.useState(() => true)

      let onChange = (e: ReactEvent.Form.t): unit => {
        let value = (e->ReactEvent.Form.target)["value"]
        setAuthHeader(value)
      }

      let provider = React.Context.provider(context)

      let optCurrentUser = RootProvider.useCurrentUser()

      let optProvider = RootProvider.useWeb3()
      let optEthersSigner = optProvider->Option.flatMap(provider =>
        switch (privateKeyMode, authSet) {
        | (false, _) =>
          optCurrentUser->Option.flatMap(usersAddress =>
            provider->Ethers.Providers.getSigner(usersAddress)
          )
        | (true, true) =>
          optAuthHeader->Option.map(authHeader =>
            Ethers.Wallet.makePrivKeyWallet(authHeader, provider)
          )
        | (true, false) => None
        }
      )

      let authDisplay =
        <div>
          {switch optCurrentUser {
          | Some(_) => <>
              <span className="inline-flex">
                <p> {"Use injectod provider?"->React.string} </p>
                <input
                  type_="checkbox"
                  checked={!privateKeyMode}
                  onChange={_ => setPrivateKeyMode(_ => !privateKeyMode)}
                />
              </span>
              <br />
            </>
          | None => React.null
          }}
          {authSet || !privateKeyMode
            ? <>
                {privateKeyMode
                  ? <>
                      <button onClick={_ => setAuthSet(_ => false)}>
                        {"Edit your auth key"->React.string}
                      </button>
                      <br />
                    </>
                  : React.null}
                children
              </>
            : <form
                onSubmit={event => {
                  Dom.Storage2.localStorage->Dom.Storage2.setItem(privKeyStorageId, authHeader)

                  ReactEvent.Form.preventDefault(event)

                  setAuthSet(_ => true)
                }}>
                <label> {React.string("Auth Key: ")} </label>
                <input type_="text" name="auth_key" onChange />
                <button type_="submit"> {React.string("submit")} </button>
                <br />
                <br />
                <br />
                <p>
                  {"NOTE: you may need to reload the webpage after doing this to activate the key"->React.string}
                </p>
              </form>}
        </div>

      React.createElement(provider, {"value": optEthersSigner, "children": authDisplay})
    }
  }
}

module AdminActions = {
  @react.component
  let make = () => {
    let optEthersWallet = React.useContext(AdminContext.context)
    let optNetwork = RootProvider.useChainId()
    let marketDetailsQuery = Queries.MarketDetails.use()

    switch optEthersWallet {
    | Some(ethersWallet) =>
      <div>
        <h1> {"Test Functions"->React.string} </h1>
        <div className={"border-dashed border-4 border-light-red-500"}>
          <ApproveDai />
          {switch optNetwork {
          // Don't display the DAI mint button on testnet
          | Some(97) => React.null
          | _ => <MintDai ethersWallet />
          }}
          <hr />
          <h1> {"Market specific Functions:"->React.string} </h1>
          {switch marketDetailsQuery {
          | {loading: true} => "Loading..."->React.string
          | {error: Some(_error)} => "Error loading data"->React.string
          | {data: Some({syntheticMarkets})} => <>
              {syntheticMarkets
              ->Array.map(({
                name,
                symbol,
                marketIndex,
                syntheticLong: {tokenAddress: tokenAddressLong},
                syntheticShort: {tokenAddress: tokenAddressShort},
              }) =>
                <div key=symbol className="w-full">
                  <h1 className="w-full text-5xl underline text-center">
                    {`Market ${name} (${symbol})`->React.string}
                  </h1>
                  <div className="flex justify-between items-center w-full">
                    <div>
                      <h1> {`Long(${tokenAddressLong->ethAdrToStr})`->React.string} </h1>
                      <MintLong marketIndex />
                      <RedeemSynth marketIndex isLong=true />
                      <MintAndStake marketIndex isLong=true />
                    </div>
                    <div>
                      <h1> {`Short(${tokenAddressShort->ethAdrToStr})`->React.string} </h1>
                      <MintShort marketIndex />
                      <RedeemSynth marketIndex isLong=false />
                      <MintAndStake marketIndex isLong=false />
                    </div>
                  </div>
                </div>
              )
              ->React.array}
            </>
          | {data: None, error: None, loading: false} =>
            "You might think this is impossible, but depending on the situation it might not be!"->React.string
          }}
          <hr />
          <div> <h1> {"Users active stakes"->React.string} </h1> <ActiveStakes /> </div>
          <hr />
          <div> <h1> {"Float"->React.string} </h1> <FloatManagement /> </div>
        </div>
      </div>
    | None =>
      <h1>
        {"No provider is selected. Even if you are using your own private key you still need to login with metamask for the connection to ethereum."->React.string}
      </h1>
    }
  }
}

let default = () => <AdminContext.Provider> <AdminActions /> </AdminContext.Provider>
