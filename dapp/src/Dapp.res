module Access = {
  @react.component
  let make = (~children) => {
    let optUser = RootProvider.useCurrentUser()

    switch optUser {
    | None => React.null
    | Some(_user) => children
    }
  }
}

let default = () => {
  let (isMint, setIsMint) = React.useState(() => true)
  <Access>
    <section>
      <div>
        <div className="trade-form">
          <h2> {"FTSE 100"->React.string} </h2>
          <select name="longshort" className="trade-select">
            <option value="long"> {`Long 🐮`->React.string} </option>
            <option value="short"> {`Short 🐻`->React.string} </option>
          </select>
          {isMint
            ? <input className="trade-input" placeholder="mint" />
            : <input className="trade-input" placeholder="redeem" />}
          <div className="trade-switch" onClick={_ => setIsMint(_ => !isMint)}>
            {j`↑↓`->React.string}
          </div>
          {isMint
            ? <input className="trade-input" placeholder="redeem" />
            : <input className="trade-input" placeholder="mint" />}
          <button className="trade-action"> {"OPEN POSITION"->React.string} </button>
        </div>
      </div>
      <br />
      <br />
      <br />
      <br />
      <br />
      <br />
      <br />
      <br />
      <div>
        <h1> {"Dapp Test functions"->React.string} </h1>
        <ApproveDai />
        <hr />
        <MintLong />
        <hr />
        <RedeemLong />
        <hr />
        <MintShort />
        <hr />
        <RedeemShort />
        <hr />
        <UpdateSystemState />
      </div>
    </section>
  </Access>
}
