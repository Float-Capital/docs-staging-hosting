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
          Js.log("a")
          optCurrentUser->Option.flatMap(usersAddress =>
            provider->Ethers.Providers.getSigner(usersAddress)
          )
        | (true, true) =>
          Js.log("b")
          optAuthHeader->Option.map(authHeader =>
            Ethers.Wallet.makePrivKeyWallet(authHeader, provider)
          )
        | (true, false) =>
          Js.log("c")
          None
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

    switch optEthersWallet {
    | Some(ethersWallet) =>
      <div>
        <h1> {"Test Functions"->React.string} </h1>
        <div className={"border-dashed border-4 border-light-red-500"}>
          <ApproveDai />
          <MintDai ethersWallet />
          // {}
          <h1> {"Market specific Functions:"->React.string} </h1>
          {switch Queries.MarketDetails.use() {
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
                      <h1> {`Long(${tokenAddressLong->Ethers.Utils.toString})`->React.string} </h1>
                      <MintLong marketIndex />
                      <RedeemSynth synthTokenAddres=tokenAddressLong />
                    </div>
                    <div>
                      <h1>
                        {`Short(${tokenAddressShort->Ethers.Utils.toString})`->React.string}
                      </h1>
                      <MintShort marketIndex />
                      <RedeemSynth synthTokenAddres=tokenAddressShort />
                    </div>
                  </div>
                </div>
              )
              ->React.array}
            </>
          | {data: None, error: None, loading: false} =>
            "You might think this is impossible, but depending on the situation it might not be!"->React.string
          }}
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
