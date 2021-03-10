module MintForm = %form(
  type input = {amount: string, isLong: bool, isStaking: bool}
  type output = {amount: Ethers.BigNumber.t, isLong: bool, isStaking: bool}

  let validators = {
    amount: {
      strategy: OnFirstSuccessOrFirstBlur,
      validate: ({amount}) => {
        let amountRegex = %re(`/^[+]?\d+(\.\d+)?$/`)

        switch amount {
        | "" => Error("Amount is required")
        | value if !(amountRegex->Js.Re.test_(value)) =>
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
  let {Swr.data: optBalance} = ContractHooks.useErc20BalanceRefresh(~erc20Address)
  let {data: optAmountApproved} = ContractHooks.useERC20ApprovedRefresh(~erc20Address, ~spender)
  (optBalance, optAmountApproved)
}

let isGreaterThanApproval = (~amount, ~amountApproved) => {
  amount->Ethers.BigNumber.gt(amountApproved)
}
let isGreaterThanBalance = (~amount, ~balance) => {
  amount->Ethers.BigNumber.gt(balance)
}

module SubmitButtonAndTxTracker = {
  @react.component
  let make = (
    ~txStateApprove,
    ~txStateMint,
    ~resetFormButton,
    ~tokenToMint,
    ~buttonText,
    ~buttonDisabled,
  ) => {
    switch (txStateApprove, txStateMint) {
    | (ContractActions.Created, _) => <>
        <h1>
          {`Please Approve that Float can use your ${Config.paymentTokenName}`->React.string}
        </h1>
      </>
    | (ContractActions.SignedAndSubmitted(txHash), _) =>
      <h1>
        <a target="_" href={`${Config.defaultBlockExplorer}tx/${txHash}`}>
          {"Processing Approval "->React.string}
        </a>
      </h1>
    | (ContractActions.Complete({transactionHash}), ContractActions.Created)
    | (ContractActions.Complete({transactionHash}), ContractActions.UnInitialised) => <>
        <h1>
          <a target="_" href={`${Config.defaultBlockExplorer}tx/${transactionHash}`}>
            {`✅ Approval Complete`->React.string}
          </a>
        </h1>
        <h1> {`Sign the next transaction to mint your`->React.string} </h1>
      </>
    | (ContractActions.Declined(message), _) => <>
        <h1>
          {`❌ The transaction was declined by your wallet, you need to accept the transaction to proceed.`->React.string}
        </h1>
        <p> {("Failure reason: " ++ message)->React.string} </p>
        {resetFormButton()}
      </>
    | (ContractActions.Failed, _) => <>
        <h1> {`❌ The transaction failed.`->React.string} </h1>
        <p>
          <a target="_" href=Config.discordInviteLink>
            {"This shouldn't happen, please let us help you on discord."->React.string}
          </a>
        </p>
        {resetFormButton()}
      </>
    | (_, ContractActions.Created) => <>
        <h1>
          {`Sign the transaction to mint ${tokenToMint} with your ${Config.paymentTokenName}`->React.string}
        </h1>
      </>
    | (
        ContractActions.Complete({transactionHash}),
        ContractActions.SignedAndSubmitted(txHash),
      ) => <>
        <h1>
          <a target="_" href={`${Config.defaultBlockExplorer}tx/${transactionHash}`}>
            {`✅ Approval Complete`->React.string}
          </a>
        </h1>
        <h1>
          <a target="_" href={`${Config.defaultBlockExplorer}tx/${txHash}`}>
            {`Processing minting ${tokenToMint} with your ${Config.paymentTokenName}`->React.string}
          </a>
        </h1>
        {resetFormButton()}
      </>
    | (_, ContractActions.SignedAndSubmitted(txHash)) => <>
        <h1>
          <a target="_" href={`${Config.defaultBlockExplorer}tx/${txHash}`}>
            {`Processing minting ${tokenToMint} with your ${Config.paymentTokenName}`->React.string}
          </a>
        </h1>
        {resetFormButton()}
      </>
    | (_, ContractActions.Complete({transactionHash})) => <>
        <h1>
          <a target="_" href={`${Config.defaultBlockExplorer}tx/${transactionHash}`}>
            {`✅ Transaction Complete`->React.string}
          </a>
        </h1>
        {resetFormButton()}
      </>
    | (_, ContractActions.Declined(message)) => <>
        <h1>
          {`❌ The transaction was declined by your wallet, you need to accept the transaction to proceed.`->React.string}
        </h1>
        <p> {("Failure reason: " ++ message)->React.string} </p>
        {resetFormButton()}
      </>
    | (_, ContractActions.Failed) => <>
        <h1> {`❌ The transaction failed.`->React.string} </h1>
        <p>
          <a target="_" href=Config.discordInviteLink>
            {"This shouldn't happen, please let us help you on discord."->React.string}
          </a>
        </p>
        {resetFormButton()}
      </>
    | _ => <Button disabled=buttonDisabled onClick={_ => ()} variant="large"> {buttonText} </Button>
    }
  }
}

@react.component
let make = (
  ~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets,
  ~initialIsLong,
) => {
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

  let form = MintForm.useForm(
    ~initialInput={
      ...initialInput,
      isLong: initialIsLong,
    },
    ~onSubmit=({amount, isLong, isStaking}, _form) => {
      let approveFunction = () =>
        contractExecutionHandlerApprove(
          ~makeContractInstance=Contracts.Erc20.make(~address=daiAddressThatIsTemporarilyHardCoded),
          ~contractFunction=Contracts.Erc20.approve(
            ~amount=amount->Ethers.BigNumber.mul(Ethers.BigNumber.fromUnsafe("2")),
            ~spender=longShortContractAddress,
          ),
        )
      let mintFunction = () =>
        contractExecutionHandler(
          ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
          ~contractFunction=isLong
            ? Contracts.LongShort.mintLong(~marketIndex=market.marketIndex, ~amount)
            : Contracts.LongShort.mintShort(~marketIndex=market.marketIndex, ~amount),
        )
      let mintAndStakeFunction = () =>
        contractExecutionHandler(
          ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
          ~contractFunction=isLong
            ? Contracts.LongShort.mintLongAndStake(~marketIndex=market.marketIndex, ~amount)
            : Contracts.LongShort.mintShortAndStake(~marketIndex=market.marketIndex, ~amount),
        )
      let needsToApprove = isGreaterThanApproval(
        ~amount,
        ~amountApproved=optDaiAmountApproved->Option.getWithDefault(
          Ethers.BigNumber.fromUnsafe("0"),
        ),
      )

      switch needsToApprove {
      | true =>
        setContractActionToCallAfterApproval(_ => isStaking ? mintAndStakeFunction : mintFunction)
        approveFunction()
      | false => isStaking ? mintAndStakeFunction() : mintFunction()
      }
    },
  )

  let formAmount = switch form.amountResult {
  | Some(Ok(amount)) => Some(amount)
  | _ => None
  }

  let tokenToMint = form.input.isLong ? `long ${market.name}` : `short ${market.name}`

  let (optAdditionalErrorMessage, buttonText, buttonDisabled) = {
    let stakingText = form.input.isStaking ? "Mint & Stake" : "Mint" // TODO: decide on this " & stake" : ""
    let approveConnector = form.input.isStaking ? "," : " &" // TODO: decide on this " & stake" : ""
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
            | true => `Approve${approveConnector} ${stakingText} ${position} position`
            | false => `${stakingText} ${position} position`
            },
            !form.valid(),
          )
        }
      | _ => (None, `${stakingText} ${position} position`, true)
      }
    }
  }

  // Execute the call after approval has completed
  React.useEffect1(() => {
    switch txStateApprove {
    | Complete(_) => contractActionToCallAfterApproval()
    // setTxStateApprove(_ => ContractActions.UnInitialised)
    | _ => ()
    }
    None
  }, [txStateApprove])

  let resetFormButton = () =>
    <Button
      onClick={_ => {
        form.reset()
        setTxStateApprove(_ => ContractActions.UnInitialised)
        setTxState(_ => ContractActions.UnInitialised)
      }}>
      {"Reset & Mint Again"}
    </Button>

  let formInput =
    <>
      <div className="flex justify-between mb-2">
        <h2> {`${market.name} (${market.symbol})`->React.string} </h2>
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
        optBalance={optDaiBalance}
        disabled=form.submitting
        onBlur={_ => form.blurAmount()}
        onChange={event => form.updateAmount((input, amount) => {
            ...input,
            amount: amount,
          }, (event->ReactEvent.Form.target)["value"])}
        placeholder={"Mint"}
        onMaxClick={_ =>
          form.updateAmount(
            (input, amount) => {
              ...input,
              amount: amount,
            },
            switch optDaiBalance {
            | Some(daiBalance) => daiBalance->Ethers.Utils.formatEther
            | _ => "0"
            },
          )}
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
          <a href="https://docs.float.capital/docs/stake">
            {"Learn more about staking"->React.string}
          </a>
        </p>
      </div>
    </>

  <div className="screen-centered-container">
    <ViewBox>
      <Form
        className=""
        onSubmit={() => {
          form.submit()
        }}>
        <div className="relative">
          {formInput}
          {switch (txStateApprove, txState) {
          | (ContractActions.SignedAndSubmitted(_), _)
          | (ContractActions.Created, _)
          | (_, ContractActions.SignedAndSubmitted(_))
          | (_, ContractActions.Created) =>
            <Loader.Overlay />
          | _ => React.null
          }}
        </div>
        <SubmitButtonAndTxTracker
          buttonText resetFormButton tokenToMint txStateApprove txStateMint=txState buttonDisabled
        />
      </Form>
    </ViewBox>
  </div>
}
/* module MintFormInput = {
  @react.component
  let make = (
    ~onSubmit=_ => (),
    ~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets,
    ~onChangeSide=_ => (),
    ~isLong,
    ~onBlurSide=_ => (),
    ~valueAmountInput="",
    ~optDaiBalance=None,
    ~onBlurAmountInput=_ => (),
    ~onChangeAmountInput=_ => (),
    ~onMaxClick=_ => (),
    ~optErrorMessage=None,
    ~isStaking=true,
    ~disabled,
    ~onBlurIsStaking=_ => (),
    ~onChangeIsStaking,
    ~buttonText,
  ) =>
    <ViewBox>
      <Form className="this-is-required" onSubmit>
        <div className="flex justify-between mb-2">
          <h2> {`${market.name} (${market.symbol})`->React.string} </h2>
        </div>
        <select
          name="longshort"
          className="trade-select"
          onChange=onChangeSide
          value={isLong ? "long" : "short"}
          onBlur=onBlurSide
          disabled>
          <option value="long"> {`Long 🐮`->React.string} </option>
          <option value="short"> {`Short 🐻`->React.string} </option>
        </select>
        <AmountInput
          value=valueAmountInput
          optBalance={optDaiBalance}
          disabled
          onBlur=onBlurAmountInput
          onChange=onChangeAmountInput
          placeholder={"Mint"}
          onMaxClick
        />
        {switch optErrorMessage {
        | Some(message) => <div className="text-red-500 text-xs"> {message->React.string} </div>
        | None => React.null
        }}
        <div className="flex justify-between items-center">
          <div className="flex items-center">
            <input
              id="stake-checkbox"
              type_="checkbox"
              className="mr-2"
              checked={isStaking}
              disabled
              onBlur=onBlurIsStaking
              onChange=onChangeIsStaking
            />
            <label htmlFor="stake-checkbox" className="text-xs">
              {`Stake ${isLong ? "long" : "short"} tokens`->React.string}
            </label>
          </div>
          <p className="text-xxs hover:text-gray-500">
            <a href="https://docs.float.capital/docs/stake">
              {"Learn more about staking"->React.string}
            </a>
          </p>
        </div>
        // <Toggle onClick={_ => Js.log("I was toggled")} preLabel="stake " postLabel="" />
        <Button onClick={_ => ()} variant="large"> {buttonText} </Button>
      </Form>
    </ViewBox>
}
module MintFormSignedIn = {
  @react.component
  let make = (
    ~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets,
    ~initialIsLong,
    ~signer,
  ) => {
    let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(
      ~signer,
    )
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
    let {Swr.data: optShortBalance} = ContractHooks.useErc20BalanceRefresh(
      ~erc20Address=market.syntheticShort.tokenAddress,
    )
    let {Swr.data: optLongBalance} = ContractHooks.useErc20BalanceRefresh(
      ~erc20Address=market.syntheticLong.tokenAddress,
    )

    let form = MintForm.useForm(
      ~initialInput={
        ...initialInput,
        isLong: initialIsLong,
      },
      ~onSubmit=({amount, isLong, isStaking}, _form) => {
        let approveFunction = () =>
          contractExecutionHandlerApprove(
            ~makeContractInstance=Contracts.Erc20.make(
              ~address=daiAddressThatIsTemporarilyHardCoded,
            ),
            ~contractFunction=Contracts.Erc20.approve(
              ~amount=amount->Ethers.BigNumber.mul(Ethers.BigNumber.fromUnsafe("2")),
              ~spender=longShortContractAddress,
            ),
          )
        let mintFunction = () =>
          contractExecutionHandler(
            ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
            ~contractFunction=isLong
              ? Contracts.LongShort.mintLong(~marketIndex=market.marketIndex, ~amount)
              : Contracts.LongShort.mintShort(~marketIndex=market.marketIndex, ~amount),
          )
        let mintAndStakeFunction = () =>
          contractExecutionHandler(
            ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
            ~contractFunction=isLong
              ? Contracts.LongShort.mintLongAndStake(~marketIndex=market.marketIndex, ~amount)
              : Contracts.LongShort.mintShortAndStake(~marketIndex=market.marketIndex, ~amount),
          )
        let needsToApprove = isGreaterThanApproval(
          ~amount,
          ~amountApproved=optDaiAmountApproved->Option.getWithDefault(
            Ethers.BigNumber.fromUnsafe("0"),
          ),
        )

        switch needsToApprove {
        | true =>
          setContractActionToCallAfterApproval(_ => isStaking ? mintAndStakeFunction : mintFunction)
          approveFunction()
        | false => isStaking ? mintAndStakeFunction() : mintFunction()
        }
      },
    )

    let formAmount = switch form.amountResult {
    | Some(Ok(amount)) => Some(amount)
    | _ => None
    }

    let (optAdditionalErrorMessage, _buttonText, _buttonDisabled) = {
      let stakingText = form.input.isStaking ? "Mint & Stake" : "Mint" // TODO: decide on this " & stake" : ""
      let approveConnector = form.input.isStaking ? "," : " &" // TODO: decide on this " & stake" : ""
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
              | true => `Approve${approveConnector} ${stakingText} ${position} position`
              | false => `${stakingText} ${position} position`
              },
              false,
            )
          }
        | _ => (None, `${stakingText} ${position} position`, true)
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

    <MintFormInput
      onSubmit={form.submit}
      market
      onChangeSide={event =>
        form.updateIsLong(
          (input, isLong) => {...input, isLong: isLong},
          (event->ReactEvent.Form.target)["value"] == "long",
        )}
      isLong={form.input.isLong}
      onBlurSide={form.blurAmount}
      valueAmountInput=form.input.amount
      optDaiBalance
      onBlurAmountInput={_ => form.blurAmount()}
      onChangeAmountInput={event => form.updateAmount((input, amount) => {
          ...input,
          amount: amount,
        }, (event->ReactEvent.Form.target)["value"])}
      onMaxClick={_ =>
        form.updateAmount(
          (input, amount) => {
            ...input,
            amount: amount,
          },
          switch optDaiBalance {
          | Some(daiBalance) => daiBalance->Ethers.Utils.formatEther
          | _ => "0"
          },
        )}
      isStaking={form.input.isStaking}
      disabled={form.submitting}
      onBlurIsStaking={_ => form.blurIsStaking()}
      onChangeIsStaking={event =>
        form.updateIsStaking(
          (input, value) => {...input, isStaking: value},
          (event->ReactEvent.Form.target)["checked"],
        )}
      optErrorMessage=None
    />
    // errorMessage={swich(form.amountResult, optAdditionalErrorMessage) {
    // | (Some(Error(message)), _)
    // | (_, Some(message)) => Some(message)
    // | (Some(Ok(_)), None)
    // | (None, None) => None
    // }}
  }
}

@react.component
let make = (
  ~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets,
  ~initialIsLong,
  ~signer,
) => {
  <div className="screen-centered-container" />
}
*/
