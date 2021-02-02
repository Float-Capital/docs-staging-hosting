let contracts = {
  "5": [
    {
      "name": "aDai",
      "address": "0x54Dd8F08aF3822c9620d548773CBB9b165bbDE3D",
    },
    {
      "name": "Dai",
      "address": "0x03a733Bfa29eB0D74DE0Dfd33CCA425E0d8c3867",
    },
    {
      "name": "LongCoins",
      "address": "0x9cBf6D1cc2cb7d1C1d6062C0C6d6AF6CcFeD7106",
    },
    {
      "name": "ShortCoins",
      "address": "0x2B9b35a48A013c441f9E6fC3DE133312a1931d20",
    },
  ],
  "97": [
    {
      "name": "aDai",
      "address": "0x638DEcc5DA992265d799857DE68Ac2F3958a5Ce9",
    },
    {
      "name": "Dai",
      "address": "0x3264369236B39dc8Db9CFAc7360DA0c053F6b6C4",
    },
    {
      "name": "LongCoins",
      "address": "0x119dd3bFe097c25129AD23D625F0092856DFfEa6",
    },
    {
      "name": "ShortCoins",
      "address": "0x76a39Eb4a28CB003b78f5C73141f162b4eF6C722",
    },
  ],
}

module LoginForm = %form(
  type input = {
    address: string,
    amount: string,
    tokenAddress: option<{"address": string, "name": string}>,
  }
  type output = {
    address: Ethers.ethAddress,
    amount: Ethers.BigNumber.t,
    tokenAddress: Ethers.ethAddress,
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
        switch tokenAddress
        ->Option.mapWithDefault("", details => details["address"])
        ->Ethers.Utils.getAddress {
        | Some(validAddress) => Ok(validAddress)
        | None => Error("Address is invalid")
        }
      },
    },
  }
)

let initialInput: LoginForm.input = {
  address: "0x738edd7F6a625C02030DbFca84885b4De5252903",
  amount: "",
  tokenAddress: None,
}

@react.component
let make = () => {
  let (mintTx, txState) = ContractActions.useAdminMint()
  let form = LoginForm.useForm(~initialInput, ~onSubmit=(
    {address, amount, tokenAddress},
    _form,
  ) => {
    Js.log2("Submitted with... ", output)
    mintTx(~recipient=address, ~amount, ~tokenAddress)->Js.log2("other...")

    // Js.Global.setTimeout(() => {
    //   form.notifyOnSuccess(None)
    //   form.reset->Js.Global.setTimeout(3000)->ignore
    // }, 500)->ignore
  })

  <TxTemplate txState>
    <Form
      className=""
      onSubmit={() => {
        Js.log("temp")
        form.submit()
      }}>
      <div className="">
        <h2 className="text-xl"> {"Mint"->React.string} </h2>
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
          <label htmlFor="contractToMinFor"> {"Contract to mint for:"->React.string} </label>
          <select
            name="contractToMinFor"
            id="contractToMinFor"
            disabled=form.submitting
            className="push-lg"
            onBlur={_ => form.blurTokenAddress()}
            onChange={event => form.updateTokenAddress((input, value) => {
                ...input,
                tokenAddress: value,
              }, contracts["5"][
                (event->ReactEvent.Form.target)["value"]->Int.fromString->Option.getWithDefault(0)
              ])}>
            {switch form.input.tokenAddress {
            | Some(_) => React.null
            | None => <option value="999"> {"Select a token"->React.string} </option>
            }}
            {contracts["5"]
            ->Array.mapWithIndex((i, contract) =>
              <option value={i->Int.toString}> {contract["name"]->React.string} </option>
            )
            ->React.array}
          </select>
          {switch form.tokenAddressResult {
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
