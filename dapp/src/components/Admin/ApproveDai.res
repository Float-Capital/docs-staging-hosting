let useDaiContractAddress = () => {
  switch RootProvider.useNetworkId() {
  | Some(97) => "0x3264369236B39dc8Db9CFAc7360DA0c053F6b6C4"
  // | Some(321) => "0xa9e638f77Eea6036D05F00d0AC55169357De114E"
  | Some(5)
  | Some(_)
  | None => "0x03a733Bfa29eB0D74DE0Dfd33CCA425E0d8c3867"
  }->Ethers.Utils.getAddressUnsafe
}

let useLongTokenContractAddress = () => {
  switch RootProvider.useNetworkId(){
    | Some(97) => "0x9cbf6d1cc2cb7d1c1d6062c0c6d6af6ccfed7106" // TO-DO: REPLACE WITH CORRECT
    | Some(5)
    | Some (_)
    | None => "0x9cbf6d1cc2cb7d1c1d6062c0c6d6af6ccfed7106" // GOERLI ADDRESS
  }->Ethers.Utils.getAddressUnsafe
}

let useShortTokenContractAddress = () => {
  switch RootProvider.useNetworkId(){
    | Some(97) => "0x2b9b35a48a013c441f9e6fc3de133312a1931d20" // TO-DO: REPLACE WITH CORRECT
    | Some(5)
    | Some (_)
    | None => "0x2b9b35a48a013c441f9e6fc3de133312a1931d20" // GOERLI ADDRESS
  }->Ethers.Utils.getAddressUnsafe
}

module Erc20ApproveForm = %form(
  type input = {amount: string, tokenAddress: string}
  type output = {amount: Ethers.BigNumber.t, tokenAddress: Ethers.ethAddress}
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
    tokenAddress: {
      strategy: OnFirstBlur,
      validate: ({tokenAddress}) => {
        switch tokenAddress {
          | "LONG" => useLongTokenContractAddress()->Ok
          | "SHORT" => useShortTokenContractAddress()->Ok
          | "DAI" => useDaiContractAddress()->Ok
          | _ as value => Error(value)
        }
      }
    }
  }
)
let selectOpts = ["DAI", "LONG", "SHORT"]

let initialInput: Erc20ApproveForm.input = {
  amount: "",
  tokenAddress: "DAI"
}

@react.component
let make = () => {
  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction()

  let longShortAddress = MintLong.useLongContractAddress()

  let form = Erc20ApproveForm.useForm(~initialInput, ~onSubmit=({amount, tokenAddress}, _form) => {
    contractExecutionHandler(
      ~makeContractInstance=Contracts.Erc20.make(~address=tokenAddress),
      ~contractFunction=Contracts.Erc20.approve(~spender=longShortAddress, ~amount),
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
        <h2 className="text-xl"> {"Approve LongShort to spend your tokens"->React.string} </h2>
        <div>
          <div className="block my-3">
          <label htmlFor="tokenAddress"> {"Choose the token: "->React.string} </label>
          <select 
            name="tokenAddress" 
            id="tokenAddress" 
            onChange={
              event=>form.updateTokenAddress(
                (_input, value) => {amount: _input.amount, tokenAddress: value},
                (event->ReactEvent.Form.target)["value"],
              )
            }
            onBlur={_ => form.blurAmount()}
            disabled=form.submitting
          >
          {
            selectOpts->Belt_Array.map(selectOptName => {
              <option>
              {selectOptName->React.string}
              </option>
            })->React.array
          }
          </select>
          </div>

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
                (_input, value) => {amount: value, tokenAddress:_input.tokenAddress},
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
              {j`✓ Finished Approving`->React.string}
            </div>
          | _ => React.null
          }}
        </div>
      </div>
    </Form>
  </TxTemplate>
}
