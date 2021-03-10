module LongRedeemForm = %form(
  type input = {amount: string}
  type output = {amount: Ethers.BigNumber.t}
  let validators = {
    amount: {
      strategy: OnFirstBlur,
      validate: ({amount}) => {
        let addressRegex = %re(`/^[+]?\d+(\.\d+)?$/`)

        switch amount {
        | "" => Error("Amount is required")
        | _ as value if !(addressRegex->Js.Re.test_(value)) =>
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

let initialInput: LongRedeemForm.input = {
  amount: "",
}

@react.component
let make = (~isLong, ~marketIndex) => {
  let signer = ContractActions.useSignerExn()
  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(~signer)
  let longShortAddres = Config.useLongShortAddress()
  let form = LongRedeemForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
    contractExecutionHandler(
      ~makeContractInstance=Contracts.LongShort.make(~address=longShortAddres),
      ~contractFunction={
        isLong
          ? Contracts.LongShort.redeemLong(~marketIndex, ~tokensToRedeem=amount)
          : Contracts.LongShort.redeemShort(~marketIndex, ~tokensToRedeem=amount)
      },
    )
  })

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
        <h2 className="text-xl"> {`Redeem ${isLong ? "LONG" : "SHORT"} Tokens`->React.string} </h2>
        <div>
          <label htmlFor="amount"> {"Amount: "->React.string} </label>
          <input
            id="amount"
            className="border-2 border-grey-500"
            type_="text"
            value=form.input.amount
            disabled=form.submitting
            onBlur={_ => form.blurAmount()}
            onChange={event =>
              form.updateAmount(
                (_input, value) => {amount: value},
                (event->ReactEvent.Form.target)["value"],
              )}
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
            {(form.submitting ? "Submitting..." : "Submit")->React.string}
          </button>
          {switch form.status {
          | Submitted =>
            <div className={Cn.fromList(list{"form-status", "success"})}>
              {j`✓ Finished Redeeming`->React.string}
            </div>
          | _ => React.null
          }}
        </div>
      </div>
    </Form>
  </TxTemplate>
}
