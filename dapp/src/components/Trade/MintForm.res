module MintForm = %form(
  type input = {amount: string}
  type output = {amount: Ethers.BigNumber.t}

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
  }
)

let initialInput: MintForm.input = {
  amount: "",
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
    let randomMintTweetMessage = (isLong, marketName) => {
      let position = isLong ? "long" : "short"
      let possibleTweetMessages = [
        `Boom bam baby!💥 I just minted ${position} tokens on ${marketName}! @float_capital 🌊`,
        `Look at me, look at me! I just went ${position} on ${marketName}! 🐬 @float_capital 🌊`,
        `Cue Jaws music! 🦈 I just went ${position} on ${marketName}! @float_capital 🌊`,
      ]
      possibleTweetMessages->Array.getUnsafe(
        Js.Math.random_int(0, possibleTweetMessages->Array.length),
      )
    }

    let {showModal, hideModal} = ModalProvider.useModalDisplay()

    React.useEffect2(_ => {
      switch (txStateApprove, txStateMint) {
      | (ContractActions.Created, _) =>
        showModal(
          <div className="text-center mx-3 my-6">
            <Loader.Ellipses />
            <p> {`Please approve your ${Config.paymentTokenName} token `->React.string} </p>
          </div>,
        )

      | (ContractActions.SignedAndSubmitted(txHash), _) =>
        showModal(
          <div className="text-center m-3">
            <div className="m-2"> <Loader.Mini /> </div>
            <p> {"Approval transaction pending... "->React.string} </p>
            <ViewOnBlockExplorer txHash />
          </div>,
        )
      | (ContractActions.Complete({transactionHash: _}), ContractActions.Created)
      | (ContractActions.Complete({transactionHash: _}), ContractActions.UnInitialised) =>
        showModal(
          <div className="text-center mx-3 my-6">
            <Loader.Ellipses />
            <p> {`Confirm transaction to mint ${tokenToMint}`->React.string} </p>
          </div>,
        )
      | (ContractActions.Failed(txHash), _) =>
        showModal(
          <div className="text-center m-3">
            <p> {`The transaction failed.`->React.string} </p>
            <ViewOnBlockExplorer txHash />
            <MessageUsOnDiscord />
          </div>,
        )
      | (_, ContractActions.Created) =>
        showModal(
          <div className="text-center m-3">
            <Loader.Ellipses />
            <h1> {`Confirm the transaction to mint ${tokenToMint}`->React.string} </h1>
          </div>,
        )
      | (ContractActions.Complete({transactionHash}), ContractActions.SignedAndSubmitted(txHash)) =>
        showModal(
          <div className="text-center m-3">
            <p> {`Approval confirmed 🎉`->React.string} </p>
            <ViewOnBlockExplorer txHash={transactionHash} />
            <h1>
              {`Pending minting ${tokenToMint}`->React.string} <ViewOnBlockExplorer txHash />
            </h1>
          </div>,
        )
      | (_, ContractActions.SignedAndSubmitted(txHash)) =>
        showModal(
          <div className="text-center m-3">
            <div className="m-2"> <Loader.Mini /> </div>
            <p> {"Minting transaction pending... "->React.string} </p>
            <ViewOnBlockExplorer txHash />
          </div>,
        )
      | (_, ContractActions.Complete({transactionHash: _})) =>
        showModal(
          <div className="text-center m-3">
            <Tick />
            <p> {`Transaction complete 🎉`->React.string} </p>
            <TweetButton message={randomMintTweetMessage(isLong, marketName)} />
            <Metamask.AddTokenButton
              token={Config.config.contracts.floatToken}
              tokenSymbol={`${isLong ? `↗️` : `↘️`}${marketName}`}
            />
            <ViewProfileButton />
          </div>,
        )
      | (_, ContractActions.Declined(_message)) =>
        showModal(
          <div className="text-center m-3">
            <p> {`The transaction was rejected by your wallet`->React.string} </p>
            <MessageUsOnDiscord />
          </div>,
        )
      | (_, ContractActions.Failed(txHash)) =>
        showModal(
          <div className="text-center m-3">
            <h1> {`The transaction failed.`->React.string} </h1>
            <ViewOnBlockExplorer txHash />
            <MessageUsOnDiscord />
          </div>,
        )
      | _ => hideModal()
      }
      None
    }, (txStateMint, txStateApprove))

    switch (txStateApprove, txStateMint) {
    | (ContractActions.Declined(_), _)
    | (ContractActions.Failed(_), _)
    | (_, ContractActions.Complete({transactionHash: _}))
    | (_, ContractActions.Declined(_))
    | (_, ContractActions.Failed(_)) =>
      resetFormButton()
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
    ~disabled=false,
    ~submitButton=<Button> "Login & Mint" </Button>,
  ) => {
    let router = Next.Router.useRouter()
    let onramp: Ramp.rampInstantSDK = Ramp.useRamp()

    let formInput =
      <>
        <LongOrShortSelect isLong selectPosition={val => onChangeSide(val)} disabled />
        <AmountInput
          value=valueAmountInput
          optBalance={optDaiBalance}
          disabled
          onBlur=onBlurAmount
          onChange=onChangeAmountInput
          optCurrency={Some(CONSTANTS.daiDisplayToken)}
          onMaxClick
        />
        {switch optErrorMessage {
        | Some(message) => <div className="text-red-500 text-xs"> {message->React.string} </div>
        | None => React.null
        }}
      </>

    <div className="screen-centered-container h-full ">
      <Form className="h-full" onSubmit>
        <div className="relative"> {formInput} </div> {submitButton}
      </Form>
      {if Config.networkId == CONSTANTS.mumbai.chainId && router.pathname != "/" {
        <p
          onClick={_ => {
            router->Next.Router.push(`/app/faucet`)
          }}
          className="cursor-pointer text-xxs py-2">
          {"Visit our "->React.string}
          <a className="hover:bg-white underline"> {"faucet"->React.string} </a>
          {" if you need more aave test DAI."->React.string}
        </p>
      } else if Config.networkId == CONSTANTS.polygon.chainId && router.pathname != "/" {
        <div className="inline-block px-2">
          <div
            className="flex flex-row justify-start items-center py-2 custom-cursor hover:bg-white"
            onClick={_ => onramp.show()}>
            <p className="  text-xxs mr-1"> {`Buy `->React.string} </p>
            <p className=" text-xxs  underline "> {"DAI"->React.string} </p>
            <img src=CONSTANTS.daiDisplayToken.iconUrl className="ml-1 h-3" />
          </div>
        </div>
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

    let form = MintForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
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
            ? Contracts.LongShort.mintLongNextPrice(~marketIndex=market.marketIndex, ~amount)
            : Contracts.LongShort.mintShortNextPrice(~marketIndex=market.marketIndex, ~amount),
        )
      let needsToApprove = isGreaterThanApproval(
        ~amount,
        ~amountApproved=optDaiAmountApproved->Option.getWithDefault(
          Ethers.BigNumber.fromUnsafe("0"),
        ),
      )

      switch needsToApprove {
      | true =>
        setContractActionToCallAfterApproval(_ => mintFunction)
        approveFunction()
      | false => mintFunction()
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
            | false => `Mint ${position} position`
            },
            !form.valid(),
          )
        }
      | _ => (None, `Mint ${position} position`, true)
      }
    }

    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)
    let router = Next.Router.useRouter()

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
      onChangeAmountInput={event => form.updateAmount((_, amount) => {
          amount: amount,
        }, (event->ReactEvent.Form.target)["value"])}
      onMaxClick={_ =>
        form.updateAmount(
          (_, amount) => {
            amount: amount,
          },
          switch optDaiBalance {
          | Some(daiBalance) => daiBalance->Ethers.Utils.formatEther
          | _ => "0"
          },
        )}
      disabled={form.submitting}
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
    <div onClick={_ => router->Next.Router.push(`/app/login?nextPath=${router.asPath}`)}>
      <MintFormInput isLong />
    </div>
  }
}
