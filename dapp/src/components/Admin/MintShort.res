type inputAmount = {optAmountApproved: option<Ethers.BigNumber.t>, amount: string}
type outputAmount = {requiresApproval: bool, amount: Ethers.BigNumber.t}

module AdminMintForm = %form(
  type input = {amount: inputAmount, optBalance: option<Ethers.BigNumber.t>}
  type output = {amount: outputAmount, optBalance: option<Ethers.BigNumber.t>}

  let validators = {
    amount: {
      strategy: OnFirstBlur,
      validate: ({amount, optBalance}) => {
        let amountRegex = %re(`/^[+]?\d+(\.\d+)?$/`)

        switch amount {
        | {amount: ""} => Error("Amount is required")
        | {amount: value} when !(amountRegex->Js.Re.test_(value)) =>
          Error("Incorrect number format - please use '.' for floating points.")
        | {amount, optAmountApproved} =>
          let checkRequiresApproval = amount =>
            switch optAmountApproved {
            | Some(approved) when approved->Ethers.BigNumber.gte(amount) => false
            | Some(_)
            | None => true
            }

          Ethers.Utils.parseEther(~amount)->Option.mapWithDefault(
            Error("Couldn't parse Ether value"),
            etherValue =>
              switch optBalance {
              | Some(balance) when balance->Ethers.BigNumber.gte(etherValue) =>
                {amount: etherValue, requiresApproval: checkRequiresApproval(etherValue)}->Ok
              | Some(balance) =>
                Error(
                  `You cannot spend more than your balance of ${balance->Ethers.Utils.formatEther}`,
                )
              | None =>
                {amount: etherValue, requiresApproval: checkRequiresApproval(etherValue)}->Ok
              },
          )
        }
      },
    },
    optBalance: {
      strategy: OnFirstBlur,
      validate: ({optBalance}) => {
        optBalance->Ok
      },
    },
  }
)

let initialInput: AdminMintForm.input = {
  amount: {amount: "", optAmountApproved: None},
  optBalance: None,
}

@react.component
let make = (~marketIndex) => {
  let signer = ContractActions.useSignerExn()

  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(~signer)
  let (contractExecutionHandler2, txState2, setTxState2) = ContractActions.useContractFunction(
    ~signer,
  )
  let (functionToExecuteOnce, setFunctionToExecuteOnce) = React.useState(((), ()) => ())

  let shortShortContractAddress = Config.useLongShortAddress()
  let daiAddress = Config.useDaiAddress()
  let {
    data: optAmountApproved,
    isValidating: _isValidating,
    error: _errorLoadingBalance,
    mutate: _mutate,
  } = ContractHooks.useERC20Approved(~erc20Address=daiAddress, ~spender=shortShortContractAddress)

  let form = AdminMintForm.useForm(~initialInput, ~onSubmit=(
    {amount: {amount, requiresApproval}},
    _form,
  ) => {
    let mintFunction = () =>
      contractExecutionHandler(
        ~makeContractInstance=Contracts.LongShort.make(~address=shortShortContractAddress),
        ~contractFunction=Contracts.LongShort.mintShort(~marketIndex, ~amount),
      )
    switch requiresApproval {
    | true =>
      setFunctionToExecuteOnce(_ => mintFunction)
      contractExecutionHandler2(
        ~makeContractInstance=Contracts.Erc20.make(~address=daiAddress),
        ~contractFunction=Contracts.Erc20.approve(
          ~amount=amount->Ethers.BigNumber.mul(Ethers.BigNumber.fromUnsafe("2")),
          ~spender=shortShortContractAddress,
        ),
      )
    | false => mintFunction()
    }
  })

  let {
    Swr.data: optBalance,
    isValidating: _isValidating,
    error: _errorLoadingBalance,
    mutate: _mutate,
  } = ContractHooks.useDaiBalance()

  React.useEffect1(() => {
    form.updateAmount((input, {optAmountApproved}) => {
      {...input, amount: {amount: input.amount.amount, optAmountApproved: optAmountApproved}}
    }, {amount: "", optAmountApproved: optAmountApproved})
    None
  }, [optAmountApproved])

  React.useEffect1(() => {
    form.updateOptBalance((input, value) => {
      {...input, optBalance: value}
    }, optBalance)
    None
  }, [optBalance])

  React.useEffect1(() => {
    switch txState2 {
    | Complete(_) =>
      functionToExecuteOnce()
      setTxState2(_ => ContractActions.UnInitialised)
    | _ => ()
    }
    None
  }, [txState2])

  let requiresApprove = switch form.amountResult {
  | Some(Ok({requiresApproval})) => requiresApproval
  | Some(Error(_))
  | None =>
    // If this hasn't been set we just cheeck if the approved amount is greater than 1
    switch optAmountApproved {
    | Some(amountApproved)
      when amountApproved->Ethers.BigNumber.gte(Ethers.Utils.parseEtherUnsafe(~amount="1")) => false
    | Some(_)
    | None => true
    }
  }
  let submitButtonText = requiresApprove ? "Approve and Mint" : "Mint"

  // TODO: combine these two TxTemplates into a new component specifically for approve first transactions
  <TxTemplate
    txState
    resetTxState={() => {
      form.reset()
      setTxState(_ => ContractActions.UnInitialised)
    }}>
    <TxTemplate txState=txState2>
      <Form
        className=""
        onSubmit={() => {
          form.submit()
        }}>
        <div className="">
          <h2 className="text-xl"> {"Mint Short Tokens"->React.string} </h2>
          <div>
            <label htmlFor="amount"> {"Amount: "->React.string} </label>
            <input
              id="amount"
              className="border-2 border-grey-500"
              type_="text"
              value=form.input.amount.amount
              disabled=form.submitting
              onBlur={_ => form.blurAmount()}
              onChange={event => form.updateAmount((input, value) => {
                  ...input,
                  amount: value,
                }, {
                  amount: (event->ReactEvent.Form.target)["value"],
                  optAmountApproved: optAmountApproved,
                })}
            />
            {switch form.amountResult {
            | Some(Error(message)) => <div className="text-red-600"> {message->React.string} </div>
            | Some(Ok(_)) => <div className="text-green-600"> {j`✓`->React.string} </div>
            | None => React.null
            }}
          </div>
          <div>
            <button
              className={"text-lg disabled:opacity-50 bg-green-500 rounded-lg"}
              disabled=form.submitting>
              {(form.submitting ? "Submitting..." : submitButtonText)->React.string}
            </button>
            {switch form.status {
            | Submitted =>
              <div className={Cn.fromList(list{"form-status", "success"})}>
                {j`✓ Finished Minting`->React.string}
              </div>
            | _ => React.null
            }}
          </div>
        </div>
      </Form>
    </TxTemplate>
  </TxTemplate>
}
