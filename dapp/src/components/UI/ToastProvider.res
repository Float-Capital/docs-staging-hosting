type message = string
type _type = Error | Warning | Info | Success
type action = Show(message) | Hide

module ToastContext = {
  let context = React.createContext("")

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

module DispatchToastContext = {
  let context = React.createContext((_action: action) => ())

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer((_state, action) => {
    switch action {
    | Show(message) => message
    | Hide => ""
    }
  }, "")
  <ToastContext.Provider value=state>
    <DispatchToastContext.Provider value=dispatch>
      <div> {children} </div>
    </DispatchToastContext.Provider>
  </ToastContext.Provider>
}
