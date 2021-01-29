// Functionality that is for testing only can go here (temporarily)

module AdminContext = {
  type t = {privateKeyMode: bool, ethersWallet: option<Ethers.Wallet.t>}
  let defaultContext = {privateKeyMode: true, ethersWallet: None}
  let context = React.createContext(defaultContext)

  module Authenticate = {
    let privKeyStorageId = "admin-private-key"
    @react.component
    let make = (~children) => {
      let getPrivateKeyFromLocalStorage = Dom.Storage2.getItem(_, privKeyStorageId)

      let (authSet, setAuthSet) = {
        React.useState(_ =>
          Misc.optLocalstorage->Option.flatMap(getPrivateKeyFromLocalStorage)->Option.isSome
        )
      }
      let (authHeader, setAuthHeader) = React.useState(() => "")
      let (privateKeyMode, setPrivateKeyMode) = React.useState(() => true)

      let onChange = (e: ReactEvent.Form.t): unit => {
        let value = (e->ReactEvent.Form.target)["value"]
        setAuthHeader(value)
      }

      let provider = React.Context.provider(context)

      let state = {privateKeyMode: privateKeyMode, ethersWallet: None}

      let optCurrentUser = RootProvider.useCurrentUser()

      let authDisplay =
        <div>
          {switch optCurrentUser {
          | Some(_) =>
            <span>
              <p> {"Use injectod provider?"->React.string} </p>
              <input
                type_="checkbox"
                checked={!privateKeyMode}
                onChange={_ => setPrivateKeyMode(_ => !privateKeyMode)}
              />
            </span>
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

      React.createElement(provider, {"value": state, "children": authDisplay})
    }
  }
}

module AdminActions = {
  @react.component
  let make = () => {
    <div>
      <AdminContext.Authenticate>
        <h1> {"Test Functions"->React.string} </h1>
      </AdminContext.Authenticate>
    </div>
  }
}

let default = () => <AdminActions />
