@react.component
let make = () => {
  let toastMessage = React.useContext(ToastProvider.ToastContext.context)
  let toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context)

  React.useEffect1(() => {
    let timeout = Js.Global.setTimeout(() => {
      toastDispatch(Hide)
    }, 3000)
    Some(() => Js.Global.clearTimeout(timeout))
  }, [toastMessage])

  <div
    className="fixed bottom-3 flex flex-col transition-all duration-700"
    style={ReactDOM.Style.make(~display=toastMessage->String.length > 0 ? "block" : "none", ())}>
    <div className="text-xl bg-white bg-opacity-80 my-4 mx-10 py-2 px-4">
      <span className="animate-ping inline-flex h-3 w-3 mr-2 rounded-full bg-blue-400 opacity-75" />
      {toastMessage->React.string}
    </div>
  </div>
}
