module AdminMintForm = %form(
  type input = {amount: string}
  type output = {amount: Ethers.BigNumber.t}
  let validators = {
    amount: {
      strategy: OnFirstBlur,
      validate: ({amount}) => {
        let addressRegex = %bs.re(`/^[+]?\d+(\.\d+)?$/`)

        switch amount {
        | "" => Error("Amount is required")
        | _ as value when !(addressRegex->Js.Re.test_(value)) =>
          Error("Incorrect number format - please use '.' for floating points.")
        | _ =>
          Ethers.Utils.parseEther(~amount)->Option.mapWithDefault(
            Error("Couldn't parse Ether value"),
            etherValue => etherValue->Ok,
          )
        }
      },
    },
  }
)

let initialInput: AdminMintForm.input = {
  amount: "",
}

@react.component
let make = (~marketIndex, ~isLong) => {
  let signer = ContractActions.useSignerExn()

  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(~signer)

  let longShortContractAddress = Config.useLongShortAddress()
  let daiAddress = Config.useDaiAddress()
  let {
    data: optAmountApproved,
    isValidating: _isValidating,
    error: _errorLoadingBalance,
    mutate: _mutate,
  } = ContractHooks.useERC20Approved(~erc20Address=daiAddress, ~spender=longShortContractAddress)

  let form = AdminMintForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
    contractExecutionHandler(
      ~makeContractInstance=Contracts.LongShort.make(~address=longShortContractAddress),
      ~contractFunction=isLong
        ? Contracts.LongShort.mintShortAndStake(~marketIndex, ~amount)
        : Contracts.LongShort.mintLongAndStake(~marketIndex, ~amount),
    )
  })

  let submitButton = () =>
    <button
      className={"text-lg disabled:opacity-50 bg-green-500 rounded-lg"} disabled=form.submitting>
      {(form.submitting ? "Submitting..." : "Mint & Stake")->React.string}
    </button>

  // TODO: combine these two TxTemplates into a new component specifically for approve first transactions
  switch optAmountApproved {
  | Some(approvedAmount) =>
    <TxTemplate
      txState
      resetTxState={() => {
        form.reset()
        setTxState(_ => ContractActions.UnInitialised)
      }}>
      <Form
        className=""
        onSubmit={() => {
          form.submit()
        }}>
        <div className="">
          <h2 className="text-xl">
            {`Mint & Stake ${isLong ? "LONG" : "SHORT"} Tokens`->React.string}
          </h2>
          <div>
            <label htmlFor="amount"> {"Amount: "->React.string} </label>
            <input
              id="amount"
              className="border-2 border-grey-500"
              type_="text"
              value=form.input.amount
              disabled=form.submitting
              onBlur={_ => form.blurAmount()}
              onChange={event => form.updateAmount((_input, value) => {
                  amount: value,
                }, (event->ReactEvent.Form.target)["value"])}
            />
            {switch form.amountResult {
            | Some(Error(message)) => <div className="text-red-600"> {message->React.string} </div>
            | Some(Ok(_)) => <div className="text-green-600"> {j`✓`->React.string} </div>
            | None => React.null
            }}
          </div>
          <div>
            {switch form.amountResult {
            | Some(Ok(amount)) =>
              approvedAmount->Ethers.BigNumber.gte(amount)
                ? submitButton()
                : <p> {"THIS IS MORE THAN YOU HAVE APPROVED"->React.string} </p>
            | _ => submitButton()
            }}
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
  | None => <p> {"Loading approval"->React.string} </p>
  }
}
