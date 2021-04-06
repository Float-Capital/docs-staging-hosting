module MintForm = %form(
  type input = {amount: string, isStaking: bool}
  type output = {amount: Ethers.BigNumber.t, isStaking: bool}

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
    isStaking: None,
  }
)

let initialInput: MintForm.input = {
  amount: "",
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
    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

    switch (txStateApprove, txStateMint) {
    | (ContractActions.Created, _) =>
      React.useEffect1(() => {
        toastDispatch(
          ToastProvider.Show(
            `Please approve your ${Config.paymentTokenName} token`,
            "",
            ToastProvider.Info,
          ),
        )
        None
      }, [])
      <div className="text-center m-3">
        <p> {`Please approve your ${Config.paymentTokenName} token `->React.string} </p>
      </div>
    | (ContractActions.SignedAndSubmitted(txHash), _) =>
      React.useEffect1(() => {
        toastDispatch(ToastProvider.Show(`Approval transaction processing`, "", ToastProvider.Info))
        None
      }, [])
      <div className="text-center m-3">
        <MiniLoader />
        <p> {"Approval transaction pending... "->React.string} </p>
        <a target="_" rel="noopenner noreferer" href={`${Config.defaultBlockExplorer}tx/${txHash}`}>
          <p> {`View on ${Config.defaultBlockExplorerName}`->React.string} </p>
        </a>
      </div>
    | (ContractActions.Complete({transactionHash}), ContractActions.Created)
    | (ContractActions.Complete({transactionHash}), ContractActions.UnInitialised) =>
      React.useEffect1(() => {
        toastDispatch(
          ToastProvider.Show(`Approval transaction confirmed`, "", ToastProvider.Success),
        )
        None
      }, [])
      // Put inside timeout for 3 seconds
      // React.useEffect1(() => {
      //   toastDispatch(
      //     ToastProvider.Show(`Confirm transaction to mint ${tokenToMint}`, "", ToastProvider.Success),
      //   )
      //   None
      // }, [])
      <div className="text-center m-3">
        <p> {`Confirm transaction to mint ${tokenToMint}`->React.string} </p>
      </div>
    | (ContractActions.Declined(message), _) =>
      React.useEffect1(() => {
        toastDispatch(
          ToastProvider.Show(
            `The transaction was rejected by your wallet`,
            message,
            ToastProvider.Error,
          ),
        )
        None
      }, [])
      <> {resetFormButton()} </>
    | (ContractActions.Failed, _) =>
      React.useEffect1(() => {
        toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
        None
      }, [])
      <div className="text-center m-3">
        <p> {`The transaction failed.`->React.string} </p>
        <p>
          <a target="_" rel="noopenner noreferer" href=Config.discordInviteLink>
            {"Connect with us on discord, if you would like some assistance"->React.string}
          </a>
        </p>
        {resetFormButton()}
      </div>
    | (_, ContractActions.Created) =>
      React.useEffect1(() => {
        toastDispatch(
          ToastProvider.Show(`Sign the transaction to mint ${tokenToMint}`, "", ToastProvider.Info),
        )
        None
      }, [])
      <div className="text-center m-3">
        <h1> {`Sign the transaction to mint ${tokenToMint}`->React.string} </h1>
      </div>
    | (ContractActions.Complete({transactionHash}), ContractActions.SignedAndSubmitted(txHash)) =>
      React.useEffect1(() => {
        toastDispatch(ToastProvider.Show(`Approval confirmed`, "", ToastProvider.Success))
        None
      }, [])
      <div className="text-center m-3">
        <p>
          <a
            target="_"
            rel="noopenner noreferer"
            href={`${Config.defaultBlockExplorer}tx/${transactionHash}`}>
            {`Approval confirmes`->React.string}
          </a>
        </p>
        <h1>
          <a
            target="_"
            rel="noopenner noreferer"
            href={`${Config.defaultBlockExplorer}tx/${txHash}`}>
            {`Pending minting ${tokenToMint}`->React.string}
          </a>
        </h1>
      </div>
    | (_, ContractActions.SignedAndSubmitted(txHash)) =>
      React.useEffect1(() => {
        toastDispatch(ToastProvider.Show(`Minting transaction pending`, "", ToastProvider.Info))
        None
      }, [])
      <div className="text-center m-3">
        <MiniLoader />
        <p> {"Minting transaction pending... "->React.string} </p>
        <a
          className="hover:underline"
          target="_"
          rel="noopenner noreferer"
          href={`${Config.defaultBlockExplorer}tx/${txHash}`}>
          <p> {`View on ${Config.defaultBlockExplorerName}`->React.string} </p>
        </a>
      </div>
    | (_, ContractActions.Complete({transactionHash})) =>
      React.useEffect1(() => {
        toastDispatch(ToastProvider.Show(`Transaction complete`, "", ToastProvider.Success))
        None
      }, [])
      <div className="text-center m-3">
        <p> {`Transaction complete`->React.string} </p> {resetFormButton()}
      </div>
    | (_, ContractActions.Declined(message)) =>
      React.useEffect1(() => {
        toastDispatch(
          ToastProvider.Show(
            `The transaction was rejected by your wallet`,
            message,
            ToastProvider.Error,
          ),
        )
        None
      }, [])
      <div className="text-center m-3">
        <p> {`The transaction was rejected by your wallet`->React.string} </p>
        <a target="_" rel="noopenner noreferer" href=Config.discordInviteLink>
          {"Connect with us on discord, if you would like some assistance"->React.string}
        </a>
        {resetFormButton()}
      </div>
    | (_, ContractActions.Failed) =>
      React.useEffect1(() => {
        toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
        None
      }, [])
      <div className="text-center m-3">
        <h1> {`The transaction failed.`->React.string} </h1>
        <p>
          <a target="_" rel="noopenner noreferer" href=Config.discordInviteLink>
            {"Connect with us on discord, if you would like some assistance"->React.string}
          </a>
        </p>
        {resetFormButton()}
      </div>
    | _ => <Button disabled=buttonDisabled onClick={_ => ()}> {buttonText} </Button>
    }
  }
}

module MintFormInput = {
  @react.component
  let make = (
    ~onSubmit=_ => (),
    ~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets,
    ~onChangeSide=_ => (),
    ~isLong,
    ~onBlurSide=_ => (),
    ~valueAmountInput="",
    ~optDaiBalance=None,
    ~onBlurAmount=_ => (),
    ~onChangeAmountInput=_ => (),
    ~onMaxClick=_ => (),
    ~optErrorMessage=None,
    ~isStaking=true,
    ~disabled=false,
    ~onBlurIsStaking=_ => (),
    ~onChangeIsStaking=_ => (),
    ~txStateApprove=ContractActions.UnInitialised,
    ~txStateMint=ContractActions.UnInitialised,
    ~submitButton=<Button> "Login & Mint" </Button>,
  ) => {
    let formInput =
      <>
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
          onBlur=onBlurAmount
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
            <a
              href="https://docs.float.capital/docs/stake"
              target="_blank"
              rel="noopenner noreferrer">
              {"Learn more about staking"->React.string}
            </a>
          </p>
        </div>
      </>

    <div className="screen-centered-container h-full">
      <ViewBox>
        <Form className="h-full" onSubmit>
          <div className="relative">
            {formInput}
            {switch (txStateApprove, txStateMint) {
            | (ContractActions.SignedAndSubmitted(_), _)
            | (ContractActions.Created, _)
            | (_, ContractActions.SignedAndSubmitted(_))
            | (_, ContractActions.Created) =>
              <span />
            | _ => React.null
            }}
          </div>
          {submitButton}
        </Form>
      </ViewBox>
    </div>
  }
}

module MintFormSignedIn = {
  @react.component
  let make = (
    ~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets,
    ~isLong,
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

    let (optDaiBalance, optDaiAmountApproved) = useBalanceAndApproved(
      ~erc20Address=daiAddressThatIsTemporarilyHardCoded,
      ~spender=longShortContractAddress,
    )

    let form = MintForm.useForm(~initialInput, ~onSubmit=({amount, isStaking}, _form) => {
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
    })

    let formAmount = switch form.amountResult {
    | Some(Ok(amount)) => Some(amount)
    | _ => None
    }

    let resetFormButton = () =>
      <Button
        onClick={_ => {
          form.reset()
          setTxStateApprove(_ => ContractActions.UnInitialised)
          setTxState(_ => ContractActions.UnInitialised)
        }}>
        {"Reset & Mint Again"}
      </Button>

    let tokenToMint = isLong ? `long ${market.name}` : `short ${market.name}`

    let (optAdditionalErrorMessage, buttonText, buttonDisabled) = {
      let stakingText = form.input.isStaking ? "Mint & Stake" : "Mint" // TODO: decide on this " & stake" : ""
      let approveConnector = form.input.isStaking ? "," : " &" // TODO: decide on this " & stake" : ""

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

    let router = Next.Router.useRouter()

    <MintFormInput
      txStateApprove
      txStateMint=txState
      onSubmit={form.submit}
      market
      onChangeSide={event => {
        router.query->Js.Dict.set("mintOption", (event->ReactEvent.Form.target)["value"])
        router->Next.Router.pushObjShallow({pathname: router.pathname, query: router.query})
      }}
      isLong={isLong}
      onBlurSide={_ => form.blurIsStaking()}
      valueAmountInput=form.input.amount
      optDaiBalance
      onBlurAmount={_ => form.blurAmount()}
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
      optErrorMessage=optAdditionalErrorMessage
      submitButton={<SubmitButtonAndTxTracker
        buttonText resetFormButton tokenToMint txStateApprove txStateMint=txState buttonDisabled
      />}
    />
  }
}

@react.component
let make = (~market: Queries.MarketDetails.MarketDetails_inner.t_syntheticMarkets, ~isLong) => {
  let router = Next.Router.useRouter()

  let optSigner = ContractActions.useSigner()
  switch optSigner {
  | Some(signer) => <MintFormSignedIn signer market isLong />
  | None =>
    <div onClick={_ => router->Next.Router.push(`/login?nextPath=${router.asPath}`)}>
      <MintFormInput market isLong />
    </div>
  }
}
