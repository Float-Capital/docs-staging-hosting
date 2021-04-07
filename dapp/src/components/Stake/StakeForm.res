module StakeForm = %form(
  type input = {amount: string}
  type output = {amount: Ethers.BigNumber.t}

  let validators = {
    amount: {
      strategy: OnFirstSuccessOrFirstBlur,
      validate: ({amount}) => Form.Validators.etherNumberInput(amount),
    },
  }
)

let initialInput: StakeForm.input = {
  amount: "",
}

let useBalanceAndApproved = (~erc20Address, ~spender) => {
  let {Swr.data: optBalance} = ContractHooks.useErc20BalanceRefresh(~erc20Address)
  let {data: optAmountApproved} = ContractHooks.useERC20ApprovedRefresh(~erc20Address, ~spender)
  (optBalance, optAmountApproved)
}

module StakeFormInput = {
  @react.component
  let make = (
    ~onSubmit=_ => (),
    ~value="",
    ~optBalance=None,
    ~buttonDisabled=false,
    ~disabled=false,
    ~onChange=_ => (),
    ~onBlur=_ => (),
    ~onMaxClick=_ => (),
    ~synthetic: Queries.SyntheticTokenInfo.t,
    ~submitButton=<Button> "Login & Stake" </Button>,
  ) =>
    <Form className="mx-auto max-w-3xl" onSubmit>
      // <div className="px-8 pt-2">
      //   <div className="-mb-px flex justify-between">
      //     <div
      //       className="no-underline text-teal-dark border-b-2 border-teal-dark tracking-wide font-bold py-3 mr-8"
      //       href="#">
      //       {`Stake ↗️`->React.string}
      //     </div>
      //     // <div
      //     //   className="no-underline text-grey-dark border-b-2 border-transparent tracking-wide font-bold py-3"
      //     //   href="#">
      //     //   {`Unstake ↗️`->React.string}
      //     // </div>
      //   </div>
      // </div>
      <AmountInput value optBalance disabled onBlur onChange placeholder={"Stake"} onMaxClick />
      {
        // <Button disabled={buttonDisabled}>
        //   {`Stake ${synthetic.tokenType->Obj.magic} ${synthetic.syntheticMarket.name}`}
        // </Button>
        submitButton
      }
    </Form>
}

module ConnectedStakeForm = {
  @react.component
  let make = (~tokenId, ~signer, ~synthetic: Queries.SyntheticTokenInfo.t) => {
    let (
      contractActionToCallAfterApproval,
      setContractActionToCallAfterApproval,
    ) = React.useState(((), ()) => ())

    let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(
      ~signer,
    )
    let (
      contractExecutionHandlerApprove,
      txStateApprove,
      setTxStateApprove,
    ) = ContractActions.useContractFunction(~signer)

    let stakerContractAddress = Config.useStakerAddress()

    let user = RootProvider.useCurrentUserExn()
    let optTokenBalance =
      DataHooks.useSyntheticTokenBalance(
        ~user,
        ~tokenAddress=synthetic.tokenAddress,
      )->DataHooks.Util.graphResponseToOption

    let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)
    let router = Next.Router.useRouter()
    let optCurrentUser = RootProvider.useCurrentUser()
    let userPage = switch optCurrentUser {
    | Some(address) => `/user/${address->Ethers.Utils.ethAdrToLowerStr}`
    | None => `/`
    }

    // Execute the call after approval has completed
    React.useEffect1(() => {
      switch txStateApprove {
      | Created =>
        toastDispatch(
          ToastProvider.Show(`Approve transaction in your wallet`, "", ToastProvider.Info),
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
        toastDispatch(ToastProvider.Show(`Approval transaction pending`, "", ToastProvider.Info))
      | Complete(_) =>
        contractActionToCallAfterApproval()
        setTxStateApprove(_ => ContractActions.UnInitialised)
        toastDispatch(
          ToastProvider.Show(`Approve transaction confirmed`, "", ToastProvider.Success),
        )
      | Failed =>
        toastDispatch(ToastProvider.Show(`The transaction failed`, "", ToastProvider.Error))
      | _ => ()
      }
      None
    }, [txStateApprove])

    React.useEffect1(() => {
      switch txState {
      | Created =>
        toastDispatch(
          ToastProvider.Show(`Confirm the transaction to stake`, "", ToastProvider.Info),
        )
      | SignedAndSubmitted(_) =>
        toastDispatch(ToastProvider.Show(`Staking transaction pending`, "", ToastProvider.Info))
      | Complete(_) =>
        toastDispatch(
          ToastProvider.Show(`Staking transaction confirmed`, "", ToastProvider.Success),
        )
        router->Next.Router.push(userPage)
      | Failed =>
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

    let form = StakeForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
      let approveFunction = () =>
        contractExecutionHandlerApprove(
          ~makeContractInstance=Contracts.Erc20.make(
            ~address=tokenId->Ethers.Utils.getAddressUnsafe,
          ),
          ~contractFunction=Contracts.Erc20.approve(
            ~amount=amount->Ethers.BigNumber.mul(Ethers.BigNumber.fromUnsafe("2")),
            ~spender=stakerContractAddress,
          ),
        )
      let stakeAndEarnImmediatlyFunction = () =>
        contractExecutionHandler(
          ~makeContractInstance=Contracts.Staker.make(~address=stakerContractAddress),
          ~contractFunction=Contracts.Staker.stakeAndEarnImmediately(
            ~tokenAddress=tokenId->Ethers.Utils.getAddressUnsafe,
            ~amount,
          ),
        )

      setContractActionToCallAfterApproval(_ => stakeAndEarnImmediatlyFunction)
      approveFunction()
    })

    let formAmount = switch form.amountResult {
    | Some(Ok(amount)) => Some(amount)
    | _ => None
    }

    let buttonDisabled = {
      let baseFormDisabled = form.submitting || !form.valid()
      switch (formAmount, optTokenBalance) {
      | (Some(amount), Some(amountStaked)) =>
        let greaterThanBalance = amount->Ethers.BigNumber.gt(amountStaked)
        switch greaterThanBalance {
        | true => true
        | false => baseFormDisabled
        }
      | _ => baseFormDisabled
      }
    }

    let tokenToStake = `${synthetic.tokenType->Obj.magic} ${synthetic.syntheticMarket.name}`

    let resetFormButton = () =>
      <Button
        onClick={_ => {
          form.reset()
          setTxStateApprove(_ => ContractActions.UnInitialised)
          setTxState(_ => ContractActions.UnInitialised)
        }}>
        {"Reset & Stake Again"}
      </Button>

    <StakeFormInput
      onSubmit=form.submit
      value={form.input.amount}
      optBalance={optTokenBalance}
      disabled={form.submitting}
      buttonDisabled
      onBlur={_ => form.blurAmount()}
      onChange={event => form.updateAmount((_, amount) => {
          amount: amount,
        }, (event->ReactEvent.Form.target)["value"])}
      onMaxClick={_ =>
        form.updateAmount(
          (_, amount) => {
            amount: amount,
          },
          switch optTokenBalance {
          | Some(tokenBalance) => tokenBalance->Ethers.Utils.formatEther
          | _ => "0"
          },
        )}
      synthetic
      submitButton={<StakeTxStatus
        buttonText={`Stake ${synthetic.tokenType->Obj.magic} ${synthetic.syntheticMarket.name}`}
        resetFormButton
        tokenToStake
        txStateApprove
        txStateStake=txState
        buttonDisabled
      />}
    />
  }
}
@react.component
let make = (~tokenId) => {
  let token = Queries.SyntheticToken.use({tokenId: tokenId})
  let (showLogin, setShowLogin) = React.useState(() => false)
  let optSigner = ContractActions.useSigner()

  switch token {
  | {error: Some(_error)} => {
      Js.log("Unable to fetch token")
      <> {"Unable to fetch token"->React.string} </>
    }
  | {loading: true} => <Loader />
  | {data: Some({syntheticToken: Some(synthetic)})} =>
    switch optSigner {
    | Some(signer) => <ConnectedStakeForm signer tokenId synthetic />
    | None =>
      showLogin
        ? <Login />
        : <div onClick={_ => setShowLogin(_ => true)}>
            <StakeFormInput disabled=true synthetic />
          </div>
    }
  | {data: None, error: None, loading: false}
  | {data: Some({syntheticToken: None}), error: None, loading: false} => <>
      {"Could not find this market - please check the URL carefully."->React.string}
    </>
  }
}
