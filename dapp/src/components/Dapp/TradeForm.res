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

let useBalanceAndApproved = (~erc20Address, ~spender) => {
  let {
    Swr.data: optBalance,
    isValidating: _isValidating,
    error: _errorLoadingBalance,
    mutate: _mutate,
  } = ContractHooks.useErc20Balance(~erc20Address)
  let {
    data: optAmountApproved,
    isValidating: _isValidating,
    error: _errorLoadingBalance,
    mutate: _mutate,
  } = ContractHooks.useERC20Approved(~erc20Address, ~spender)
  (optBalance, optAmountApproved)
}

let isGreaterThanApproval = (~amount, ~amountApproved) => {
  amount->Ethers.BigNumber.gt(amountApproved)
}
let isGreaterThanBalance = (~amount, ~balance) => {
  amount->Ethers.BigNumber.gt(balance)
}

@react.component
let make = (~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets) => {
  let signer = ContractActions.useSignerExn()

  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(~signer)
  let (
    contractExecutionHandlerApprove,
    txStateApprove,
    setTxStateApprove,
  ) = ContractActions.useContractFunction(~signer)
  let (
    contractActionToCallAfterApproval,
    setContractActionToCallAfterApproval,
  ) = React.useState(((), ()) => ())

  let longShortContractAddress = Config.useLongShortAddress()
  let daiAddressThatIsTemporarilyHardCoded = Config.useDaiAddress()

  // NOTE: this is heavy and slow, we fetch 6 values from the blockchain every time this component mounts. Maybe move some of this to the graph?
  let (optDaiBalance, optDaiAmountApproved) = useBalanceAndApproved(
    ~erc20Address=daiAddressThatIsTemporarilyHardCoded,
    ~spender=longShortContractAddress,
  )
  let (optShortBalance, optShortAmountApproved) = useBalanceAndApproved(
    ~erc20Address=market.syntheticShort.tokenAddress,
    ~spender=longShortContractAddress,
  )
  let (optLongBalance, optLongAmountApproved) = useBalanceAndApproved(
    ~erc20Address=market.syntheticLong.tokenAddress,
    ~spender=longShortContractAddress,
  )

  let form = TradeForm.useForm(~initialInput, ~onSubmit=({amount, isMint, isLong}, _form) => {
    switch (isMint, isLong) {
    | (true, true) =>
      let mintFunction = () =>
        contractExecutionHandler(
          ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
          ~contractFunction=Contracts.LongShort.mintLong(~marketIndex=market.marketIndex, ~amount),
        )
      switch isGreaterThanApproval(
        ~amount,
        ~amountApproved=optDaiAmountApproved->Option.getWithDefault(
          Ethers.BigNumber.fromUnsafe("0"),
        ),
      ) {
      | true =>
        setContractActionToCallAfterApproval(_ => mintFunction)
        contractExecutionHandlerApprove(
          ~makeContractInstance=Contracts.Erc20.make(~address=daiAddressThatIsTemporarilyHardCoded),
          ~contractFunction=Contracts.Erc20.approve(
            ~amount=amount->Ethers.BigNumber.mul(Ethers.BigNumber.fromUnsafe("2")),
            ~spender=longShortContractAddress,
          ),
        )
      | false => mintFunction()
      }
    | (true, false) =>
      let mintFunction = () =>
        contractExecutionHandler(
          ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
          ~contractFunction=Contracts.LongShort.mintShort(~marketIndex=market.marketIndex, ~amount),
        )
      switch isGreaterThanApproval(
        ~amount,
        ~amountApproved=optDaiAmountApproved->Option.getWithDefault(
          Ethers.BigNumber.fromUnsafe("0"),
        ),
      ) {
      | true =>
        setContractActionToCallAfterApproval(_ => mintFunction)
        contractExecutionHandlerApprove(
          ~makeContractInstance=Contracts.Erc20.make(~address=daiAddressThatIsTemporarilyHardCoded),
          ~contractFunction=Contracts.Erc20.approve(
            ~amount=amount->Ethers.BigNumber.mul(Ethers.BigNumber.fromUnsafe("2")),
            ~spender=longShortContractAddress,
          ),
        )
      | false => mintFunction()
      }
    | (false, true) =>
      contractExecutionHandler(
        ~makeContractInstance=Contracts.SyntheticToken.make(
          ~address=market.syntheticShort.tokenAddress,
        ),
        ~contractFunction=Contracts.SyntheticToken.redeem(~amount),
      )
    | (false, false) =>
      contractExecutionHandler(
        ~makeContractInstance=Contracts.SyntheticToken.make(
          ~address=market.syntheticLong.tokenAddress,
        ),
        ~contractFunction=Contracts.SyntheticToken.redeem(~amount),
      )
    }
  })
  let formAmount = switch form.amountResult {
  | Some(Ok(amount)) => Some(amount)
  | _ => None
  }
  let (optAdditionalErrorMessage, _buttonText, _buttonDisabled) = {
    switch (form.input.isMint, form.input.isLong) {
    | (true, isLong) =>
      // let is(optDaiBalance, optDaiAmountApproved,
      let position = isLong ? "LONG" : "SHORT"
      switch (formAmount, optDaiBalance, optDaiAmountApproved) {
      // NOTE: for simplicity skipping some permutations or edge cases.
      | (Some(amount), Some(balance), Some(amountApproved)) =>
        let prefix = isGreaterThanApproval(~amount, ~amountApproved) ? "" : "Approve & "
        let greaterThanBalance = isGreaterThanBalance(~amount, ~balance)
        switch greaterThanBalance {
        | false => (None, `1MINT ${position}`, false)
        | true => (Some("Amount is greater than your balance"), `${prefix}2Mint ${position}`, true)
        }
      | _ => (None, `3Mint ${position}`, true)
      }
    // TODO: this doesn't check if the balance is greater for these two...
    | (false, true) => (None, "Redeem Long", false)
    | (false, false) => (None, "Redeem Short", false)
    }
  }

  // Execute the call after approval has completed
  React.useEffect1(() => {
    switch txStateApprove {
    | Complete(_) =>
      contractActionToCallAfterApproval()
      setTxStateApprove(_ => ContractActions.UnInitialised)
    | _ => ()
    }
    None
  }, [txStateApprove])

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
            // <div className="flex flex-row">
            //   <input
            //     className="h-16 bg-gray-100 text-grey-darker py-2 font-normal text-grey-darkest border border-gray-100 font-bold w-full py-1 px-2 outline-none text-lg text-gray-600"
            //     type_="text"
            //     placeholder="What do you want to learn?"
            //   />
            //   <span
            //     className="flex items-center bg-gray-100 rounded rounded-l-none border-0 px-3 font-bold text-grey-100">
            //     <span onClick={_ => form.updateAmount((input, amount) => {
            //           ...input,
            //           amount: amount,
            //         }, switch optDaiBalance {
            //         | Some(daiBalance) => daiBalance->Ethers.Utils.formatEther
            //         | _ => "0"
            //         })}> {"MAX"->React.string} </span>
            //   </span>
            // </div>
            <div className="flex flex-row m-3">
              <input
                id="amount"
                className="py-2 font-normal text-grey-darkest w-full py-1 px-2 outline-none text-md text-gray-600"
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
              <span
                className="flex items-center bg-gray-100 hover:bg-white hover:text-grey-darkest px-5 font-bold">
                <span onClick={_ => form.updateAmount((input, amount) => {
                      ...input,
                      amount: amount,
                    }, switch optDaiBalance {
                    | Some(daiBalance) => daiBalance->Ethers.Utils.formatEther
                    | _ => "0"
                    })}> {"MAX"->React.string} </span>
              </span>
            </div>
            {switch (form.amountResult, optAdditionalErrorMessage) {
            | (Some(Error(message)), _)
            | (_, Some(message)) =>
              <div className="text-red-600"> {message->React.string} </div>
            | (Some(Ok(_)), None) => <div className="text-green-600"> {j`✓`->React.string} </div>
            | (None, None) => React.null
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
      <Button onClick={_ => Js.log("I was clicked")} variant="large">
        {`${_buttonText} ${form.input.isMint ? "Mint" : "Redeem"} ${form.input.isLong
            ? "long"
            : "short"} position`}
      </Button>
    </Form>
    {// {Config.isDevMode // <- this can be used to hide this code when not developing
    //   ? <>

    switch txState {
    | ContractActions.UnInitialised => React.null
    | ContractActions.Created => <> <h1> {"Processing Approval "->React.string} </h1> <Loader /> </>
    | ContractActions.SignedAndSubmitted(_txHash) => <>
        <h1> {"Processing Approval - submitted "->React.string} <Loader /> </h1> <Loader />
      </>
    | ContractActions.Complete({transactionHash: _txHash}) => <>
        <h1> {"Approval Complete, Sign the next transaction "->React.string} </h1>
      </>
    | ContractActions.Declined(message) => <>
        <h1> {"The transaction was declined by your wallet, please try again."->React.string} </h1>
        <p> {("Failure reason: " ++ message)->React.string} </p>
      </>
    | ContractActions.Failed => <>
        <h1> {"The transaction failed."->React.string} </h1>
        <p> {"This operation isn't permitted by the smart contract."->React.string} </p>
      </>
    }}
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
    {
      let formatOptBalance = Option.mapWithDefault(_, "Loading", Ethers.Utils.formatEther)
      <code>
        <p> {"dev only component to display balances"->React.string} </p>
        <p>
          {`dai - balance: ${optDaiBalance->formatOptBalance} - approved: ${optDaiAmountApproved->formatOptBalance}`->React.string}
        </p>
        <p>
          {`long - balance: ${optLongBalance->formatOptBalance} - approved: ${optLongAmountApproved->formatOptBalance}`->React.string}
        </p>
        <p>
          {`short - balance: ${optShortBalance->formatOptBalance} - approved: ${optShortAmountApproved->formatOptBalance}`->React.string}
        </p>
      </code>
    }

    //   </>
    // : React.null}
  </div>
}
