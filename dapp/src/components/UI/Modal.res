// Styles inspiration:
//     * https://www.creative-tim.com/learning-lab/tailwind-starter-kit/documentation/react/modals/regular
//     * https://tailwindui.com/components/application-ui/overlays/modals

@react.component
let make = (~id, ~closeModal=_ => (), ~title="", ~children) => {
  let (showModal, setShowModal) = React.useState(_ => true)

  React.useEffect1(() => {
    setShowModal(_ => true)
    None
  }, [id])

  let closeButton =
    <button
      className="p-1 ml-auto float-right text-3xl leading-none outline-none focus:outline-none"
      onClick={_ => setShowModal(_ => false)}>
      <span className="opacity-4 block outline-none focus:outline-none">
        {`×`->React.string}
      </span>
    </button>

  showModal
    ? <>
        <div
          onClick=closeModal
          className="justify-center items-center flex overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none">
          <div
            className="relative my-6 mx-auto max-w-3xl p-5 border-0 rounded-sm shadow-lg relative flex flex-col  bg-white outline-none focus:outline-none">
            <div
              onClick={e => {
                e->ReactEvent.Mouse.preventDefault
                e->ReactEvent.Mouse.stopPropagation
              }}>
              {if title != "" {
                <div
                  className="flex items-center justify-between p-2 border-b border-solid border-blueGray-200 rounded-t">
                  <h3 className="text-xl mr-4"> {title->React.string} </h3> {closeButton}
                </div>
              } else {
                closeButton
              }}
            </div>
            <div className="relative px-6 py-2 flex-auto mx-auto"> {children} </div>
          </div>
        </div>
        <div className="opacity-25 fixed inset-0 z-40 bg-black" />
      </>
    : React.null
}
