module TradeForm = %form(
  type input = {amount: string, isMint: bool, isLong: bool}
  type output = {amount: Ethers.BigNumber.t, isMint: bool, isLong: bool}

  let validators = {
    amount: {
      strategy: OnFirstBlur,
      validate: ({amount}) => {
        let amountRegex = %bs.re(`/^[+]?\d+(\.\d+)?$/`)

        switch amount {
        | "" => Error("Amount is required")
        | value when !(amountRegex->Js.Re.test_(value)) =>
          Error("Incorrect number format - please use '.' for floating points.")
        | amount =>
          Ethers.Utils.parseEther(~amount)->Option.mapWithDefault(
            Error("Couldn't parse Ether value"),
            etherValue => etherValue->Ok,
          )
        }
      },
    },
    isMint: {
      strategy: OnFirstChange,
      validate: ({isMint}) => isMint->Ok,
    },
    isLong: {
      strategy: OnFirstChange,
      validate: ({isLong}) => isLong->Ok,
    },
  }
)

let initialInput: TradeForm.input = {
  amount: "",
  isMint: true,
  isLong: false,
}

@react.component
let make = (~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets) => {
  let signer = ContractActions.useSignerExn()

  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(~signer)

  let longShortContractAddress = Config.useLongShortAddress()

  let form = TradeForm.useForm(~initialInput, ~onSubmit=({amount, isMint, isLong}, _form) => {
    switch (isMint, isLong) {
    | (true, true) =>
      contractExecutionHandler(
        ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
        ~contractFunction=Contracts.LongShort.mintLong(~marketIndex=market.marketIndex, ~amount),
      )
    | (false, true) =>
      contractExecutionHandler(
        ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
        ~contractFunction=Contracts.LongShort.redeemLong(
          ~marketIndex=market.marketIndex,
          ~tokensToRedeem=amount,
        ),
      )
    | (true, false) =>
      contractExecutionHandler(
        ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
        ~contractFunction=Contracts.LongShort.mintShort(~marketIndex=market.marketIndex, ~amount),
      )
    | (false, false) =>
      contractExecutionHandler(
        ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
        ~contractFunction=Contracts.LongShort.redeemShort(
          ~marketIndex=market.marketIndex,
          ~tokensToRedeem=amount,
        ),
      )
    }
  })

  <div className="screen-centered-container">
    <Form
      className="trade-form"
      onSubmit={() => {
        form.submit()
      }}>
      <h2> {`${market.name} (${market.symbol})`->React.string} </h2>
      <select
        name="longshort"
        className="trade-select"
        onChange={event =>
          form.updateIsLong(
            (input, isLong) => {...input, isLong: isLong},
            (event->ReactEvent.Form.target)["value"] == "long",
          )}
        value={form.input.isLong ? "long" : "short"}
        onBlur={_ => form.blurAmount()}
        disabled=form.submitting>
        <option value="long"> {`Long 🐮`->React.string} </option>
        <option value="short"> {`Short 🐻`->React.string} </option>
      </select>
      {form.input.isMint
        ? <>
            <input
              id="amount"
              className="trade-input"
              type_="text"
              placeholder="mint"
              value=form.input.amount
              disabled=form.submitting
              onBlur={_ => form.blurAmount()}
              onChange={event => form.updateAmount((input, amount) => {
                  ...input,
                  amount: amount,
                }, (event->ReactEvent.Form.target)["value"])}
            />
            {switch form.amountResult {
            | Some(Error(message)) => <div className="text-red-600"> {message->React.string} </div>
            | Some(Ok(_)) => <div className="text-green-600"> {j`✓`->React.string} </div>
            | None => React.null
            }}
          </>
        : <input className="trade-input" placeholder="redeem" />}
      <div className="trade-switch" onClick={_ => form.updateIsMint((input, isMint) => {
            ...input,
            isMint: isMint,
          }, !form.input.isMint)}> {j`↑↓`->React.string} </div>
      {form.input.isMint
        ? <input className="trade-input" placeholder="redeem" />
        : <input className="trade-input" placeholder="mint" />}
      <button className="trade-action"> {"OPEN POSITION"->React.string} </button>
    </Form>
    {
      let txExplererUrl = RootProvider.useEtherscanUrl()

      let resetTxButton =
        <button onClick={_ => setTxState(_ => ContractActions.UnInitialised)}>
          {">>Reset tx<<"->React.string}
        </button>

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
          <h1> {"Transaction Complete "->React.string} </h1>
          <p>
            <a href=j`https://$txExplererUrl/tx/$txHash` target="_blank" rel="noopener noreferrer">
              {("View the transaction on " ++ txExplererUrl)->React.string}
            </a>
          </p>
          resetTxButton
        </>
      | ContractActions.Declined(message) => <>
          <h1>
            {"The transaction was declined by your wallet, please try again."->React.string}
          </h1>
          <p> {("Failure reason: " ++ message)->React.string} </p>
          resetTxButton
        </>
      | ContractActions.Failed => <>
          <h1> {"The transaction failed."->React.string} </h1>
          <p> {"This operation isn't permitted by the smart contract."->React.string} </p>
          resetTxButton
        </>
      }
    }
  </div>
}
