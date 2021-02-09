<<<<<<< Updated upstream
let useMintContracts = () => {
  let netIdStr = RootProvider.useNetworkId()->Option.mapWithDefault("5", Int.toString)
  let getNetworkedContractAddressString = Config.getContractAddressString(~netIdStr)

  [
    {
      "name": "aDai",
      "address": getNetworkedContractAddressString(~closure=contract => contract.aDai),
    },
    {
      "name": "Dai",
      "address": getNetworkedContractAddressString(~closure=contract => contract.dai),
    },
    {
      "name": "SyntheticToken",
      "address": getNetworkedContractAddressString(~closure=contract => contract.longCoins),
    },
    {
      "name": "ShortCoins",
      "address": getNetworkedContractAddressString(~closure=contract => contract.shortCoins),
    },
  ]
}

module AdminMintForm = %form(
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

let initialInput: AdminMintForm.input = {
  address: "",
  amount: "",
  tokenAddress: None,
}

@react.component
let make = (~ethersWallet) => {
  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(
    ~signer=ethersWallet,
  )

  let contracts = useMintContracts()

  let form = AdminMintForm.useForm(~initialInput, ~onSubmit=(
    {address, amount, tokenAddress},
    _form,
  ) => {
    contractExecutionHandler(
      ~makeContractInstance=Contracts.TestErc20.make(~address=tokenAddress),
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
              }, contracts[
                (event->ReactEvent.Form.target)["value"]->Int.fromString->Option.getWithDefault(0)
              ])}>
            {switch form.input.tokenAddress {
            | Some(_) => React.null
            | None => <option value="999"> {"Select a token"->React.string} </option>
            }}
            {contracts
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
