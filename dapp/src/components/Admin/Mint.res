module LoginForm = %form(
  type input = {
    address: string,
    amount: string,
    rememberMe: bool,
  }
  type output = {
    address: Ethers.ethAddress,
    amount: Ethers.BigNumber.t,
    rememberMe: bool,
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
          amount
          ->Ethers.Utils.parseEther
          ->Option.mapWithDefault(Error("Couldn't parse Ether value"), etherValue => etherValue->Ok)
        }
      },
    },
    rememberMe: None,
  }
)

let initialInput: LoginForm.input = {
  address: "",
  amount: "",
  rememberMe: false,
}

@react.component
let make = () => {
  let form = LoginForm.useForm(~initialInput, ~onSubmit=(output, form) => {
    Js.log2("Submitted with:", output)
    Js.Global.setTimeout(() => {
      form.notifyOnSuccess(None)
      form.reset->Js.Global.setTimeout(3000)->ignore
    }, 500)->ignore
  })

  <Form className="form" onSubmit=form.submit>
    <div className="form-messages-area form-messages-area-lg" />
    <div className="form-content">
      <h2 className="push-lg"> {"Login"->React.string} </h2>
      <div className="form-row">
        <label htmlFor="login--address" className="label-lg"> {"Address"->React.string} </label>
        <input
          id="login--address"
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
        | Some(Error(message)) =>
          <div className={Cn.fromList(list{"form-message", "form-message-for-field", "failure"})}>
            {message->React.string}
          </div>
        | Some(Ok(_)) =>
          <div className={Cn.fromList(list{"form-message", "form-message-for-field", "success"})}>
            {j`✓`->React.string}
          </div>
        | None => React.null
        }}
      </div>
      <div className="form-row">
        <label htmlFor="login--amount" className="label-lg"> {"Amount"->React.string} </label>
        <input
          id="login--amount"
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
        | Some(Error(message)) =>
          <div className={Cn.fromList(list{"form-message", "form-message-for-field", "failure"})}>
            {message->React.string}
          </div>
        | Some(Ok(_)) =>
          <div className={Cn.fromList(list{"form-message", "form-message-for-field", "success"})}>
            {j`✓`->React.string}
          </div>
        | None => React.null
        }}
      </div>
      <div className="form-row">
        <input
          id="login--remember"
          type_="checkbox"
          checked=form.input.rememberMe
          disabled=form.submitting
          className="push-lg"
          onBlur={_ => form.blurRememberMe()}
          onChange={event =>
            form.updateRememberMe(
              (input, value) => {...input, rememberMe: value},
              (event->ReactEvent.Form.target)["checked"],
            )}
        />
        <label htmlFor="login--remember"> {"Remember me"->React.string} </label>
      </div>
      <div className="form-row">
        <button className={Cn.fromList(list{"primary", "push-lg"})} disabled=form.submitting>
          {(form.submitting ? "Submitting..." : "Submit")->React.string}
        </button>
        {switch form.status {
        | Submitted =>
          <div className={Cn.fromList(list{"form-status", "success"})}>
            {j`✓ Logged In`->React.string}
          </div>
        | _ => React.null
        }}
      </div>
    </div>
  </Form>
}
