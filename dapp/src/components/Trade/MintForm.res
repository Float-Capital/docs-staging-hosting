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
    ~isLong,
    ~marketName,
    ~tokenToMint,
    ~buttonText,
    ~buttonDisabled,
  ) => {
    switch (txStateApprove, txStateMint) {
    | (ContractActions.Created, _) => <>
        <Modal id={1}>
          <div className="text-center mx-3 my-6">
            <Loader.Ellipses />
            <p> {`Please approve your ${Config.paymentTokenName} token `->React.string} </p>
          </div>
        </Modal>
        <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
      </>
    | (ContractActions.SignedAndSubmitted(txHash), _) => <>
        <Modal id={2}>
          <div className="text-center m-3">
            <div className="m-2"> <Loader.Mini /> </div>
            <p> {"Approval transaction pending... "->React.string} </p>
            <ViewOnBlockExplorer txHash />
          </div>
        </Modal>
        <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
      </>
    | (ContractActions.Complete({transactionHash: _}), ContractActions.Created)
    | (ContractActions.Complete({transactionHash: _}), ContractActions.UnInitialised) => <>
        <Modal id={3}>
          <div className="text-center mx-3 my-6">
            <Loader.Ellipses />
            <p> {`Confirm transaction to mint ${tokenToMint}`->React.string} </p>
          </div>
        </Modal>
        <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
      </>
    | (ContractActions.Declined(_message), _) => <> {resetFormButton()} </>
    | (ContractActions.Failed(txHash), _) => <>
        <Modal id={4}>
          <div className="text-center m-3">
            <p> {`The transaction failed.`->React.string} </p>
            <ViewOnBlockExplorer txHash />
            <MessageUsOnDiscord />
          </div>
        </Modal>
        {resetFormButton()}
      </>
    | (_, ContractActions.Created) => <>
        <Modal id={5}>
          <div className="text-center m-3">
            <Loader.Ellipses />
            <h1> {`Confirm the transaction to mint ${tokenToMint}`->React.string} </h1>
          </div>
        </Modal>
        <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
      </>
    | (
        ContractActions.Complete({transactionHash}),
        ContractActions.SignedAndSubmitted(txHash),
      ) => <>
        <Modal id={6}>
          <div className="text-center m-3">
            <p> {`Approval confirmed 🎉`->React.string} </p>
            <ViewOnBlockExplorer txHash={transactionHash} />
            <h1>
              {`Pending minting ${tokenToMint}`->React.string} <ViewOnBlockExplorer txHash />
            </h1>
          </div>
        </Modal>
        <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
      </>
    | (_, ContractActions.SignedAndSubmitted(txHash)) => <>
        <Modal id={7}>
          <div className="text-center m-3">
            <div className="m-2"> <Loader.Mini /> </div>
            <p> {"Minting transaction pending... "->React.string} </p>
            <ViewOnBlockExplorer txHash />
          </div>
        </Modal>
        <Button disabled=true onClick={_ => ()}> {buttonText} </Button>
      </>
    | (_, ContractActions.Complete({transactionHash: _})) => <>
        <Modal id={8}>
          <div className="text-center m-3">
            <Tick />
            <p> {`Transaction complete 🎉`->React.string} </p>
            <TweetButton
              message={`I just went ${isLong
                  ? "long"
                  : "short"} on ${marketName}! @float_capital 🌊 `}
            />
            <Metamask.AddTokenButton
              token={Config.config.contracts.floatToken}
              tokenSymbol={`${isLong ? `↗️` : `↘️`}${marketName}`}
            />
            <ViewPositionButton />
          </div>
        </Modal>
      </>
    | (_, ContractActions.Declined(_message)) => <>
        <Modal id={9}>
          <div className="text-center m-3">
            <p> {`The transaction was rejected by your wallet`->React.string} </p>
            <MessageUsOnDiscord />
          </div>
        </Modal>
        {resetFormButton()}
      </>
    | (_, ContractActions.Failed(txHash)) => <>
        <Modal id={10}>
          <div className="text-center m-3">
            <h1> {`The transaction failed.`->React.string} </h1>
            <ViewOnBlockExplorer txHash />
            <MessageUsOnDiscord />
          </div>
        </Modal>
        {resetFormButton()}
      </>
    | _ => <Button disabled=buttonDisabled onClick={_ => ()}> {buttonText} </Button>
    }
  }
}

module MintFormInput = {
  @react.component
  let make = (
    ~onSubmit=_ => (),
    ~onChangeSide=_ => (),
    ~isLong,
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
    ~submitButton=<Button> "Login & Mint" </Button>,
  ) => {
    let router = Next.Router.useRouter()

    let formInput =
      <>
        <LongOrShortSelect isLong selectPosition={val => onChangeSide(val)} disabled />
        <AmountInput
          value=valueAmountInput
          optBalance={optDaiBalance}
          disabled
          onBlur=onBlurAmount
          onChange=onChangeAmountInput
          placeholder={"Mint"}
          optCurrency={Some(Config.paymentTokenName)}
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
              {`Stake ${isLong ? "long" : "short"} tokens `->React.string}
            </label>
            <div className="ml-1">
              <Tooltip tip="Stake your synthetic asset tokens to earn FLOAT tokens" />
            </div>
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

    <div className="screen-centered-container h-full ">
      <Form className="h-full" onSubmit>
        <div className="relative"> {formInput} </div> {submitButton}
      </Form>
      {if Config.networkId == 80001 {
        <p
          onClick={_ => {
            router->Next.Router.push(`/faucet`)
          }}
          className="cursor-pointer text-xxs py-2">
          {"Visit our "->React.string}
          <a className="hover:bg-white underline"> {"faucet"->React.string} </a>
          {" if you need more aave test DAI."->React.string}
        </p>
      } else {
        React.null
      }}
    </div>
  }
}

module MintFormSignedIn = {
  @react.component
  let make = (~market: Queries.SyntheticMarketInfo.t, ~isLong, ~signer) => {
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

    let (optDaiBalance, optDaiAmountApproved) = useBalanceAndApproved(
      ~erc20Address=Config.dai,
      ~spender=Config.longShort,
    )

    let form = MintForm.useForm(~initialInput, ~onSubmit=({amount, isStaking}, _form) => {
      let approveFunction = () =>
        contractExecutionHandlerApprove(
          ~makeContractInstance=Contracts.Erc20.make(~address=Config.dai),
          ~contractFunction=Contracts.Erc20.approve(
            ~amount=amount->Globals.amountForApproval,
            ~spender=Config.longShort,
          ),
        )
      let mintFunction = () =>
        contractExecutionHandler(
          ~makeContractInstance=Contracts.LongShort.make(~address=Config.longShort),
          ~contractFunction=isLong
            ? Contracts.LongShort.mintLong(~marketIndex=market.marketIndex, ~amount)
            : Contracts.LongShort.mintShort(~marketIndex=market.marketIndex, ~amount),
        )
      let mintAndStakeFunction = () =>
        contractExecutionHandler(
          ~makeContractInstance=Contracts.LongShort.make(~address=Config.longShort),
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
      let stakingText = form.input.isStaking ? "Mint & Stake" : "Mint"
      let approveConnector = form.input.isStaking ? "," : " &"

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

    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)
    let router = Next.Router.useRouter()

    // Execute the call after approval has completed
    React.useEffect1(() => {
      switch txStateApprove {
      | Created =>
        toastDispatch(
          ToastProvider.Show(
            `Please approve your ${Config.paymentTokenName} token`,
            "",
            ToastProvider.Info,
          ),
        )
      | Declined(reason) =>
        toastDispatch(
          ToastProvider.Show(
            `The transaction was rejected by your wallet`,
            reason,
            ToastProvider.Error,
          ),
        )
      | SignedAndSubmitted(_) =>
        toastDispatch(ToastProvider.Show(`Approval transaction processing`, "", ToastProvider.Info))
      | Complete(_) =>
        contractActionToCallAfterApproval()
        setTxStateApprove(_ => ContractActions.UnInitialised)
        toastDispatch(
          ToastProvider.Show(`Approve transaction confirmed`, "", ToastProvider.Success),
        )
      | Failed(_) =>
        toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
      | _ => ()
      }
      None
    }, [txStateApprove])

    React.useEffect1(() => {
      switch txState {
      | Created =>
        toastDispatch(
          ToastProvider.Show(`Sign the transaction to mint ${tokenToMint}`, "", ToastProvider.Info),
        )
      | SignedAndSubmitted(_) =>
        toastDispatch(ToastProvider.Show(`Minting transaction pending`, "", ToastProvider.Info))
      | Complete(_) =>
        toastDispatch(ToastProvider.Show(`Mint transaction confirmed`, "", ToastProvider.Success))
      | Failed(_) =>
        toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
      | Declined(reason) =>
        toastDispatch(
          ToastProvider.Show(
            `The transaction was rejected by your wallet`,
            reason,
            ToastProvider.Warning,
          ),
        )
      | _ => ()
      }
      None
    }, [txState])

    <MintFormInput
      onSubmit={form.submit}
      onChangeSide={newPosition => {
        router.query->Js.Dict.set("actionOption", newPosition)
        router.query->Js.Dict.set(
          "token",
          isLong
            ? market.syntheticLong.tokenAddress->Ethers.Utils.ethAdrToLowerStr
            : market.syntheticShort.tokenAddress->Ethers.Utils.ethAdrToLowerStr,
        )
        router->Next.Router.pushObjShallow({pathname: router.pathname, query: router.query})
      }}
      isLong={isLong}
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
        buttonText
        resetFormButton
        tokenToMint
        txStateApprove
        txStateMint=txState
        buttonDisabled
        isLong
        marketName={market.name}
      />}
    />
  }
}

@react.component
let make = (~market: Queries.SyntheticMarketInfo.t, ~isLong) => {
  let router = Next.Router.useRouter()

  let optSigner = ContractActions.useSigner()
  switch optSigner {
  | Some(signer) => <MintFormSignedIn signer market isLong />
  | None =>
    <div onClick={_ => router->Next.Router.push(`/login?nextPath=${router.asPath}`)}>
      <MintFormInput isLong />
    </div>
  }
}
