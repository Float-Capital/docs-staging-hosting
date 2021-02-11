let shortTokenAddress = Ethers.Utils.getAddressUnsafe("0x096c8301e153037df723c23e2de113941cb973ef")
let longTokenAddress = Ethers.Utils.getAddressUnsafe("0x096c8301e153037df723c23e2de113941cb973ef")

module Dapp = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let (isStartTrading, setIsStartTrading) = React.useState(_ => true) //set this to true in prod (need to add cookies to not show every time?)
    let (isMint, setIsMint) = React.useState(_ => true)
    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
        {"login to view this"->React.string}
      </h1>}>
      {!isStartTrading
        ? <StartTrading onClick={_ => setIsStartTrading(_ => true)} />
        : <section>
            <div className="screen-centered-container">
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
            <h1> {"Dapp"->React.string} </h1>
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
          </section>}
    </AccessControl>
  }
}
let default = () => <Dapp />
