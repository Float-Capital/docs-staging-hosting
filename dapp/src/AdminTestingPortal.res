// Functionality that is for testing only can go here (temporarily)
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

    let onChange = (e: ReactEvent.Form.t): unit => {
      let value = (e->ReactEvent.Form.target)["value"]
      setAuthHeader(value)
    }

    authSet
      ? <>
          <button onClick={_ => setAuthSet(_ => false)}>
            {"Edit your auth key"->React.string}
          </button>
          <br />
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
        </form>
  }
}

module AdminActions = {
  @react.component
  let make = () => {
    <div> <Authenticate> <h1> {"Test Functions"->React.string} </h1> </Authenticate> </div>
  }
}

let default = () => <AdminActions />
