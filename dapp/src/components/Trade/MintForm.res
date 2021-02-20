module MintForm = %form(
  type input = {amount: string, isLong: bool, isStaking: bool}
  type output = {amount: Ethers.BigNumber.t, isLong: bool, isStaking: bool}

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
    isLong: {
      strategy: OnFirstChange,
      validate: ({isLong}) => isLong->Ok,
    },
    isStaking: None,
  }
)

let initialInput: MintForm.input = {
  amount: "",
  isLong: false,
  isStaking: true,
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
  let {Swr.data: optShortBalance} = ContractHooks.useErc20Balance(
    ~erc20Address=market.syntheticShort.tokenAddress,
  )
  let {Swr.data: optLongBalance} = ContractHooks.useErc20Balance(
    ~erc20Address=market.syntheticLong.tokenAddress,
  )

  let form = MintForm.useForm(~initialInput, ~onSubmit=({amount, isLong}, _form) => {
    switch isLong {
    | true =>
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
    | false =>
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
    }
  })

  let formAmount = switch form.amountResult {
  | Some(Ok(amount)) => Some(amount)
  | _ => None
  }

  let (optAdditionalErrorMessage, _buttonText, _buttonDisabled) = {
    let stakingText = form.input.isStaking ? "" : "" // TODO: decide on this " & stake" : ""
    switch form.input.isLong {
    | isLong =>
      let position = isLong ? "long" : "short"
      switch (formAmount, optDaiBalance, optDaiAmountApproved) {
      | (Some(amount), Some(balance), Some(amountApproved)) =>
        let needsToApprove = isGreaterThanApproval(~amount, ~amountApproved)
        let greaterThanBalance = isGreaterThanBalance(~amount, ~balance)
        switch greaterThanBalance {
        | true => (Some("Amount is greater than your balance"), `Insufficient balance`, true)
        | false => (
            None,
            switch needsToApprove {
            | true => `Approve & mint ${position} position`
            | false => `Mint${stakingText} ${position} position`
            },
            false,
          )
        }
      | _ => (None, `Mint${stakingText} ${position} position`, true)
      }
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
    <ViewBox>
      <Form
        className="this-is-required"
        onSubmit={() => {
          form.submit()
        }}>
        <div className="flex justify-between">
          <h2> {`${market.name} (${market.symbol})`->React.string} </h2>
          <Next.Link href="/redeem">
            <span className="text-xs hover:text-gray-500 cursor-pointer">
              {"Redeem"->React.string}
            </span>
          </Next.Link>
        </div>
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
        <AmountInput
          value=form.input.amount
          optBalance={optDaiBalance->Option.getWithDefault(0->Ethers.BigNumber.fromInt)}
          disabled=form.submitting
          onBlur={_ => form.blurAmount()}
          onChange={event => form.updateAmount((input, amount) => {
              ...input,
              amount: amount,
            }, (event->ReactEvent.Form.target)["value"])}
          placeholder={"Mint"}
          onMaxClick={_ => form.updateAmount((input, amount) => {
              ...input,
              amount: amount,
            }, switch optDaiBalance {
            | Some(daiBalance) => daiBalance->Ethers.Utils.formatEther
            | _ => "0"
            })}
        />
        {switch (form.amountResult, optAdditionalErrorMessage) {
        | (Some(Error(message)), _)
        | (_, Some(message)) =>
          <div className="text-red-500 text-xs"> {message->React.string} </div>
        | (Some(Ok(_)), None) => React.null
        | (None, None) => React.null
        }}
        <div className="flex justify-between items-center">
          <div className="flex items-center">
            <input
              id="stake-checkbox"
              type_="checkbox"
              className="mr-2"
              checked={form.input.isStaking}
              disabled={form.submitting}
              onBlur={_ => form.blurIsStaking()}
              onChange={event =>
                form.updateIsStaking(
                  (input, value) => {...input, isStaking: value},
                  (event->ReactEvent.Form.target)["checked"],
                )}
            />
            <label htmlFor="stake-checkbox" className="text-xs">
              {`Stake ${form.input.isLong ? "long" : "short"} tokens`->React.string}
            </label>
          </div>
          <p className="text-xxs hover:text-gray-500">
            <a href="https://docs.float.capital"> {"Learn more about staking?"->React.string} </a>
          </p>
        </div>
        // <Toggle onClick={_ => Js.log("I was toggled")} preLabel="stake " postLabel="" />
        <Button onClick={_ => ()} variant="large"> {_buttonText} </Button>
      </Form>
    </ViewBox>
    {Config.isDevMode // <- this can be used to hide this code when not developing
      ? <>
          {switch txState {
          | ContractActions.UnInitialised => React.null
          | ContractActions.Created => <>
              <h1> {"Processing Approval "->React.string} </h1> <Loader />
            </>
          | ContractActions.SignedAndSubmitted(_txHash) => <>
              <h1> {"Processing Approval - submitted "->React.string} <Loader /> </h1> <Loader />
            </>
          | ContractActions.Complete({transactionHash: _txHash}) => <>
              <h1> {"Approval Complete, Sign the next transaction "->React.string} </h1>
            </>
          | ContractActions.Declined(message) => <>
              <h1>
                {"The transaction was declined by your wallet, please try again."->React.string}
              </h1>
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
                  <a
                    href=j`https://$txExplererUrl/tx/$txHash`
                    target="_blank"
                    rel="noopener noreferrer">
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
                  <a
                    href=j`https://$txExplererUrl/tx/$txHash`
                    target="_blank"
                    rel="noopener noreferrer">
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
              <p> {`long - balance: ${optLongBalance->formatOptBalance}`->React.string} </p>
              <p> {`short - balance: ${optShortBalance->formatOptBalance}`->React.string} </p>
            </code>
          }
        </>
      : React.null}
  </div>
}
