let useLongContractAddress = () => {
  switch RootProvider.useNetworkId() {
  | Some(97) => "0x60250481EcE03F321c12134FACC0fDfA9F95012C"
  | Some(321) => "0xa9e638f77Eea6036D05F00d0AC55169357De114E"
  | Some(5)
  | Some(_)
  | None => "0x0dFD477dD71664821DE0c376DD23c3dcdE207448"
  }->Ethers.Utils.getAddressUnsafe
}

module ShortRedeemForm = %form(
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

let initialInput: ShortRedeemForm.input = {
  amount: "",
}

@react.component
let make = () => {
  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction()

  let tokenAddress = useLongContractAddress()

  let form = ShortRedeemForm.useForm(~initialInput, ~onSubmit=({amount}, _form) => {
    contractExecutionHandler(
      ~makeContractInstance=Contracts.LongShort.make(~address=tokenAddress),
      ~contractFunction=Contracts.LongShort.redeemShort(~tokensToRedeem=amount),
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
        Js.log("temp")
        form.submit()
      }}>
      <div className="">
        <h2 className="text-xl"> {"Redeem Short Tokens"->React.string} </h2>
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
