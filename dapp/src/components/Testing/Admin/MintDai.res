module AdminMintForm = %form(
  type input = {
    address: string,
    amount: string,
  }
  type output = {
    address: Ethers.ethAddress,
    amount: Ethers.BigNumber.t,
  }
  let validators = {
    address: {
      strategy: OnFirstSuccessOrFirstBlur,
      validate: ({address}) => {
        switch address->Ethers.Utils.getAddress {
        | Some(validAddress) => Ok(validAddress)
        | None => Error("Address is invalid")
        }
      },
    },
    amount: {
      strategy: OnFirstBlur,
      validate: ({amount}) => Form.Validators.etherNumberInput(amount),
    },
  }
)

let initialInput: AdminMintForm.input = {
  address: "",
  amount: "",
}

@react.component
let make = (~ethersWallet) => {
  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(
    ~signer=ethersWallet,
  )

  let form = AdminMintForm.useForm(~initialInput, ~onSubmit=({address, amount}, _form) => {
    contractExecutionHandler(
      ~makeContractInstance=Contracts.TestErc20.make(~address=Config.dai),
      ~contractFunction=Contracts.TestErc20.mint(~recipient=address, ~amount),
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
        <h2 className="text-xl"> {"Mint DAI"->React.string} </h2>
        <div className="">
          <label htmlFor="address"> {"Address: "->React.string} </label>
          <input
            className="border-2 border-grey-500"
            id="address"
            type_="text"
            value=form.input.address
            disabled=form.submitting
            onBlur={_ => form.blurAddress()}
            onChange={event =>
              form.updateAddress(
                (input, value) => {...input, address: value},
                (event->ReactEvent.Form.target)["value"],
              )}
          />
          {switch form.addressResult {
          | Some(Error(message)) => <div className="text-red-600"> {message->React.string} </div>
          | Some(Ok(_)) => <div className="text-green-600"> {j`✓`->React.string} </div>
          | None => React.null
          }}
        </div>
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
                (input, value) => {...input, amount: value},
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
              {j`✓ Finished Minting`->React.string}
            </div>
          | _ => React.null
          }}
        </div>
      </div>
    </Form>
  </TxTemplate>
}
