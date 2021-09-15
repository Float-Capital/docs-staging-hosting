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

let useIsAccreditedStorage = () => {
  open Dom.Storage2
  let key = "isAccredited"
  let (isAccredited, setIsAccredited) = React.useState(_ =>
    localStorage->getItem(key)->Option.getWithDefault("") == "true"
  )

  let setAsAccredited = () => {
    setIsAccredited(_ => true)
    localStorage->setItem(key, "true")
  }

  (isAccredited, setAsAccredited)
}

module AccreditedModal = {
  @react.component
  let make = (~contractFunction) => {
    let _ = contractFunction
    let (isWizard, setIsWizard) = React.useState(_ => false)
    let (isntUs, setIsntUs) = React.useState(_ => false)

    <div className="text-sm w-full flex flex-col space-y-3 mb-4">
      <label
        className="inline-flex items-center space-x-3 cursor-pointer"
        onClick={e => {
          ReactEvent.Mouse.preventDefault(e)
          setIsWizard(a => !a)
        }}>
        <input
          className="form-tick cursor-pointer appearance-none h-6 min-w-6 w-6 border border-gray-300 rounded-md checked:bg-primary-light checked:border-transparent focus:outline-none"
          type_="checkbox"
          key={isWizard ? "1" : "0"}
          value={isWizard ? "1" : "0"}
          checked={isWizard}
        />
        <span>
          <span className="mr-1"> {`I am a DeFi Wizard`->React.string} </span>
          <span className="text-lg mr-1"> {`🧙`->React.string} </span>
          <Tooltip
            tip="I am a professional investor and I am familiar with decentralized finance."
          />
        </span>
      </label>
      <label
        className="inline-flex items-center space-x-3 cursor-pointer"
        onClick={e => {
          ReactEvent.Mouse.preventDefault(e)
          setIsntUs(isntUs => !isntUs)
        }}>
        <input
          className="form-tick cursor-pointer appearance-none h-6 w-6 min-w-6 border border-gray-300 rounded-md checked:bg-primary-light checked:border-transparent focus:outline-none"
          type_="checkbox"
          value={isntUs ? "1" : "0"}
          key={isntUs ? "1" : "0"}
          checked={isntUs}
        />
        <span> {"I confirm that I am not a resident or citizen of the US"->React.string} </span>
      </label>
      <div className="w-full flex justify-center h-12">
        <button
          className={`
            w-44 h-12 text-sm my-2 shadow-md rounded-lg border-2 focus:outline-none border-gray-200 hover:bg-gray-200
            flex justify-center items-center mx-auto
            ${!isWizard || !isntUs
              ? "bg-gray-300 hover:bg-gray-300 shadow-none border-none cursor-auto"
              : ""}
            `}
          onClick={isWizard && isntUs
            ? e => {
                ReactEvent.Mouse.preventDefault(e)
                contractFunction()
              }
            : _ => ()}>
          <span className="mx-2"> {"Confirmed"->React.string} </span>
        </button>
      </div>
    </div>
  }
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
    ~needsToBeAccredited,
    ~contractFunction,
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

    React.useEffect3(_ => {
      switch (needsToBeAccredited, txStateApprove, txStateMint) {
      | (true, _, _) => showModal(<AccreditedModal contractFunction />)
      | (_, ContractActions.Created, _) =>
        showModal(
          <div className="text-center mx-3 my-6">
            <Loader.Ellipses />
            <p> {`Please approve your ${Config.paymentTokenName} token `->React.string} </p>
          </div>,
        )

      | (_, ContractActions.SignedAndSubmitted(txHash), _) =>
        showModal(
          <div className="text-center m-3">
            <div className="m-2"> <Loader.Mini /> </div>
            <p> {"Approval transaction pending... "->React.string} </p>
            <ViewOnBlockExplorer txHash />
          </div>,
        )
      | (_, ContractActions.Complete({transactionHash: _}), ContractActions.Created)
      | (_, ContractActions.Complete({transactionHash: _}), ContractActions.UnInitialised) =>
        showModal(
          <div className="text-center mx-3 my-6">
            <Loader.Ellipses />
            <p> {`Confirm transaction to mint ${tokenToMint}`->React.string} </p>
          </div>,
        )
      | (_, ContractActions.Failed(txHash), _) =>
        showModal(
          <div className="text-center m-3">
            <p> {`The transaction failed.`->React.string} </p>
            <ViewOnBlockExplorer txHash />
            <MessageUsOnDiscord />
          </div>,
        )
      | (_, _, ContractActions.Created) =>
        showModal(
          <div className="text-center m-3">
            <Loader.Ellipses />
            <h1> {`Confirm the transaction to mint ${tokenToMint}`->React.string} </h1>
          </div>,
        )
      | (
          _,
          ContractActions.Complete({transactionHash}),
          ContractActions.SignedAndSubmitted(txHash),
        ) =>
        showModal(
          <div className="text-center m-3">
            <p> {`Approval confirmed 🎉`->React.string} </p>
            <ViewOnBlockExplorer txHash={transactionHash} />
            <h1>
              {`Pending minting ${tokenToMint}`->React.string} <ViewOnBlockExplorer txHash />
            </h1>
          </div>,
        )
      | (_, _, ContractActions.SignedAndSubmitted(txHash)) =>
        showModal(
          <div className="text-center m-3">
            <div className="m-2"> <Loader.Mini /> </div>
            <p> {"Minting transaction pending... "->React.string} </p>
            <ViewOnBlockExplorer txHash />
          </div>,
        )
      | (_, _, ContractActions.Complete({transactionHash: _})) =>
        showModal(
          <div className="text-center m-3">
            <Tick />
            <p> {`Transaction complete 🎉`->React.string} </p>
            <div className="w-full flex justify-center">
              <p className="w-48 text-xs text-center mb-2">
                <span className="text-green-600 ">
                  {`It may take a few minutes for the tokens to show in your wallet`->React.string}
                </span>
                <span className="ml-1">
                  <Tooltip
                    tip="To ensure fairness and security your position will be opened on the next oracle price update"
                  />
                </span>
              </p>
            </div>
            <TweetButton message={randomMintTweetMessage(isLong, marketName)} />
            <Metamask.AddTokenButton
              token={Config.config.contracts.floatToken}
              tokenSymbol={`${isLong ? `↗️` : `↘️`}${marketName}`}
            />
            <ViewProfileButton />
          </div>,
        )
      | (_, _, ContractActions.Declined(_message)) =>
        showModal(
          <div className="text-center m-3">
            <p> {`The transaction was rejected by your wallet`->React.string} </p>
            <MessageUsOnDiscord />
          </div>,
        )
      | (_, _, ContractActions.Failed(txHash)) =>
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
    }, (needsToBeAccredited, txStateMint, txStateApprove))

    switch (needsToBeAccredited, txStateApprove, txStateMint) {
    | (true, _, _)
    | (_, ContractActions.Declined(_), _)
    | (_, ContractActions.Failed(_), _)
    | (_, _, ContractActions.Complete({transactionHash: _}))
    | (_, _, ContractActions.Declined(_))
    | (_, _, ContractActions.Failed(_)) =>
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
      {if Config.networkId == 80001 && router.pathname != "/" {
        <p
          onClick={_ => {
            router->Next.Router.push(`/app/faucet`)
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

    let (isAccredited, setAsAccredited) = useIsAccreditedStorage()
    let (wantsToBeAccredited, setsWantToBeAccredited) = React.useState(_ => false)

    let (optDaiBalance, optDaiAmountApproved) = useBalanceAndApproved(
      ~erc20Address=Config.dai,
      ~spender=Config.longShort,
    )

    let makeContractFunction = amount => {
      () => {
        if !isAccredited {
          setAsAccredited()
        }

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
      }
    }

    let form = MintForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
      if isAccredited {
        makeContractFunction(amount)()
      } else {
        setsWantToBeAccredited(_ => true)
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
          setsWantToBeAccredited(_ => false)
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
        needsToBeAccredited={!isAccredited && wantsToBeAccredited}
        contractFunction={makeContractFunction(formAmount->Option.getWithDefault(CONSTANTS.zeroBN))}
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
