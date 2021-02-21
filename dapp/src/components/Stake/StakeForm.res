module StakeForm = %form(
  type input = {amount: string}
  type output = {amount: Ethers.BigNumber.t}

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
  }
)

let initialInput: StakeForm.input = {
  amount: "",
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

@react.component
let make = (~tokenId) => {
  let router = Next.Router.useRouter()
  let tokenId = router.query->Js.Dict.get("tokenId")->Option.getWithDefault(tokenId)
  let token = Queries.SyntheticToken.use({tokenId: tokenId})

  let signer = ContractActions.useSignerExn()

  let (
    contractActionToCallAfterApproval,
    setContractActionToCallAfterApproval,
  ) = React.useState(((), ()) => ())

  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(~signer)
  let (
    contractExecutionHandlerApprove,
    txStateApprove,
    setTxStateApprove,
  ) = ContractActions.useContractFunction(~signer)

  let stakerContractAddress = Config.useStakerAddress()

  let (optTokenBalance, optTokenAmountApproved) = useBalanceAndApproved(
    ~erc20Address=tokenId->Ethers.Utils.getAddressUnsafe,
    ~spender=stakerContractAddress,
  )

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

  let form = StakeForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
    let approveFunction = () =>
      contractExecutionHandlerApprove(
        ~makeContractInstance=Contracts.Erc20.make(~address=tokenId->Ethers.Utils.getAddressUnsafe),
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

  <>
    {switch token {
    | {loading: true} => <Loader />
    | {error: Some(_error)} => {
        Js.log("Unable to fetch token")
        <> {"Unable to fetch token"->React.string} </>
      }
    | {data: Some({syntheticToken: Some(synthetic)})} =>
      <Form
        className=""
        onSubmit={() => {
          form.submit()
        }}>
        <div className="px-8 pt-2">
          <div className="-mb-px flex justify-between">
            <div
              className="no-underline text-teal-dark border-b-2 border-teal-dark tracking-wide font-bold py-3 mr-8"
              href="#">
              {`Stake ↗️`->React.string}
            </div>
            <div
              className="no-underline text-grey-dark border-b-2 border-transparent tracking-wide font-bold py-3"
              href="#">
              {`Unstake ↗️`->React.string}
            </div>
          </div>
        </div>
        <AmountInput
          value={form.input.amount}
          optBalance={optTokenBalance->Option.getWithDefault(0->Ethers.BigNumber.fromInt)}
          disabled=form.submitting
          onBlur={_ => form.blurAmount()}
          onChange={event => form.updateAmount((_, amount) => {
              amount: amount,
            }, (event->ReactEvent.Form.target)["value"])}
          placeholder={"Stake"}
          onMaxClick={_ => form.updateAmount((_, amount) => {
              amount: amount,
            }, switch optTokenBalance {
            | Some(tokenBalance) => tokenBalance->Ethers.Utils.formatEther
            | _ => "0"
            })}
        />
        <Button onClick={_ => ()} variant="large">
          {`Stake ${synthetic.tokenType->Obj.magic} ${synthetic.syntheticMarket.name}`}
        </Button>
      </Form>
    | {data: None, error: None, loading: false} => {
        Js.log(
          "You might think this is impossible, but depending on the situation it might not be!",
        )
        <> </>
      }
    | {data: Some({syntheticToken: None}), error: None, loading: false} => <>
        {"this is not a valid token to stake"->React.string}
      </>
    }}
  </>
}
