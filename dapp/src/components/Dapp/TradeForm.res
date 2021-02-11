@react.component
let make = (~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets) => {
  let (isMint, setIsMint) = React.useState(_ => true)

  let signer = ContractActions.useSignerExn()

  let (contractExecutionHandler, txState, _setTxState) = ContractActions.useContractFunction(
    ~signer,
  )

  let longShortContractAddress = Config.useLongShortAddress()

  let (amount, setAmount) = React.useState(_ => "")

  let mintFunction = () =>
    contractExecutionHandler(
      ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
      ~contractFunction=Contracts.LongShort.mintLong(
        ~marketIndex=market.marketIndex,
        ~amount=Ethers.Utils.parseEtherUnsafe(~amount),
      ),
    )

  <div className="screen-centered-container">
    <div className="trade-form">
      <h2> {`${market.name} (${market.symbol})`->React.string} </h2>
      <select name="longshort" className="trade-select">
        <option value="long"> {`Long 🐮`->React.string} </option>
        <option value="short"> {`Short 🐻`->React.string} </option>
      </select>
      {isMint
        ? <input
            className="trade-input"
            placeholder="mint"
            value=amount
            onChange={e => {
              let mintAmount = ReactEvent.Form.target(e)["value"]
              setAmount(_ => mintAmount)
            }}
          />
        : <input className="trade-input" placeholder="redeem" />}
      <div className="trade-switch" onClick={_ => setIsMint(_ => !isMint)}>
        {j`↑↓`->React.string}
      </div>
      {isMint
        ? <input className="trade-input" placeholder="redeem" />
        : <input className="trade-input" placeholder="mint" />}
      <div>
        <Button onClick={_ => mintFunction()} text="OPEN POSITION" />
        <div className="float-button-outer-container">
          <div className="float-button-container">
            <button className="float-button" onClick={_ => mintFunction()}>
              {"OPEN POSITION"->React.string}
            </button>
          </div>
        </div>
      </div>
    </div>
    {
      let txExplererUrl = RootProvider.useEtherscanUrl()

      switch txState {
      | ContractActions.UnInitialised => React.null
      | ContractActions.Created => <>
          <h1> {"Processing Transaction "->React.string} <Loader /> </h1>
          <p> {"Tx created."->React.string} </p>
          <div> <Loader /> </div>
        </>
      | ContractActions.SignedAndSubmitted(txHash) => <>
          <h1> {"Processing Transaction "->React.string} <Loader /> </h1>
          <p>
            <a href=j`https://$txExplererUrl/tx/$txHash` target="_blank" rel="noopener noreferrer">
              {("View the transaction on " ++ txExplererUrl)->React.string}
            </a>
          </p>
          <Loader />
        </>
      | ContractActions.Complete(result) =>
        let txHash = result.transactionHash
        <>
          <h1> {"Transaction Complete "->React.string} <Loader /> </h1>
          <p>
            <a href=j`https://$txExplererUrl/tx/$txHash` target="_blank" rel="noopener noreferrer">
              {("View the transaction on " ++ txExplererUrl)->React.string}
            </a>
          </p>
        </>
      | ContractActions.Declined(message) => <>
          <h1>
            {"The transaction was declined by your wallet, please try again."->React.string}
          </h1>
          <p> {("Failure reason: " ++ message)->React.string} </p>
        </>
      | ContractActions.Failed => <>
          <h1> {"The transaction failed."->React.string} <Loader /> </h1>
          <p> {"This operation isn't permitted by the smart contract."->React.string} </p>
        </>
      }
    }
  </div>
}
